//
//  GXPhotoBrowseController.m
//  GXApp
//
//  Created by 王振 on 16/8/13.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXPhotoBrowseController.h"
#import "GXImageSizeTool.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageCompat.h"
#import <CommonCrypto/CommonDigest.h>
@interface GXPhotoBrowseController ()<UIScrollViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    CGFloat _lastScale;//记录最后一次的图片放大倍数
}
@property (nonatomic,strong)UIScrollView *scrollow;
@property (nonatomic,strong)UIScrollView *scaleScrollow;
/**用于放大 缩小 图片的scrollview*/
@property (nonatomic, strong) UIScrollView * scaleScrollView;
/**用于显示 放大缩小的 图片*/
@property (nonatomic, strong) UIImageView * scaleImgV;
@property (nonatomic, assign) BOOL doubleAction;

@end
@implementation GXPhotoBrowseController
{
    NSString* diskCachePath;
    NSMutableArray *_imgArray;//存储所有图片的数组
    UIPageControl *_pageControl;
}
-(instancetype)init{
    if (self = [super init]) {
        [self creatScrollow];
        _imgArray = [NSMutableArray new];
    }return self;
}
//创建大Scrollow切换图片
-(void)creatScrollow{
    self.scrollow = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollow.delegate = self;
    _scrollow.pagingEnabled = YES;
    _scrollow.contentSize = CGSizeMake(GXScreenWidth * 5 , 0);
    _scrollow.backgroundColor = [UIColor clearColor];
    _scrollow.bounces = YES;
    _lastScale = 1.0;
    _scrollow.backgroundColor = [UIColor blackColor];
    _scrollow.contentSize = CGSizeMake(GXScreenWidth, GXScreenHeight);
    [self.view addSubview:self.scrollow];
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
    _pageControl.enabled = NO;
    [self.view addSubview:_pageControl];
    [self.view bringSubviewToFront:_pageControl];
    self.currentIndex = -1;
}
//图片setter方法
-(void)setImgUrlArray:(NSMutableArray *)imgUrlArray{
    if (_imgUrlArray != imgUrlArray) {
        _imgUrlArray = imgUrlArray;
        self.scrollow.contentSize = CGSizeMake(GXScreenWidth * imgUrlArray.count, GXScreenHeight);
        _pageControl.numberOfPages = imgUrlArray.count ;
        _pageControl.frame =  CGRectMake(GXScreenWidth/2 - 10 * imgUrlArray.count, GXScreenHeight - 30, 20 * imgUrlArray.count, 10);
        for (int i = 0; i < imgUrlArray.count; i++) {
            NSURL *imgUrl1 = [NSURL URLWithString:imgUrlArray[i]];
            //根据imgUrl获取图片的宽高
            CGSize imgSize = [GXImageSizeTool getImageSizeWithURL:imgUrlArray[i]];
            CGFloat imgHeight = GXScreenWidth *imgSize.height / imgSize.width;
            if (imgSize.height == 0) {
                imgHeight = GXScreenWidth * 3 / 4;
            }
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, (GXScreenHeight - imgHeight) / 2, GXScreenWidth, imgHeight)];
            if (imgHeight > GXScreenHeight) {
                img.y = 0;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self setImgTo:img Url:imgUrl1];//附图片
            });
            //创建小Scrollow用于图片缩放
            self.scaleScrollow = [[UIScrollView alloc]initWithFrame:CGRectMake(i * GXScreenWidth, 0, GXScreenWidth, GXScreenHeight)];
            self.scaleScrollow .backgroundColor = [UIColor blackColor];
            self.scaleScrollow .contentSize = CGSizeMake(img.width, img.height);
            self.scaleScrollow .delegate = self;
            self.scaleScrollow .maximumZoomScale = 5.0;
            self.scaleScrollow .minimumZoomScale = 1;
            [self.scrollow addSubview:self.scaleScrollow ];
            [self.scaleScrollow  addSubview:img];
            [_imgArray addObject:img];
            //给图片添加双击手势
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
            doubleTap.numberOfTapsRequired = 2;
            [self.scaleScrollow  addGestureRecognizer:doubleTap];
            //单击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismiss)];
            tap.numberOfTapsRequired = 1;
            [self.scaleScrollow addGestureRecognizer:tap];
            //判断单击还是双击
            [tap requireGestureRecognizerToFail: doubleTap];
            //长按手势
            UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
            longGes.minimumPressDuration = 0.9;
            img.userInteractionEnabled = YES;
            [img addGestureRecognizer:longGes];
        }
    }
}
-(void)tapDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setImgTo:(UIImageView *)img Url:(NSURL *)url{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    //判断是否缓存过
    BOOL isCached = [manager cachedImageExistsForURL:url];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.frame = CGRectMake(0, 0, 30, 30);
    indicator.center = img.center;
    indicator.y = img.height / 2 - 15;
    [img addSubview:indicator];
    [indicator hidesWhenStopped];
    if (isCached) {
        //如果缓存直接从缓存赋值
        NSString *cacheImageKey = [manager cacheKeyForURL:url];
        UIImage *diskImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheImageKey];
        img.image = diskImg;
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [manager downloadImageWithURL:url options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                [indicator startAnimating];
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                img.image = image;
                [indicator stopAnimating];
            }];
        });
    }
}
-(void)setImgUrl:(NSString *)imgUrl{
    if (_imgUrl != imgUrl) {
        _imgUrl = imgUrl;
        CGSize imgSize = [GXImageSizeTool getImageSizeWithURL:imgUrl];
        CGFloat imgHeight = GXScreenWidth * imgSize.height / imgSize.width;
        if (self.imgUrlArray == nil) {
            _pageControl.alpha = 0;
            if (imgSize.height == 0) {
                imgHeight = GXScreenWidth * 3 / 4;
            }
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.scrollow.height - imgHeight) / 2 , self.scrollow.width, imgHeight)];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self setImgTo:img Url:[NSURL URLWithString:imgUrl]];
            });
        }else{
            _pageControl.alpha = 1;
            NSInteger index = [self.imgUrlArray indexOfObject:imgUrl];
            _pageControl.currentPage = index;
            self.currentIndex = index;
            [self.scrollow setContentOffset:CGPointMake(GXScreenWidth * index, 0)];
        }
    }
}
#pragma mark - 手势方法
//双击手势
-(void)doubleTapAction:(UITapGestureRecognizer *)tapGes{
    if ([(UIScrollView *)tapGes.view zoomScale] != 1.0) {
        [(UIScrollView *)tapGes.view setZoomScale:1.0 animated:YES];
    }else{
        [(UIScrollView *)tapGes.view setZoomScale:2.0 animated:YES];
    }
}
//长按手势
-(void)longPressAction:(UITapGestureRecognizer *)longGes{
    UIImageView *currentImg = (UIImageView *)longGes.view;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"保存图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //保存至相册
        UIImageWriteToSavedPhotosAlbum(currentImg.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取 消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        return;
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//完成保存的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {//提示已保存至手机
        [self.view showSuccessWithTitle:@"已保存至手机"];
    }else{
        [self.view showFailWithTitle:@"保存失败"];
    }
}
#pragma mark - scrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage = scrollView.contentOffset.x / GXScreenWidth;
    if ([scrollView isEqual:self.scrollow] && self.currentIndex != _pageControl.currentPage) {
        //恢复比例
        for (UIScrollView *subScroll in scrollView.subviews) {
            if (subScroll.x == _pageControl.currentPage * GXScreenWidth) {
                [UIView animateWithDuration:0.5 animations:^{
                    subScroll.zoomScale = 1.0;
                }];
            }
        }
        self.currentIndex = _pageControl.currentPage;
    }
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    UIImageView *img = _imgArray[self.currentIndex];
    img.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for (UIView *view in scrollView.subviews) {
        return view;
    }
    return nil;
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    UIImageView *img = _imgArray[self.currentIndex];
    if (img.height < GXScreenHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, (img.y) * scale, 0);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

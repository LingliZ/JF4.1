//
//  GXGlobalArticleDetailController.m
//  GXApp
//
//  Created by GXJF on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXAccountDetailWebViewController.h"
#import "GXArticleDetailModel.h"
#import "GXAdaptiveHeightTool.h"
//#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "GXActionSheetView.h"
#import "GXPhotoBrowseController.h"
//#import "HWFullImgViewController.h"

@interface GXAccountDetailWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIView *bgView;
    UIImageView *imgView;
}
@property (nonatomic,strong)NSString *shareImgUrl;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *describtionStr;
@property (nonatomic,strong)GXArticleDetailModel *model;

//分享跳转的链接
@property (nonatomic,strong)NSString *shareDetailUrl;
//分享的内容摘要加跳转链接

//保存图片的数组
@property (nonatomic,strong)NSMutableArray *mUrlArray;

@end

@implementation GXAccountDetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.informationModel){
        self.articleID = self.informationModel.ID;
        self.shareImgUrl = self.informationModel.imgurl;
    }else{
        NSLog(@"传参错误");
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
  
    
    //跳转链接
    self.shareDetailUrl = [NSString stringWithFormat:@"http://m.91guoxin.com/index/detail/i/%@.html",self.model.ID];
    self.detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64)];
    self.detailWebView.delegate = self;
    self.detailWebView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    //    self.detailWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.detailWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.detailWebView];
    [self loadArticleDetailDataFromServer];
    //分享按钮
//    UIImage *shareImage = [[UIImage imageNamed:@"share_pic"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage: shareImage style:UIBarButtonItemStylePlain target:self action:@selector(didClickShareItemAction:)];
//    self.navigationItem.rightBarButtonItem = shareItem;
}
//先请求网络数据然后webView加载html
- (void)loadArticleDetailDataFromServer{
    //    if ([GXUserInfoTool isConnectToNetwork]) {
    //        [self.view showLoadingWithTitle:@"文章正在加载,请稍后"];
    //    }
    NSDictionary *idDict = @{@"id":self.articleID};
    [GXHttpTool POSTCache:GXUrl_articleDetail parameters:idDict success:^(id responseObject) {
        //[self.view removeTipView];
        if ([(NSNumber *)responseObject[@"success"] intValue] == 1) {
            NSDictionary *valueDict = responseObject[@"value"];
            self.model = [GXArticleDetailModel new];
            [self.model setValuesForKeysWithDictionary:valueDict];
            NSString *dateStr = [GXAdaptiveHeightTool getDateStyle:self.model.created];
            NSString *htmlStr = [GXAdaptiveHeightTool htmlWithContent:self.model.introtext title:self.model.title adddate:dateStr author:self.model.author source:self.model.xreference];
            
            self.titleStr = self.model.title;
            
            //self.describtionStr = model.metadesc;
            self.describtionStr = [NSString stringWithFormat:@"%@ %@",self.model.metadesc,self.shareDetailUrl];
            [self.detailWebView loadHTMLString:htmlStr baseURL:nil];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        if (self.model == nil) {
            //            [self showErrorNetMsg:nil Handler:^{
            //                [self loadArticleDetailDataFromServer];
            //            }];
        }
    }];
}
/*
 *分享title
 *分享detail + 跳转链接
 *分享url图片
 */
//分享事件
- (void)didClickShareItemAction:(UIBarButtonItem *)item{
    if ([GXUserInfoTool isConnectToNetwork]) {
        NSArray *titlearr = @[@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间"];
        NSArray *imageArr = @[@"wechat_friends",@"circle_of_friends",@"qq_friends",@"qq_space_pic"];
        
        GXActionSheetView *actionsheet = [[GXActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsOneLineScrollowStyle];
        [actionsheet setBtnClick:^(NSInteger btnTag) {
            switch (btnTag) {
                case 0:
                {//微信
                
                }
                    break;
                case 1:
                {//微信朋友圈

                }
                    break;
                case 2:
                {//QQ

                }
                    break;
                case 3:
                {//QQ空间
                
                }
                    break;
                default:
                    break;
            }
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
    }else{
        [self.view showFailWithTitle:@"请确保网络连接后重试"];
    }
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.view.userInteractionEnabled = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    //这里是js，主要目的实现对url的获取
    static  NSString * const js1GetImages =
    @"function getImagesArray(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:js1GetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImagesArray()"];
    self.mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    if (self.mUrlArray .count >= 2) {
        [self.mUrlArray  removeLastObject];
    }
    self.view.userInteractionEnabled = YES;
    //NSLog(@"获取到的图片数组是:%@",self.mUrlArray);
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //    NSLog(@"requestString is %@",requestString);
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        //NSLog(@"点击的image url------%@", imageUrl);
        GXPhotoBrowseController *photoBrowseVC = [[GXPhotoBrowseController alloc]init];
        photoBrowseVC.imgUrlArray = self.mUrlArray;
        photoBrowseVC.imgUrl = imageUrl;
        photoBrowseVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:photoBrowseVC animated:YES completion:nil];
        
        
        return NO;
        //[self showBigImage:imageUrl];//创建视图并显示图片
    }
    return YES;
}

@end

//
//  GXGuidePageController.m
//  GXApp
//
//  Created by 王振 on 16/8/16.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXGuidePageController.h"
#import "SDCycleScrollView.h"
#import "GXTabBarController.h"
#import "GXLoginByVertyViewController.h"
// 字体20
#define guideFontSize20 (IS_IPHONE_6 ? 23:(IS_IPHONE_6P ? 25:21))
#define guideFontSize17 (IS_IPHONE_6 ? 15:(IS_IPHONE_6P ? 17:13))
@interface GXGuidePageController ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,GXCycleScrollViewDelegate>

@property (nonatomic,strong)NSArray *imagesArray;
@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)UIScrollView *guideCycleView;
@property (nonatomic,strong)UIPageControl *guidePageControl;
@property (nonatomic,strong)UICollectionView *cycleCollectionView;
@end

@implementation GXGuidePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *imagesArray = @[@"guidePage1",@"guidePage2",@"guidePage3",@"guidePage4"];
    self.imagesArray = imagesArray;
    //自定义轮播
    self.guideCycleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
    self.guideCycleView.backgroundColor = [UIColor whiteColor];
    self.guideCycleView.contentSize = CGSizeMake(GXScreenWidth * 4, 0);
    self.guideCycleView.delegate = self;
    self.guideCycleView.userInteractionEnabled = YES;
    self.guideCycleView.pagingEnabled = YES;
    self.guideCycleView.showsHorizontalScrollIndicator = NO;
    self.guideCycleView.bounces = NO;
    for (int i = 0; i < self.imagesArray.count; i++) {
        UIImageView *guideImgView = [[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth * i, 0, GXScreenWidth, GXScreenHeight)];
        guideImgView.userInteractionEnabled = YES;
        guideImgView.image = [UIImage imageNamed:self.imagesArray[i]];
        [self.guideCycleView addSubview:guideImgView];
    }
    [self creatUI];
//    [self creatPage];
}
- (BOOL)shouldAutorotate
{
    return NO;
    //return [self.viewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return  UIInterfaceOrientationPortrait ;
}

- (void)creatPage {
    self.guidePageControl = [[UIPageControl alloc] init];
    [self.view addSubview:self.guidePageControl];
    [self.view bringSubviewToFront:self.guidePageControl];
    [self.guidePageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).equalTo(@ - 30);
        make.width.mas_equalTo(GXScreenWidth);
        make.height.mas_equalTo(10);
    }];
        self.guidePageControl.numberOfPages = self.imagesArray.count;
    self.guidePageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xFF8C00);
    self.guidePageControl.pageIndicatorTintColor = UIColorFromRGB(0xE7E7E7);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"");
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    if (self.guideCycleView.contentOffset.x >= GXScreenWidth * 2.5) {
//        self.guidePageControl.hidden = YES;
//    }else{
//        if (self.guideCycleView.contentOffset.x <= GXScreenWidth * 2.5) {
//            self.guidePageControl.hidden = NO;
//            self.guidePageControl.currentPage = (self.guideCycleView.contentOffset.x + (GXScreenWidth * 0.5)) / GXScreenWidth;
//        }
//    }
}
-(void)creatUI{
    //登录
    self.guideLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.guideLoginBtn setBackgroundImage:[UIImage imageNamed:@"guidePageBtn"] forState:UIControlStateNormal];
    [self.guideLoginBtn addTarget:self action:@selector(didClickGuideLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    //跳过
    self.guideJumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.guideJumpBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [self.guideJumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.guideJumpBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    [self.guideJumpBtn addTarget:self action:@selector(didClickGuideJumpBtn:) forControlEvents:UIControlEventTouchUpInside];
//    BOOL isONEBtn =
    self.guideJumpBtn.hidden = isOnlyLoginBtn;

    //添加控件
    [self.guideCycleView addSubview:self.guideLoginBtn];
    [self.guideCycleView addSubview:self.guideJumpBtn];
    [self.view addSubview:self.guideCycleView];
    [self.guideLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-HeightScale_IOS6(124));
        make.left.equalTo(self.guideCycleView.mas_left).offset(GXScreenWidth * 3 +((GXScreenWidth - WidthScale_IOS6(300))/2));
        make.width.equalTo(@WidthScale_IOS6(300));
        make.height.equalTo(@HeightScale_IOS6(38));
    }];
    [self.guideJumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-HeightScale_IOS6(80));
        make.left.equalTo(self.guideCycleView.mas_left).offset(GXScreenWidth * 3 + WidthScale_IOS6(155));
        make.height.equalTo(@HeightScale_IOS6(18));
        make.width.equalTo(@WidthScale_IOS6(65));
    }];
}
//登录按钮
- (void)didClickGuideLoginBtn:(UIButton *)sender {
    GXTabBarController *tabbarVC = [[GXTabBarController alloc] init];
    GXKeyWindow.rootViewController = tabbarVC;
    GXLoginByVertyViewController *loginVC = [[GXLoginByVertyViewController alloc]init];
    UINavigationController * nav=[tabbarVC.childViewControllers objectAtIndex:0] ;
    [nav pushViewController:loginVC animated:NO ];
}
//引导页跳过按钮
- (void)didClickGuideJumpBtn:(UIButton *)sender {
    GXTabBarController *tabbarVC = [[GXTabBarController alloc] init];
    GXKeyWindow.rootViewController = tabbarVC;  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

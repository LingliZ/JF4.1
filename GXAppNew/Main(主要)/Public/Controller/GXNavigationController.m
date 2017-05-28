//
//  GXNavigationController.m
//  demo
//
//  Created by yangfutang on 16/5/9.//test
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXNavigationController.h"
#import "UIBarButtonItem+item.h"




@interface GXNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) id GestureRecognizerDelegate;

@end

@implementation GXNavigationController

+ (void)initialize {
    
    UIBarButtonItem *barbutton = [UIBarButtonItem appearance];
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = GXNavigationBarTitleColor;
    att[NSFontAttributeName] = GXFONT_PingFangSC_Light(GXFitFontSize14);
    [barbutton setTitleTextAttributes:att forState:UIControlStateNormal];
    
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:ThemeBlack_Color];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(GXFitFontSize16),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.GestureRecognizerDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = _GestureRecognizerDelegate;
    } else {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 不是根视图控制器
    if (self.viewControllers.count != 0) {
        // 设置导航条的按钮
        UIBarButtonItem *left = [UIBarButtonItem MyBarButtonItem:[UIImage imageNamed:@"navigationbar_back"] helited:[UIImage imageNamed:@"navigationbar_back"] target:self action:@selector(popToPre) forcontroEvent:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = left;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)popToRoot {
    [self popToRootViewControllerAnimated:YES];
}


- (void)popToPre {
    [self popViewControllerAnimated:YES];
}



-(BOOL)shouldAutorotate{
    
    return NO;
}
////
////支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//
////一开始的方向  很重要
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationMaskPortrait;
//}






@end

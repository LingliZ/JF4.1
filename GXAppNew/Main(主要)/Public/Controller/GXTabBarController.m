//
//  GXTabBarController.m
//  demo
//
//  Created by yangfutang on 16/5/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXTabBarController.h"
#import "GXHomeController.h"
#import "GXDiscoverController.h"
#import "GXMineController.h"
#import "GXNavigationController.h"
#import "GXLiveController.h"
#import "UIImage+Tabbar.h"
#import "GXPriceListController.h"
#import "GXDealController.h"
#import "GXDealController.h"

@interface GXTabBarController ()<UITabBarDelegate>

@end

@implementation GXTabBarController

// 设置颜色
+ (void)initialize {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UITabBarItem *item = [UITabBarItem appearance];
    NSMutableDictionary *attrubute = [NSMutableDictionary dictionary];
    attrubute[NSForegroundColorAttributeName] = UIColorFromRGB(0x4082F4);
    [item setTitleTextAttributes:attrubute forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage) name:DKNightVersionThemeChangingNotificaiton object:nil];
    UITabBar *tabBar = self.tabBar;
    UIView *sepV = [[UIView alloc] init];
    sepV.backgroundColor = GXRGBColor(24, 24, 32);
    sepV.dk_backgroundColorPicker = DKColorPickerWithColors(UIColorFromRGB(0xEEEEEE),GXRGBColor(24, 24, 32));
    sepV.frame = CGRectMake(0, 0, GXScreenWidth, 0.5);
    [tabBar addSubview:sepV];
//    tabBar.barTintColor = GXRGBColor(44, 47, 59);
//    tabBar.dk_barTintColorPicker = DKColorPickerWithColors(GXRGBColor(255, 255, 255),GXRGBColor(45, 47, 59));
//    tabBar.tintColor = [UIColor whiteColor];
    [self addChildControllers];
}



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    switch (item.tag) {
        case 0:
            [MobClick event:@"menu_home"];
            break;
        case 1:
            [MobClick event:@"menu_market"];
            break;
        case 2:
            [MobClick event:@"menu_live"];
            break;
        case 3:
            [MobClick event:@"menu_trading"];
            break;
        case 4:
            [MobClick event:@"menu_find"];
            break;
        default:
            break;
    }

}


- (void)changeImage{
    //@"com.dknightversion.manager.themeversion" //DKNightVersionCurrentThemeVersionKey // DKNightVersionCurrentThemeVersionKey;
    
    DKThemeVersion *themeVersion = [GXUserdefult objectForKey: @"com.dknightversion.manager.themeversion"];
    if ([themeVersion isEqualToString:DKThemeVersionNormal]) {
        self.tabBar.barTintColor = GXHomeDKWhiteColor;
        [self.childViewControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *vc = obj.topViewController;
            switch (idx) {
                case 0:
                    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_home_select_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    break;
                case 1:
                    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_price_select_white_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    break;
                case 2:
                    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_live_select_white_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    break;
                case 3:
                    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_trade_select_white_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    break;
                case 4:
                    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_find_select_white_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    break;
                    
                default:
                    break;
            }
        }];
    }else {
        self.tabBar.barTintColor = GXHomeDKBlackColor;
        [self.childViewControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *vc = obj.topViewController;
            switch (idx) {
                case 0:{
                    UIImage *homeImg =  [[UIImage imageNamed:@"home_home_select_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    vc.tabBarItem.selectedImage = homeImg;}
                    break;
                case 1:
                    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_price_select_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    break;
                case 2:
                    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_live_select_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    break;
                case 3:
                    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_trade_select_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    break;
                case 4:
                    vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_find_select_pic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                    break;
                    
                default:
                    break;
            }
        }];
    }
}

- (void)addChildControllers{
    [self addChildViewController:[[GXHomeController alloc] init] imageNormalName:@"home_home_unselect_pic" imageSelectedName:@"home_home_select_pic" title:@"首页" isTopHidden: true];
    [self addChildViewController:[[GXPriceListController alloc] init] imageNormalName:@"home_price_unselect_pic" imageSelectedName:@"home_price_select_white_pic" title:@"行情" isTopHidden: true];
    [self addChildViewController:[[GXLiveController alloc] init] imageNormalName:@"home_live_unselect_pic" imageSelectedName:@"home_live_select_white_pic" title:@"直播" isTopHidden: false];
    [self addChildViewController:[[GXDealController alloc] init] imageNormalName:@"home_trade_unselect_pic" imageSelectedName:@"home_trade_select_white_pic" title:@"交易" isTopHidden: false];
    [self addChildViewController:[[GXDiscoverController alloc] init] imageNormalName:@"home_find_unselect_pic" imageSelectedName:@"home_find_select_white_pic" title:@"服务" isTopHidden: false];
}

- (void)addChildViewController:(UIViewController *)childController imageNormalName:(NSString *)normalName imageSelectedName: (NSString *)selectedName title: (NSString *)title isTopHidden: (BOOL) hidden{
    GXNavigationController *nav = [[GXNavigationController alloc] initWithRootViewController:childController];
    childController.tabBarItem.image = [[UIImage imageNamed:normalName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.title = title;

    if (hidden) {
        childController.navigationItem.title = nil;
    }
    
    
    if ([title isEqualToString:@"首页"]) {
        childController.tabBarItem.tag = 0;
    } else if ([title isEqualToString:@"行情"])  {
        childController.tabBarItem.tag = 1;
    } else if ([title isEqualToString:@"直播"]) {
        childController.tabBarItem.tag = 2;
    }  else if ([title isEqualToString:@"交易"]) {
        childController.tabBarItem.tag = 3;
    }  else if ([title isEqualToString:@"交服务"]) {
        childController.tabBarItem.tag = 4;
    }
    
    
 
    
    [self addChildViewController:nav];
}




- (BOOL)shouldAutorotate{
    
    for (GXNavigationController *nav in self.viewControllers) {
        if ([nav.topViewController isKindOfClass: NSClassFromString(@"PriceLandscapeController")]) {
            return [nav.topViewController shouldAutorotate];
            
        }
        if ([nav.topViewController isKindOfClass: NSClassFromString(@"GXDiscoverVideoController")]) {
            return [nav.topViewController shouldAutorotate];
            
        }
    }
    return false;
}




@end

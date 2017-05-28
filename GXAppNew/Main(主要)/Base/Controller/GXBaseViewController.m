//
//  GXBaseViewController.m
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXBaseViewController.h"

@interface GXBaseViewController ()

@end

@implementation GXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setNavAlpha:(CGFloat)alpha
{
    for (id view in [self.navigationController.navigationBar subviews]) {
        if([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarBackground"]||[NSStringFromClass([view class]) isEqualToString:@"_UIBarBackground"])
        {
            [view setAlpha:alpha];
        }
    }
}

@end

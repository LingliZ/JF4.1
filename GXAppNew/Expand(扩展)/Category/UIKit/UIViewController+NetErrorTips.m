
//
//  UIViewController+GXEmptyDataAndNetErrorStyle.m
//  GXApp
//
//  Created by zhudong on 16/8/13.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "UIViewController+NetErrorTips.h"
#import <objc/runtime.h>
#import "UIView+GXVIewController.h"
#import "GXNetTipController.h"

#define ScreenSize [UIScreen mainScreen].bounds.size

const void *isShowedKey = @"isShowedKey";
const void *isShowedTopViewKey = @"isShowedTopViewKey";
const void *topViewKey = @"topViewKey";
const void *tableViewKey = @"tableViewKey";

@interface UIViewController ()

@property (nonatomic,assign) BOOL isShowedTopView;
@property (nonatomic,assign) BOOL isShowed;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UITableView *tableV;

@end
@implementation UIViewController (GXEmptyDataAndNetErrorStyle)

- (void)showErrorNetMsg:(NSString *)str withView: (UIView *)view{
    if (self.isShowed == YES) return;
    NSString *tip;
    if (str.length == 0) {
        tip = @"网络连接失败";
    }else{
        tip = str;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = tip;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    UIView *topV = [[UIView alloc] init];
    topV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [label sizeToFit];
    CGFloat w = label.bounds.size.width + 40;
    CGFloat h = label.bounds.size.height + 30;
    CGFloat x = (ScreenSize.width - w) * 0.5;
    CGFloat y = 100;
    topV.frame = CGRectMake(x - 10, y, w, h);
    topV.layer.cornerRadius = 10;
    topV.layer.masksToBounds = true;
    CGFloat lx = (topV.frame.size.width - label.bounds.size.width) * 0.5;
    CGFloat ly = (topV.frame.size.height - label.bounds.size.height) * 0.5;
    label.frame = CGRectMake(lx, ly, label.bounds.size.width, label.bounds.size.height);
    [topV addSubview:label];
    [view addSubview:topV];
    self.isShowed = true;
    [UIView animateWithDuration:1 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        topV.alpha = 0;
    } completion:^(BOOL finished) {
        [topV removeFromSuperview];
        self.isShowed = false;
    }];
    
    
    
}

- (void)showEmptyMsg:(NSString *)str dataSourceCount:(NSUInteger)count superView:(UIView*) view{
    if (count != 0) {
        if (self.tableV) {
            self.tableV.backgroundView = nil;
        }
        if ([view isKindOfClass:[UITableView class]]) {
            ((UITableView *)view).backgroundView = nil;
        }
    }
    if (self.isShowed == YES || count != 0) return;
    NSString *tip;
    if (str.length == 0) {
        tip = @"暂无新消息";
    }else{
        tip = str;
    }
    
//    [self showErrorNetMsg:tip withView:view];
    
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableV = (UITableView *)view;
        UIImage *bgImage = [UIImage imageNamed:@"noDataIcon"];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, bgImage.size.height)];
        imageV.contentMode = UIViewContentModeCenter;
        imageV.image = bgImage;
        tableV.backgroundView = imageV;
    }
}

- (void)showTipView{
    if (self.isShowedTopView == true) {
        return;
    }
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 44)];
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [[UIImage imageNamed:@"netErrorTip"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imageV.contentMode = UIViewContentModeCenter;
    imageV.frame = CGRectMake(0, 0, 50, 50);
    [topV addSubview:imageV];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"当前网络不可用, 请检查您的网络设置";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    label.frame = CGRectMake(60, (50 - label.size.height) * 0.5, (ScreenSize.width - 100), label.size.height);
    
    UIImageView *arrowImageV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"right_arrows"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    arrowImageV.frame = CGRectMake(ScreenSize.width - 50, 0, 50, 50);
    arrowImageV.contentMode = UIViewContentModeCenter;
    [topV addSubview:imageV];
    [topV addSubview:label];
    [topV addSubview:arrowImageV];
    topV.backgroundColor = GXRGBColor(246, 107, 109);
    [self.view addSubview:topV];
    [self.view bringSubviewToFront:topV];
    self.isShowedTopView = true;
    self.topView = topV;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesClick)];
    [self.topView addGestureRecognizer:tapGes];
    
}

- (void)removeTipView{
    if (self.topView) {
        [self.topView removeFromSuperview];
        self.isShowedTopView = false;
    }
}

- (void)tapGesClick{
    GXNetTipController *tipVc = [[GXNetTipController alloc] init];
    tipVc.navigationItem.title = @"网络无法连接";
    GXLog(@"%@", [self.topView viewController]);
    [[self.topView viewController].navigationController pushViewController:tipVc animated:true];
}

//查找当前控制器
- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }while (next != nil);
    return nil;
}

- (void)setIsShowed:(BOOL)isShowed{
    objc_setAssociatedObject(self, isShowedKey, @(isShowed), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)isShowed{
    return [objc_getAssociatedObject(self, isShowedKey) boolValue];
}

- (void)setIsShowedTopView:(BOOL)isShowedTopView {
    objc_setAssociatedObject(self, isShowedTopViewKey, @(isShowedTopView), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)isShowedTopView{
    return [objc_getAssociatedObject(self, isShowedTopViewKey) boolValue];
}

- (void)setTopView:(UIView *)topView{
    objc_setAssociatedObject(self, topViewKey, topView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)topView{
    return objc_getAssociatedObject(self, topViewKey);
}

- (void)setTableV:(UITableView *)tableV{
    objc_setAssociatedObject(self, tableViewKey, tableV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UITableView *)tableV{
    return objc_getAssociatedObject(self, tableViewKey);
}
@end

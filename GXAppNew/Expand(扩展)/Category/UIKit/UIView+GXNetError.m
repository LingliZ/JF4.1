//
//  UIView+GXNetError.m
//  GXAppNew
//
//  Created by zhudong on 2017/1/11.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "UIView+GXNetError.h"

#define ScreenSize [UIScreen mainScreen].bounds.size
const void *isShowedKeyTwo = @"isShowedKey";
const void *topViewKeyTwo = @"topViewKey";

@interface UIView ()

@property (nonatomic,assign) BOOL isShowed;
@property (nonatomic,strong) UIView *topView;

@end

@implementation UIView (GXNetError)

- (void)showErrorNetMsg:(NSString *)str{
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
    UIView *topV = [[UIView alloc] init];
    topV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [label sizeToFit];
    CGFloat w = label.bounds.size.width + 40;
    CGFloat h = label.bounds.size.height + 30;
    CGFloat x = (ScreenSize.width - w) * 0.5;
    CGFloat y = 100;
    topV.frame = CGRectMake(x, y, w, h);
    topV.layer.cornerRadius = 10;
    topV.layer.masksToBounds = true;
    CGFloat lx = (topV.frame.size.width - label.bounds.size.width) * 0.5;
    CGFloat ly = (topV.frame.size.height - label.bounds.size.height) * 0.5;
    label.frame = CGRectMake(lx, ly, label.bounds.size.width, label.bounds.size.height);
    [topV addSubview:label];
    [self addSubview:topV];
    self.isShowed = true;
    [UIView animateWithDuration:1 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        topV.alpha = 0;
    } completion:^(BOOL finished) {
        [topV removeFromSuperview];
        self.isShowed = false;
    }];
    
}

- (void)showEmptyMsg:(NSString *)str dataSourceCount:(NSUInteger)count{
    if (self.isShowed == YES || count != 0) return;
    NSString *tip;
    if (str.length == 0) {
        tip = @"暂无新消息";
    }else{
        tip = str;
    }
    
    [self showErrorNetMsg:tip];
}

- (void)setIsShowed:(BOOL)isShowed{
    objc_setAssociatedObject(self, isShowedKeyTwo, @(isShowed), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)isShowed{
    return [objc_getAssociatedObject(self, isShowedKeyTwo) boolValue];
}
- (void)setTopView:(UIView *)topView{
    objc_setAssociatedObject(self, topViewKeyTwo, topView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)topView{
    return objc_getAssociatedObject(self, topViewKeyTwo);
}
@end

//
//  UIViewController+GXLoadingTips.h
//  GXApp
//
//  Created by zhudong on 16/7/21.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GXLoadingTips)
@property (nonatomic,assign) BOOL isBGClear;//是否清除黑色背景

- (void)showLoadingWithTitle:(NSString *)title;
- (void)showSuccessWithTitle:(NSString *)title;
- (void)showFailWithTitle:(NSString *)title;
- (void)removeTipView;
- (void)showLoadingWithTitle:(NSString *)title isClear:(BOOL)isClear;

@end

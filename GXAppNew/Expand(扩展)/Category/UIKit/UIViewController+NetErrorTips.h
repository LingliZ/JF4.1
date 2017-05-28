//
//  UIViewController+GXEmptyDataAndNetErrorStyle.h
//  GXApp
//
//  Created by zhudong on 16/8/13.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GXEmptyDataAndNetErrorStyle)
//msg:显示网络错误提示,传入nil显示:网络连接失败
- (void)showErrorNetMsg:(NSString *)str withView: (UIView *)view;
//str: 数据个数为0时提示信息, count:数据个数
- (void)showEmptyMsg:(NSString *)str dataSourceCount:(NSUInteger)count superView:(UIView*) view;
//用于首页
- (void)showTipView;
- (void)removeTipView;

@end

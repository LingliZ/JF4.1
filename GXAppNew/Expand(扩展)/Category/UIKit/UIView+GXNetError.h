//
//  UIView+GXNetError.h
//  GXAppNew
//
//  Created by zhudong on 2017/1/11.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GXNetError)
//msg:显示网络错误提示,传入nil显示:网络连接失败
- (void)showErrorNetMsg:(NSString *)str;
//str: 数据个数为0时提示信息, count:数据个数
- (void)showEmptyMsg:(NSString *)str dataSourceCount:(NSUInteger)count;
@end

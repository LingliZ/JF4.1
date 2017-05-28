//
//  UITableViewCell+GXAddSeperator.h
//  GXAppNew
//
//  Created by zhudong on 2016/12/9.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (GXAddSeperator)
- (void)addSepeartorWidth: (CGFloat) width color: (UIColor *)color top: (BOOL) isTop bottom: (BOOL)isBottom;
- (void)addSepeartorX:(CGFloat)x width: (CGFloat) width color: (UIColor *)color top: (BOOL) isTop bottom: (BOOL)isBottom;

@end

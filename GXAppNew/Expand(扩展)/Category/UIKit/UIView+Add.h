//
//  UIView+Add.h
//  GXApp
//
//  Created by yangfutang on 16/6/29.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Add)

//*获取view的坐标宽高*//
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;


@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;


/**
 *  设置View单一边框
 *
 *  @param view   被设置边框的View
 *  @param top    上
 *  @param left   左
 *  @param bottom 下
 *  @param right  右
 *  @param color  颜色
 *  @param width  边框宽度
 */
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

/**
 *  设置View四周的边框
 *
 *  @param view   被设置边框的View
 *  @param width  宽度
 *  @param color  颜色
 *  @param corner 园角度
 */
+(void)setBorForView:(UIView*)view withWidth:(CGFloat)width andColor:(UIColor*)color andCorner:(CGFloat)corner;
- (void)setBorderWithViewBottom:(UIView *)view  borderColor:(UIColor *)color borderWidth:(CGFloat)width withScale:(CGFloat )scale;

@end

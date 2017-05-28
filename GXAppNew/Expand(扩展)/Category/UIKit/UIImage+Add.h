//
//  UIImage+Add.h
//  GXApp
//
//  Created by WangLinfang on 16/8/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Add)
/**
 *  设置UIImage边框
 *
 *  @param borderW 十六进制颜色字符串
 *
 *  @return 生成的图片
 */
+ (UIImage *)imageWithBorder:(CGFloat)borderW color:(UIColor *)color image:(NSString *)imageName;
/**
 *  根据十六进制颜色获取图片
 *
 *  @param hexColorStr 十六进制颜色字符串
 *
 *  @return 生成的图片
 */
+(UIImage*)getImageWithHexColor:(NSString*)hexColorStr;

@end

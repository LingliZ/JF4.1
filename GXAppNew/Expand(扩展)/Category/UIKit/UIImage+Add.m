//
//  UIImage+Add.m
//  GXApp
//
//  Created by WangLinfang on 16/8/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "UIImage+Add.h"

@implementation UIImage (Add)
/**
 *  根据十六进制颜色获取图片
 *
 *  @param hexColorStr 十六进制颜色字符串
 *
 *  @return 生成的图片
 */
+(UIImage*)getImageWithHexColor:(NSString *)hexColorStr
{
    UIColor*color=[UIColor getColor:hexColorStr];
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageWithBorder:(CGFloat)borderW color:(UIColor *)color image:(NSString *)imageName {
    
    // 增加边框 生成边框的宽度 w = image.width + 2*borderW 高度同理
    UIImage *image = [UIImage imageNamed:imageName];
    
    // 开启上下文
    CGSize size = CGSizeMake(image.size.width + 2 * borderW, image.size.height + 2 * borderW);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // 绘制大圆，显示出来
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    [[UIColor redColor] set];
    [path fill];
    
    // 绘小圆
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW, borderW, image.size.width, image.size.height)];
    // 设置为裁剪路径
    [clipPath addClip];
    
    // 画图
    [image drawAtPoint:CGPointMake(borderW, borderW)];
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
@end

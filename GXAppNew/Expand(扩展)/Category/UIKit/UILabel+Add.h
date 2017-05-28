//
//  UILabel+Add.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Add)

#pragma mark--设置label指定范围的字体颜色
/**
 设置label指定范围的字体颜色
 */
+(NSAttributedString*)getAttributedStringFromString:(NSString*)string withColor:(UIColor*)color andRange:(NSRange)range;
@end

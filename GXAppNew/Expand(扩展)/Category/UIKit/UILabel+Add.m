//
//  UILabel+Add.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "UILabel+Add.h"

@implementation UILabel (Add)
+(NSAttributedString*)getAttributedStringFromString:(NSString *)string withColor:(UIColor *)color andRange:(NSRange)range
{
    NSMutableAttributedString*attributedStr=[[NSMutableAttributedString alloc]initWithString:string];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attributedStr;
}
@end

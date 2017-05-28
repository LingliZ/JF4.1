//
//  UILabel+Extension.m
//  MyExamProject
//
//  Created by WangLinfang on 16/7/6.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)
-(CGFloat)getSpaceLabelHeight:(NSString *)str withWidh:(CGFloat)width
{
    
    NSMutableParagraphStyle *paragphStyle=[[NSMutableParagraphStyle alloc]init];
    
    paragphStyle.lineSpacing=0;//设置行距为0
    paragphStyle.firstLineHeadIndent=0.0;
    paragphStyle.hyphenationFactor=0.0;
    paragphStyle.paragraphSpacingBefore=0.0;
    
    NSDictionary *dic=@{
                        
                        NSFontAttributeName:[UIFont systemFontOfSize:17], NSParagraphStyleAttributeName:paragphStyle, NSKernAttributeName:@1.0f
                        
                        };
    CGSize size=[str boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
    
}
@end

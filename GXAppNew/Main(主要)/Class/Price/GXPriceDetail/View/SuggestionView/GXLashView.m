//
//  GXLashView.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/9.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLashView.h"

@implementation GXLashView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 1);
    CGFloat lengths[] = { 3, 1 };
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.size.width, 0);
    CGContextAddLineToPoint(context, self.size.width, self.size.height);
    CGContextAddLineToPoint(context, 0, self.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextStrokePath(context);
}


@end

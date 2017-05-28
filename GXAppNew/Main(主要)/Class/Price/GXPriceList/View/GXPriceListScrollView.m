//
//  GXPriceListScrollView.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceListScrollView.h"

@implementation GXPriceListScrollView
@synthesize delegateCustom;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([delegateCustom respondsToSelector:@selector(listScrollvTouchBegan:withEvent:)])
    [delegateCustom listScrollvTouchBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([delegateCustom respondsToSelector:@selector(listScrollvTouchEnd:touch:withEvent:)])
    [delegateCustom listScrollvTouchEnd:self touch:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([delegateCustom respondsToSelector:@selector(listScrollvTouchCancel:withEvent:)])
    [delegateCustom listScrollvTouchCancel:touches withEvent:event];
}
@end

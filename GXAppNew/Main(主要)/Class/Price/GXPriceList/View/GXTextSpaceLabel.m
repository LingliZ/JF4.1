//
//  GXTextSpaceLabel.m
//  GXAppNew
//
//  Created by shenqilong on 17/1/20.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXTextSpaceLabel.h"

@implementation GXTextSpaceLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - 6, rect.size.height)];
}
@end

//
//  GXAlertToLoginOrAddCountView.m
//  GXApp
//
//  Created by WangLinfang on 16/12/14.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXAlertToLoginOrAddCountView.h"

@implementation GXAlertToLoginOrAddCountView
-(void)awakeFromNib
{
    [super awakeFromNib];
    [UIView setBorForView:self.btn withWidth:0 andColor:nil andCorner:5];
}
- (IBAction)btnClick:(UIButton *)sender {
    [self.delegate gotoLoginOrAddCount];
}

@end

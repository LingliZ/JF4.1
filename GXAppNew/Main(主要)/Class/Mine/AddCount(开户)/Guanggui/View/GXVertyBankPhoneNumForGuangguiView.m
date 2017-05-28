//
//  GXVertyBankPhoneNumForGuangguiView.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/8.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXVertyBankPhoneNumForGuangguiView.h"

@implementation GXVertyBankPhoneNumForGuangguiView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self createUI];
}
-(void)createUI
{
    [UIView setBorForView:self.view_content withWidth:0 andColor:nil andCorner:10];
    [UIView setBorForView:self.btn_timeMark withWidth:0.5 andColor:[UIColor lightGrayColor] andCorner:0];
    [UIView setBorForView:self.TF_vertyNum withWidth:0.5 andColor:[UIColor lightGrayColor] andCorner:0];
    [UIView setBorForView:self.btn_sendAgain withWidth:0.5 andColor:[UIColor lightGrayColor] andCorner:0];

}
#pragma mark--重新发送验证码
- (IBAction)btnClick_sendAgain:(UIButton *)sender {
    [self.btn_timeMark turnModeForSendVertyCodeWithTimeInterval:30];
}
#pragma mark--取消
- (IBAction)btnClick_cancel:(UIButton *)sender {
    self.hidden=YES;
}
#pragma mark--确定
- (IBAction)btnClick_confirm:(UIButton *)sender {
    self.hidden=YES;
    [self.delegate vertyBankPhoneNumConfirm];
}


@end

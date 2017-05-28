//
//  GXChangePhoneIndexController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXChangePhoneIndexController.h"

@interface GXChangePhoneIndexController ()

@end

@implementation GXChangePhoneIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"更换手机";
    NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString:self.label_service.text];
    [str addAttribute:NSForegroundColorAttributeName value:GXColor(246.0, 76.0, 76.0, 1.0) range:NSMakeRange(15, 12)];
    self.label_service.attributedText=str;
}
- (IBAction)btnClick_changePhoneNum:(UIButton *)sender {
    if(sender.tag==0)
    {
        //原手机号＋动态验证码
        GXVertyIdentifyWithPhoneController*vertyVC=[[GXVertyIdentifyWithPhoneController alloc]init];
        [self.navigationController pushViewController:vertyVC animated:YES];
    }
    if(sender.tag==1)
    {
        //账号＋密码验证
        GXVertyIdentifyController*vertyVC=[[GXVertyIdentifyController alloc]init];
        [self.navigationController pushViewController:vertyVC animated:YES];
    }
}
- (IBAction)btnClick_call:(UIButton *)sender {
    [UIButton callPhoneWithPhoneNum:GXPhoneNum atView:self.view];
}




@end

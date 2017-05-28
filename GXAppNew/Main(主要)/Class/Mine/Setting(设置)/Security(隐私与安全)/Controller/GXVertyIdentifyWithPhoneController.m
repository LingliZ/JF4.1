//
//  GXVertyIdentifyWithPhoneController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXVertyIdentifyWithPhoneController.h"

@interface GXVertyIdentifyWithPhoneController ()

@end

@implementation GXVertyIdentifyWithPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"身份验证";
    self.TF_phoneNum.delegate=self;
    self.TF_vertyCode.delegate=self;
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
//    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_next setBtn_nextControlStateDisabled];
}
-(void)editClick
{
    if(self.TF_vertyCode.text.length==0||self.TF_phoneNum.text.length==0)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
    if(self.TF_phoneNum.text.length==0)
    {
        self.btn_sendVertyCode.enabled=NO;
    }
    else
    {
        self.btn_sendVertyCode.enabled=YES;
    }
}
- (IBAction)btnClick_sendVertyCode:(UIButton *)sender {
    if(![UIButton checkIsLegalPhoneNum:self.TF_phoneNum.text])
    {
        [self.view showFailWithTitle:@"请输入合法的手机号"];
        return;
    }
    [self.currentTF resignFirstResponder];
    [GXUserInfoTool sendVerCodeForViewController:self WithPhoneNumber:self.TF_phoneNum.text FromButton:self.btn_sendVertyCode];
}
- (IBAction)btnClick_next:(UIButton *)sender {
    
    [self.view showLoadingWithTitle:@"正在验证……"];
    NSDictionary*params=@{@"mobile":self.TF_phoneNum.text,
                          @"verCode":self.TF_vertyCode.text};
    [GXHttpTool POST:GXUrl_changeMobileVerify parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            GXChangePhoneNumController*changeNumVC=[[GXChangePhoneNumController alloc]init];
            [self.navigationController pushViewController:changeNumVC animated:YES];
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"验证失败，请检查网络状况"];
    }];
}


@end

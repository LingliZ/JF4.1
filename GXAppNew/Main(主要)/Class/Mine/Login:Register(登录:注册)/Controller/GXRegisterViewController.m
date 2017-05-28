//
//  GXRegisterViewController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXRegisterViewController.h"

@interface GXRegisterViewController ()

@end

@implementation GXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"快速注册";
    self.TF_phoneNum.delegate=self;
    self.TF_vertyNum.delegate=self;
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
//    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_next setBtn_nextControlStateDisabled];

}
-(void)editClick
{
    if(self.TF_vertyNum.text.length==0||self.TF_phoneNum.text==0)
    {
        self.btn_next.enabled=NO;
        if(self.TF_phoneNum.text.length==0)
        {
            self.btn_getVerCode.enabled=NO;
        }
        else
        {
            self.btn_getVerCode.enabled=YES;
        }
    }
    else
    {
        self.btn_next.enabled=YES;
        self.btn_getVerCode.enabled=YES;
    }
}

- (IBAction)btnClick_getVerCode:(UIButton *)sender {
    [self.currentTF resignFirstResponder];
    if(self.TF_phoneNum.text.length==0)
    {
        [self.view showFailWithTitle:@"请输入手机号"];
        return;
    }
    if(![UIButton checkIsLegalPhoneNum:self.TF_phoneNum.text])
    {
        [self.view showFailWithTitle:@"请输入合法的手机号"];
        return;
    }
    [GXUserInfoTool sendVerCodeForViewController:self WithPhoneNumber:self.TF_phoneNum.text FromButton:self.btn_getVerCode];
}

- (IBAction)btnClick_Next:(UIButton *)sender {
    [self.currentTF resignFirstResponder];
    [self vertyVerCode];
}
-(void)vertyVerCode
{
    NSDictionary*params=@{
                          @"mobile":self.TF_phoneNum.text,
                          @"verCode":self.TF_vertyNum.text,
                          };
    [self.view showLoadingWithTitle:@"正在校验验证码"];
    self.btn_next.enabled=NO;
    [GXHttpTool POST:GXUrl_vertyVerCode parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            GXSetPasswordController*setVC=[[GXSetPasswordController alloc]init];
            setVC.registerStr = self.registerStr;
            setVC.phoneNum=self.TF_phoneNum.text;
            setVC.verCode=self.TF_vertyNum.text;
            [self.navigationController pushViewController:setVC animated:YES];
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        self.btn_next.enabled=YES;
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络设置"];
        self.btn_next.enabled=YES;
    }];
}
@end

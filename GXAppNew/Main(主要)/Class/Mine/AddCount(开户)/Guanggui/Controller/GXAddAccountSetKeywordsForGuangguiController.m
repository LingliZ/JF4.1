//
//  GXAddAccountSetKeywordsForGuangguiController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/2.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddAccountSetKeywordsForGuangguiController.h"

@interface GXAddAccountSetKeywordsForGuangguiController ()

@end

@implementation GXAddAccountSetKeywordsForGuangguiController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    self.title=@"广贵中心开户";
    self.TF_login_password.delegate=self;
    self.TF_login_confirmPassword.delegate=self;
    self.TF_deal_password.delegate=self;
    self.TF_deal_confirmPassword.delegate=self;
    [self.btn_finish setBtn_nextControlStateDisabled];
    
    self.label_agreement.attributedText=[UILabel getAttributedStringFromString:self.label_agreement.text withColor:GXRGBColor(145, 145, 145) andRange:NSMakeRange(0, 7)];
}
-(void)editClick
{
    if(self.TF_login_password.text.length==0||self.TF_login_confirmPassword.text.length==0||self.TF_deal_password.text.length==0||self.TF_deal_confirmPassword.text.length==0)
    {
        self.btn_finish.enabled=NO;
    }
    else
    {
        self.btn_finish.enabled=YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTF=textField;
}
- (IBAction)btnClick_finish:(UIButton *)sender {
    if(![[self.TF_login_password.text checkDeal_password_Guanggui]isEqualToString:Check_DealPassword_Guanggui_Qualified])
    {
        //交易密码
        [self.view showFailWithTitle:[self.TF_login_password.text checkDeal_password_Guanggui]];
        return;
    }
    if(![self.TF_login_password.text isEqualToString:self.TF_login_confirmPassword.text])
    {
        [self.view showFailWithTitle:@"两次输入的交易密码不一致"];
        return;
    }
    if(![[self.TF_deal_password.text checkDeal_password_Guanggui]isEqualToString:Check_DealPassword_Guanggui_Qualified])
    {
        //资金密码
        [self.view showFailWithTitle:[self.TF_deal_password.text checkDeal_password_Guanggui]];
        return;
    }
    if(![self.TF_deal_password.text isEqualToString:self.TF_deal_confirmPassword.text])
    {
        [self.view showFailWithTitle:@"两次输入的资金密码不一致"];
        return;
    }
    [self commitDataForAddAccount];
}
#pragma mark--提交开户数据
-(void)commitDataForAddAccount
{
    NSMutableDictionary*dic_paramsAddAccount=[[NSMutableDictionary alloc]initWithDictionary:[GXUserdefult objectForKey:AddCountParams]];
    dic_paramsAddAccount[@"phonePWD"]=self.TF_login_password.text;
    dic_paramsAddAccount[@"tradePWD"]=self.TF_deal_password.text;
    dic_paramsAddAccount[@"idType"]=[NSNumber numberWithInt:1];
    [self.view showFailWithTitle:@"正在提交开户相关数据"];
    [GXHttpTool POST:GXUrl_openAccount parameters:dic_paramsAddAccount success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]integerValue]==1)
        {
            GXAddAccountVertyBankForGuangguiController*setPwVC=[[GXAddAccountVertyBankForGuangguiController alloc]init];
            [self.navigationController pushViewController:setPwVC animated:YES];

        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.view showFailWithTitle:@"请求失败，请检查网络设置"];
    }];
}

@end

//
//  GXAddAccountIdentifyForGuangguiController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/2.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddAccountIdentifyForGuangguiController.h"

@interface GXAddAccountIdentifyForGuangguiController ()

@end

@implementation GXAddAccountIdentifyForGuangguiController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isForAddAccount=YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    self.title=@"广贵中心开户";
    self.TF_name.delegate=self;
    self.TF_IdNum.delegate=self;
    self.TF_mail.delegate=self;
    [GXUserdefult setObject:AddCountFor forKey:ForGuanggui];
    self.TF_name.text=[GXUserInfoTool getUserReallyName];
    self.TF_IdNum.text=[GXUserInfoTool getIDCardNum];
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    [self.btn_next setBtn_nextControlStateDisabled];
}
-(void)editClick
{
    if(self.TF_name.text.length==0||self.TF_IdNum.text.length==0||self.TF_mail.text.length==0)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTF=textField;
}
- (IBAction)btnClick_next:(UIButton *)sender {
//    GXAddAccountIllegalAgeForGuangguiController*illegalAgeVC=[[GXAddAccountIllegalAgeForGuangguiController alloc]init];
//    [self.navigationController pushViewController:illegalAgeVC animated:YES];
    [self.currentTF resignFirstResponder];
    if(![[self.TF_name.text checkName]isEqualToString:Check_Name_Qualified])
    {
        [self.view showFailWithTitle:[self.TF_name.text checkName]];
        return;
    }
    if(![self.TF_IdNum.text isLegalID_CardNum])
    {
        [self.view showFailWithTitle:@"请输入正确的身份证号码"];
        return;
    }
    if(![self.TF_mail.text isValidateEmail])
    {
        [self.view showFailWithTitle:@"请输入正确的邮箱账号"];
        return;
    }
    NSMutableDictionary*dic_addAccountParams=[[NSMutableDictionary alloc]init];
    dic_addAccountParams[@"customerName"]=self.TF_name.text;
    dic_addAccountParams[@"idNumber"]=self.TF_IdNum.text;
    dic_addAccountParams[@"email"]=self.TF_mail.text;
    dic_addAccountParams[@"phone"]=[GXUserInfoTool getPhoneNum];
    dic_addAccountParams[@"type"]=AccountTypeGuanggui;
    dic_addAccountParams[@"source"]=@"ios";
    [GXUserdefult setObject:dic_addAccountParams forKey:AddCountParams];
    [self checkUerInfo];
}
#pragma mark--用户身份校验
-(void)checkUerInfo
{
    NSDictionary*params=@{
                          @"type":AccountTypeGuanggui,
                          @"idNumber":self.TF_IdNum.text,
                          @"customerName":self.TF_name.text,
                          @"email":self.TF_mail.text};
    [self.view showLoadingWithTitle:@"正在校验用户身份……"];
    [GXHttpTool POST:GXUrl_Check_accountInfo parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]integerValue]==1)
        {
            GXAddAccountSetKeywordsForGuangguiController*setVC=[[GXAddAccountSetKeywordsForGuangguiController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络状况"];
    }];
}
@end

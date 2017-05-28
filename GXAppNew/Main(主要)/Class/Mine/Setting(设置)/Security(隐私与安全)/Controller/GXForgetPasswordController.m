//
//  GXForgetPasswordController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXForgetPasswordController.h"

@interface GXForgetPasswordController ()

@end

@implementation GXForgetPasswordController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.navigationItem.title=@"忘记密码";
    self.TF_phoneNum.delegate=self;
    self.TF_vertyCode.delegate=self;
    self.TF_newPassword.delegate=self;
    self.Btn_next.layer.cornerRadius=5;
    self.Btn_next.layer.masksToBounds=YES;
//    [self.Btn_next setBackgroundImage:ImageFromHex(Color_btn_next_Highled) forState:UIControlStateHighlighted];
//    [self.Btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.Btn_next setBtn_nextControlStateDisabled];
    self.Btn_next.enabled=NO;
    self.Btn_next.layer.masksToBounds=YES;
    [UIView setBorForView:self.Btn_next withWidth:0 andColor:nil andCorner:5];
    
    [self.TF_newPassword addTarget:self action:@selector(editChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)editClick
{
    if(self.TF_phoneNum.text.length==0)
    {
        self.btn_GetVerCode.enabled=NO;
    }
    else
    {
        self.btn_GetVerCode.enabled=YES;
    }
    if(self.TF_phoneNum.text.length&&self.TF_vertyCode.text.length&&self.TF_newPassword.text.length)
    {
        self.Btn_next.enabled=YES;
    }
    else
    {
        self.Btn_next.enabled=NO;
    }
}
#pragma mark--UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)editChange:(UITextField*)textField
{
    textField.text=[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(textField.text.length>20)
    {
        textField.text =[textField.text substringToIndex:20];
    }
}

- (IBAction)getVertyCodeClick:(UIButton *)sender {
    
    [self.currentTF resignFirstResponder];
    [self getVertyCode];
}
-(void)getVertyCode
{
    if(self.TF_phoneNum.text.length==0)
    {
        [self.view showFailWithTitle:@"手机号不为空"];
        return;
    }
    if(![UIButton checkIsLegalPhoneNum:self.TF_phoneNum.text])
    {
        [self.view showFailWithTitle:@"手机号不合法"];
        return;
    }
    if(![GXUserInfoTool isConnectToNetwork])
    {
        [self.view showFailWithTitle:NotConnectToNetworking];
        return;
    }
    
    [self.btn_GetVerCode turnModeForSendVertyCodeWithTimeInterval:30];
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    [params setObject:self.TF_phoneNum.text forKey:@"mobile"];
    
    [GXHttpTool POST:GXUrl_sendVerCode parameters:params  success:^(id responseObject) {
        
        if([responseObject[@"success"]integerValue]!=1)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view showFailWithTitle:responseObject[@"message"]];
            });
        }
        else
        {
            GXLog(@"验证码获取成功");
            
        }
    } failure:^(NSError *error) {
        GXLog(@"验证码获取失败");
        
    }];
}

- (IBAction)nextClick:(UIButton *)sender {
    
    if(self.TF_phoneNum.text.length==0)
    {
        [self.view showFailWithTitle:@"手机号不能为空"];
        return;
    }
    if(![UIButton checkIsLegalPhoneNum:self.TF_phoneNum.text])
    {
        [self.view showFailWithTitle:@"手机号不合法"];
        return;
    }
    if(self.TF_vertyCode.text.length==0)
    {
        [self.view showFailWithTitle:@"请输入验证码"];
        return;
    }
    if(self.TF_newPassword.text.length==0)
    {
        [self.view showFailWithTitle:@"请输入密码"];
        return;
    }
    if(![[self.TF_newPassword.text checkPassword]isEqualToString:Check_Password_Qualified])
    {
        [self.view showFailWithTitle:[self.TF_newPassword.text checkPassword]];
        return;
    }
    
    [self.view showLoadingWithTitle:@"更新密码提交中..."];
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"mobile"]=GXRsaEncryptor_string(self.TF_phoneNum.text);
    params[@"verCode"]=self.TF_vertyCode.text;
    params[@"newPassword"]=GXRsaEncryptor_string(self.TF_newPassword.text);
    self.btn_GetVerCode.enabled=NO;
    
    [GXHttpTool POST:GXUrl_forgetPassword parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        self.btn_GetVerCode.enabled=YES;
        NSString*success=[NSString stringWithFormat:@"%@", responseObject[@"success"]];
        if(success.intValue==1)
        {
            [self.view showSuccessWithTitle:@"密码更新成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        GXLog(@"密码更新结果为：%@",responseObject);
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        self.btn_GetVerCode.enabled=YES;
        [self.view showFailWithTitle:@"密码修改失败，请检查网络设置"];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

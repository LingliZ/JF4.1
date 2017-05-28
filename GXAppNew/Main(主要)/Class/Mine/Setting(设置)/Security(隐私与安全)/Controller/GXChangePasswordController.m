//
//  GXChangePasswordController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXChangePasswordController.h"

@interface GXChangePasswordController ()

@end

@implementation GXChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"修改账号密码";
    self.TF_oldPassword.delegate=self;
    self.TF_newPassword.delegate=self;
    self.TF_confirmPassword.delegate=self;
    [UIView setBorForView:self.btn_confirm withWidth:0 andColor:nil andCorner:5];
//    [self.btn_confirm setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_confirm setBtn_nextControlStateDisabled];
}
-(void)editClick
{
    if(self.TF_oldPassword.text.length==0||self.TF_newPassword.text.length==0||self.TF_confirmPassword.text.length==0)
    {
        self.btn_confirm.enabled=NO;
    }
    else
    {
        self.btn_confirm.enabled=YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTF=textField;
}
- (IBAction)btnClick_forgetPassword:(UIButton *)sender {
    //忘记密码
    GXForgetPasswordController*forgetVC=[[GXForgetPasswordController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (IBAction)btnClick_confirm:(UIButton *)sender {
    //确认修改
    NSString*msg=[[NSString alloc]init];
    if(![[self.TF_newPassword.text checkPassword]isEqualToString:Check_Password_Qualified])
    {
        [self.view showFailWithTitle:[NSString stringWithFormat:@"新%@",[self.TF_newPassword.text checkPassword]]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        });
        return;
    }
    if(self.TF_confirmPassword.text.length==0)
    {
        msg=@"请输入确认密码";
        [self.view showFailWithTitle:msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        });
        return;
    }
    if(![self.TF_newPassword.text isEqualToString:self.TF_confirmPassword.text])
    {
        msg=@"确认密码须与新密码一致";
        [self.view showFailWithTitle:msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        });
        return;
    }
    if([self.TF_oldPassword.text isEqualToString:self.TF_newPassword.text])
    {
        msg=@"新密码不能与旧密码相同";
        [self.view showFailWithTitle:msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        });
        return;
    }
    
    [self commiteChange];
}
-(void)commiteChange
{
    self.btn_confirm.enabled=NO;
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"oldPassword"]=GXRsaEncryptor_string(self.TF_oldPassword.text);
    params[@"newPassword"]=GXRsaEncryptor_string(self.TF_newPassword.text);
    [self.view showLoadingWithTitle:@"正在修改密码"];
    [GXHttpTool POST:GXUrl_updatePassword parameters:params success:^(id responseObject) {
        
        [self.view removeTipView];
        NSString*success=[NSString stringWithFormat:@"%@",responseObject[@"success"]];
        if(success.intValue==1)
        {
            GXLog(@"密码修改成功");
            [GXUserInfoTool loginOut];
            [self.view showSuccessWithTitle:@"密码修改成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.btn_confirm.enabled=YES;
                [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count-4] animated:YES];
            });
            
        }
        else
        {
            NSString*errorMsg=responseObject[@"message"];
            [self.view showFailWithTitle:errorMsg];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.btn_confirm.enabled=YES;
            });
        }
        
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"密码修改失败，请检查网络设置"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.btn_confirm.enabled=YES;
        });
        
    }];
}



@end

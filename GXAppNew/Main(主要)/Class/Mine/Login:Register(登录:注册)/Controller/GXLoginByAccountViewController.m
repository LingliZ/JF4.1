//
//  GXLoginByAccountViewController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLoginByAccountViewController.h"

@interface GXLoginByAccountViewController ()

@end

@implementation GXLoginByAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    self.title=@"账号密码登录";
    self.TF_phoneNum.delegate=self;
    self.TF_password.delegate=self;
    [UIView setBorForView:self.btn_login withWidth:0 andColor:nil andCorner:5];
//    [self.btn_login setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_login setBtn_nextControlStateDisabled];
}
-(void)editClick
{
    if(self.TF_password.text.length==0||self.TF_phoneNum.text.length==0)
    {
        self.btn_login.enabled=NO;
    }
    else
    {
        self.btn_login.enabled=YES;
    }
}
- (IBAction)btnClick_forgetPassword:(UIButton *)sender {
    //忘记密码
    [MobClick event:@"uc_password_retrieve"];
    GXForgetPasswordController*forgetVC=[[GXForgetPasswordController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (IBAction)btnClick_login:(UIButton *)sender {
    [self login];
}
-(void)login
{
    NSDictionary*params=@{
                          @"account":self.TF_phoneNum.text,
                          @"password":self.TF_password.text,
                          };
    [self.view showLoadingWithTitle:@"正在登录……"];
    [GXHttpTool POST:GXUrl_login parameters:params success:^(id responseObject) {
        
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [self.view showSuccessWithTitle:@"登录成功"];
            if([responseObject[@"value"][@"customerInfo"][@"identity"][@"idNumber"]length])
            {
                //保存身份证号码
                [GXUserInfoTool saveUserIDCardNum:responseObject[@"value"][@"customerInfo"][@"identity"][@"idNumber"]];
            }
            if([responseObject[@"value"][@"customerInfo"][@"realName"]length])
            {
                //保存用户真实姓名
                [GXUserInfoTool saveUserReallyName:responseObject[@"value"][@"customerInfo"][@"realName"]];
            }
            [GXUserInfoTool saveLoginAccount:self.TF_phoneNum.text];
            [GXUserInfoTool savePhoneNum:self.TF_phoneNum.text];
            [GXUserInfoTool saveUserTocken:responseObject[@"value"][@"userToken"]];
            [GXUserInfoTool saveUserId:responseObject[@"value"][@"customerInfo"][@"customerId"]];
            NSDictionary*dic=(NSDictionary*)responseObject[@"value"];
            [GXPushTool LoginEaseMobWith:[dic objectForKey:@"pushAccount"] password:[dic objectForKey:@"pushPassword"]];
            [Growing setCS1Value:[GXUserInfoTool getLoginAccount] forKey:@"user_id"];
            [GXUserInfoTool loginSuccess];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                int count=(int)self.navigationController.childViewControllers.count;
                //                        [self.navigationController popViewControllerAnimated:true];
                [self.navigationController popToViewController:self.navigationController.childViewControllers[count-3] animated:YES];
            });
            
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
- (IBAction)btnClick_agree:(UIButton *)sender {
    GXAgreementController*agreeVC=[[GXAgreementController alloc]init];
    agreeVC.urlString=AgreeType_GUOXIN_REGISTER;
    [self.navigationController pushViewController:agreeVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

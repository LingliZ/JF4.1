//
//  GXLoginByVertyViewController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLoginByVertyViewController.h"

@interface GXLoginByVertyViewController ()

@end

@implementation GXLoginByVertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    self.title=@"快捷登录";
    self.TF_phoneNum.delegate=self;
    self.TF_vertyNum.delegate=self;
    [UIView setBorForView:self.btn_Login withWidth:0 andColor:nil andCorner:5];
//    [self addUnderlineForButton:self.btn_regist];
//    [self addUnderlineForButton:self.btn_loginByAcount];
    [self.btn_Login setBtn_nextControlStateDisabled];
}
-(void)addUnderlineForButton:(UIButton*)btn
{
    NSMutableAttributedString*titleStr=[[NSMutableAttributedString alloc]initWithString:btn.titleLabel.text];
    [titleStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, titleStr.length)];
    [btn setAttributedTitle:titleStr forState:UIControlStateNormal];
}
-(void)editClick
{
    if(self.TF_phoneNum.text.length==0||self.TF_vertyNum.text.length==0)
    {
        self.btn_Login.enabled=NO;
        if(self.TF_phoneNum.text.length==0)
        {
            self.btn_GetVertyNum.enabled=NO;
        }
        else
        {
            self.btn_GetVertyNum.enabled=YES;
        }
    }
    else
    {
        self.btn_Login.enabled=YES;
        self.btn_GetVertyNum.enabled=YES;
    }
}
- (IBAction)btnClick_GetVertyNum:(UIButton *)sender {
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
    [GXUserInfoTool sendVerCodeForViewController:self WithPhoneNumber:self.TF_phoneNum.text FromButton:self.btn_GetVertyNum];
}
- (IBAction)btnClick_Login:(UIButton *)sender {
    
    [self.currentTF resignFirstResponder];
    if(![UIButton checkIsLegalPhoneNum:self.TF_phoneNum.text])
    {
        [self.view showFailWithTitle:@"请输入正确的手机号"];
        return;
    }
    [self beginToLog];
}
-(void)beginToLog
{
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    NSString *source = [[NSString alloc]init];
    if (self.recieveSiteUrl != nil) {
        source = self.recieveSiteUrl;
    }else{
        source = GXDefaultSiteLogin;
    }
    params[@"source"]=source;
    params[@"mobile"]=GXRsaEncryptor_string(self.TF_phoneNum.text);
    params[@"verCode"]=self.TF_vertyNum.text;
    NSDictionary *dict = [GXUserInfoTool getEaseMobAccoutAndPassword];
//    params[@"pushAccount"] = dict[EaseMobAccount];
//    params[@"pushPassword"] = dict[EaseMobPassword];
    
    
    [self.view showLoadingWithTitle:@"登录中……"];
    self.btn_Login.enabled=NO;
    [GXHttpTool POST:GXUrl_FreeLogin parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        GXLog(@"请求成功");
        NSString*success=[NSString stringWithFormat:@"%@", (NSDictionary*)responseObject[@"success"]];
        self.btn_Login.enabled=YES;
        if(success.intValue==1)
        {
            //登录成功
            GXLog(@"登录成功的请求结果为：%@",responseObject);
            NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
            NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            params[@"idfa"]=adId;
            params[@"mobile"]=self.TF_phoneNum.text;
            [GXHttpTool POST:GXUrl_registerIDFA parameters:params success:^(id responseObject) {
            } failure:^(NSError *error) {
            }];
            
            [GXUserInfoTool savePhoneNum:self.TF_phoneNum.text];
            //存储登录账号
            [GXUserInfoTool saveLoginAccount:self.TF_phoneNum.text];
            [self.view showSuccessWithTitle:@"登录成功"];

            [GXUserInfoTool saveUserTocken:responseObject[@"value"][@"userToken"]];

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
            NSDictionary*dic=(NSDictionary*)responseObject[@"value"];
            [GXPushTool LoginEaseMobWith:[dic objectForKey:@"pushAccount"] password:[dic objectForKey:@"pushPassword"]];
            
            [GXUserInfoTool saveUserId:responseObject[@"value"][@"customerInfo"][@"customerId"]];
  
            [Growing setCS1Value:[dic objectForKey:@"pushAccount"] forKey:@"user_id"];
            [Growing setCS1Value:[GXUserInfoTool getLoginAccount] forKey:@"user_id"];
            
            
            /*
            [Growing setCS1Value:[dic objectForKey:@"pushAccount"] forKey:@"user_id"];
            [GXUserInfoTool saveUserTocken:[dic objectForKey:@"userToken"]];
            if([UIButton checkIsLegalPhoneNum:self.TF_username.text])
            {
                [GXUserInfoTool savePhoneNum:self.TF_username.text];
                
            }
            
            [Growing setCS1Value:[GXUserInfoTool getLoginAccount] forKey:@"user_id"];
             */
            [GXUserInfoTool loginSuccess];
            [GXUserdefult synchronize];
            [NSThread sleepForTimeInterval:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"登录失败,请检查网络设置"];
        self.btn_Login.enabled=YES;
        
    }];

}
- (IBAction)btnClick_ToRegist:(UIButton *)sender {
    if([self.type isEqualToString:@"uc_login"])
    {
        [MobClick event:@"uc_register"];
    }
    if([self.type isEqualToString:@"uc_set_SMS_login"])
    {
        [MobClick event:@"uc_set_SMS_register"];
    }
    if([self.type isEqualToString:@"uc_set_account_safe_login"])
    {
        [MobClick event:@"uc_set_account_safe_register"];
    }
    if([self.type isEqualToString:@"message_login"])
    {
        [MobClick event:@"message_register"];
    }
    if([self.type isEqualToString:@"warning_login"])
    {
        [MobClick event:@"warning_register"];
    }
    if([self.type isEqualToString:@"counselor_login"])
    {
        [MobClick event:@"counselor_register"];
    }
    if([self.type isEqualToString:@"video_login"])
    {
        [MobClick event:@"video_register"];
    }
    if([self.type isEqualToString:@"video_float_login"])
    {
        [MobClick event:@"video_float_register"];
    }
    if([self.type isEqualToString:@"trading_login"])
    {
        [MobClick event:@"trading_register"];
    }
    if([self.type isEqualToString:@"home_quickness_login"])
    {
        [MobClick event:@"home_quickness_register"];
    }

    GXRegisterViewController*registVC=[[GXRegisterViewController alloc]init];
    registVC.registerStr = self.registerStr;
    [self.navigationController pushViewController:registVC animated:YES];
}

- (IBAction)btnClick_LoginByAccount:(UIButton *)sender {
    [MobClick event:@"password_login"];
    GXLoginByAccountViewController*logVC=[[GXLoginByAccountViewController alloc]init];
    [self.navigationController pushViewController:logVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

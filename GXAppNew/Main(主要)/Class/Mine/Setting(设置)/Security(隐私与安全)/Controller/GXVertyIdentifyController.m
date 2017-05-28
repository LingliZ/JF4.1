//
//  GXVertyIdentifyController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXVertyIdentifyController.h"

@interface GXVertyIdentifyController ()

@end

@implementation GXVertyIdentifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"身份验证";
    self.TF_password.delegate=self;
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
//    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_next setBtn_nextControlStateDisabled];
}
-(void)editClick
{
    if(self.TF_password.text.length==0)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
}
- (IBAction)btnClick_forgetPassword:(UIButton *)sender {
    GXForgetPasswordController*forgetVC=[[GXForgetPasswordController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (IBAction)btnClick_next:(UIButton *)sender {
    NSDictionary*params=@{
                          @"account":[GXUserInfoTool getLoginAccount],
                          @"password":self.TF_password.text,
                          };
    [self.view showLoadingWithTitle:@"正在验证密码"];
    [GXHttpTool POST:GXUrl_login parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            GXChangePhoneNumController*vertyVC=[[GXChangePhoneNumController alloc]init];
            [self.navigationController pushViewController:vertyVC animated:YES];
        }
        else
        {
            [self.view showFailWithTitle:@"密码错误"];
        }
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络状况"];
    }];
}




@end

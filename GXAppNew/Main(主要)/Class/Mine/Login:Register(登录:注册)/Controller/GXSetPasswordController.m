//
//  GXSetPasswordController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSetPasswordController.h"

@interface GXSetPasswordController ()

@end

@implementation GXSetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    self.title=@"快速注册";
    self.TF_password.delegate=self;
    [UIView setBorForView:self.btn_finishRegist withWidth:0 andColor:nil andCorner:5];
//    [self.btn_finishRegist setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_finishRegist setBtn_nextControlStateDisabled];
}
-(void)editClick
{
    if(self.TF_password.text.length==0)
    {
        self.btn_finishRegist.enabled=NO;
    }
    else
    {
        self.btn_finishRegist.enabled=YES;
    }
}
- (IBAction)btnClick_regist:(UIButton *)sender {
    if(![[self.TF_password.text checkPassword]isEqualToString:Check_Password_Qualified])
    {
        [self.view showFailWithTitle:[self.TF_password.text checkPassword]];
        return;
    }
    [self regist];
}
-(void)regist
{
    NSString *source = [[NSString alloc]init];
    if (self.registerStr == nil) {
        source = GXDefaultSiteReg;
    }else{
        source = self.registerStr;
    }
    NSDictionary*params=@{
                          @"mobile":self.phoneNum,
                          @"verCode":self.verCode,
                          @"password":self.TF_password.text,
                          @"source":source,
                          };
    
    [self.view showLoadingWithTitle:@"正在提交注册相关数据"];
    [GXHttpTool POST:GXUrl_register parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [self.view showSuccessWithTitle:@"注册成功"];
            [GXUserInfoTool saveUserTocken:responseObject[@"value"][@"userToken"]];
            [GXUserInfoTool savePhoneNum:self.phoneNum];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [GXUserInfoTool loginSuccess];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
            
            // 统计idfa
            NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            NSMutableDictionary *parameter = [NSMutableDictionary new];
            parameter[@"idfa"] = adId;
            parameter[@"mobile"] = [GXUserInfoTool getPhoneNum];
            
            [GXHttpTool POSTCache:GXUrl_registerIDFA parameters:parameter success:^(id responseObject) {
            } failure:^(NSError *error) {}];
            
            
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络设置"];
        
    }];
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

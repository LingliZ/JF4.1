//
//  GXChangePhoneNumController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXChangePhoneNumController.h"

@interface GXChangePhoneNumController ()

@end

@implementation GXChangePhoneNumController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"更换手机";
    self.TF_phoneNum.delegate=self;
    self.TF_vertyCode.delegate=self;
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
//    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_next setBtn_nextControlStateDisabled];
}
-(void)editClick
{
    if(self.TF_phoneNum.text.length==0||self.TF_vertyCode.text.length==0)
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
        [self.view showFailWithTitle:@"请输入正确的手机号"];
        return;
    }
    [GXUserInfoTool sendVerCodeForViewController:self WithPhoneNumber:self.TF_phoneNum.text FromButton:self.btn_sendVertyCode];
    [self.currentTF resignFirstResponder];
}

- (IBAction)btnClick_finish:(UIButton *)sender {
            NSDictionary*params=@{
                          @"mobile":self.TF_phoneNum.text,
                          @"verCode":self.TF_vertyCode.text,
                          };
    [self.view showLoadingWithTitle:@"正在更换手机号"];
    [GXHttpTool POST:GXUrl_updateMobile parameters:params success:^(id responseObject) {
    
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [self.view showSuccessWithTitle:@"手机号更换成功"];
            [GXUserInfoTool saveLoginAccount:self.TF_phoneNum.text];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count-4] animated:YES];
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

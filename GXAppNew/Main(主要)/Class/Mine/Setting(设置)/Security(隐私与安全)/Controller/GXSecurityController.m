//
//  GXSecurityController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXSecurityController.h"

@interface GXSecurityController ()

@end

@implementation GXSecurityController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createUI];
}
-(void)createUI
{
    self.title=@"账号";
    self.label_account.text=[GXUserInfoTool getLoginAccount];
    if(self.label_account.text.length)
    {
        self.label_account.text=[self.label_account.text stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    if(sender.tag==0)
    {
        //修改密码
        GXChangePasswordController*changeVC=[[GXChangePasswordController alloc]init];
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    if(sender.tag==1)
    {
        //更换手机号
        GXChangePhoneIndexController*changeVC=[[GXChangePhoneIndexController alloc]init];
        [self.navigationController pushViewController:changeVC animated:YES];
    }
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

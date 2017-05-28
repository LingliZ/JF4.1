//
//  GXAboutUsViewController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAboutUsViewController.h"

@interface GXAboutUsViewController ()



@end

@implementation GXAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"关于国鑫";
    
    self.lb_version.text = [NSString stringWithFormat:@"国鑫金服 %@",versionInformation];
    
}
- (IBAction)btnClick:(UIButton *)sender {
    if(sender.tag==0)
    {
        //客服电话
        [MobClick event:@"uc_service_tel"];
        [UIButton callPhoneWithPhoneNum:GXPhoneNum atView:self.view];
    }
    if(sender.tag==1)
    {
        //官网
        GXGoverntController*govVC=[[GXGoverntController alloc]init];
        [self.navigationController pushViewController:govVC animated:YES];
    }
    if(sender.tag==2)
    {
        //服务协议
        GXAgreementController*agreeVC=[[GXAgreementController alloc]init];
        agreeVC.urlString=AgreeType_GUOXIN_REGISTER;
        [self.navigationController pushViewController:agreeVC animated:YES];
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

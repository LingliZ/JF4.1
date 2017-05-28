//
//  GXAddCountSetPasswordController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAddCountSetPasswordController.h"

@interface GXAddCountSetPasswordController ()

@end

@implementation GXAddCountSetPasswordController
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
    self.title=@"密码设置";
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    self.TF_passwordDeal.delegate=self;
    self.TF_passwordPhone.delegate=self;
//    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_next setBtn_nextControlStateDisabled];
}
- (IBAction)btnClick_next:(UIButton *)sender {
    GXAddCountSelectBankController*selectBankVC=[[GXAddCountSelectBankController alloc]init];
    [self.navigationController pushViewController:selectBankVC animated:YES];
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

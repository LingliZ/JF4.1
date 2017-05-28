//
//  GXAddAccountSetKeywordsForGuangguiController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/2.
//  Copyright © 2017年 futang yang. All rights reserved.
//

/*
 广贵开户--设置密码
 */
#import "GXMineBaseViewController.h"
#import "GXAddAccountVertyBankForGuangguiController.h"
@interface GXAddAccountSetKeywordsForGuangguiController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *TF_login_password;//交易密码(用于登录交易中心)
@property (weak, nonatomic) IBOutlet UITextField *TF_login_confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *TF_deal_password;//资金密码(用于转账)
@property (weak, nonatomic) IBOutlet UITextField *TF_deal_confirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *btn_finish;
@property (weak, nonatomic) IBOutlet UILabel *label_agreement;


@end

//
//  GXLoginByAccountViewController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXForgetPasswordController.h"
#import "GXAgreementController.h"
@interface GXLoginByAccountViewController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet GXMineBaseTextField *TF_phoneNum;
@property (weak, nonatomic) IBOutlet GXMineBaseTextField *TF_password;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;

@end

//
//  GXChangePasswordController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXForgetPasswordController.h"
@interface GXChangePasswordController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *TF_oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *TF_newPassword;
@property (weak, nonatomic) IBOutlet UITextField *TF_confirmPassword;

@property (weak, nonatomic) IBOutlet UIButton *btn_confirm;


@end

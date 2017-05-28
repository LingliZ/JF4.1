//
//  GXForgetPasswordController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"

@interface GXForgetPasswordController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *TF_phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *TF_vertyCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_GetVerCode;
@property (weak, nonatomic) IBOutlet UIButton *Btn_next;
@property (weak, nonatomic) IBOutlet UITextField *TF_newPassword;

@end

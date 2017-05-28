//
//  GXLoginByVertyViewController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXLoginByAccountViewController.h"
#import "GXRegisterViewController.h"
#import "GXAgreementController.h"
@interface GXLoginByVertyViewController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *TF_phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *TF_vertyNum;
@property (weak, nonatomic) IBOutlet UIButton *btn_GetVertyNum;
@property (weak, nonatomic) IBOutlet UIButton *btn_Login;
@property (weak, nonatomic) IBOutlet UIButton *btn_regist;
@property (weak, nonatomic) IBOutlet UIButton *btn_loginByAcount;
@property (nonatomic,copy)NSString *registerStr;

@end

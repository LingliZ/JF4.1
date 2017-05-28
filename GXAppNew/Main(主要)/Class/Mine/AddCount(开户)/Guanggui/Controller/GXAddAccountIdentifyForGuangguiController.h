//
//  GXAddAccountIdentifyForGuangguiController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/2.
//  Copyright © 2017年 futang yang. All rights reserved.
//

/*
 广贵开户--实名认证
 */
#import "GXMineBaseViewController.h"
#import "GXAddAccountIllegalAgeForGuangguiController.h"
#import "GXAddAccountSetKeywordsForGuangguiController.h"
@interface GXAddAccountIdentifyForGuangguiController : GXMineBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *TF_name;
@property (weak, nonatomic) IBOutlet UITextField *TF_IdNum;
@property (weak, nonatomic) IBOutlet UITextField *TF_mail;

@property (weak, nonatomic) IBOutlet UIButton *btn_next;





@end

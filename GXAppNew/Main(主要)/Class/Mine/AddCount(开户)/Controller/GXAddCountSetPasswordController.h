//
//  GXAddCountSetPasswordController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXAddCountSelectBankController.h"
@interface GXAddCountSetPasswordController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet GXMineBaseTextField *TF_passwordDeal;
@property (weak, nonatomic) IBOutlet GXMineBaseTextField *TF_passwordPhone;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;

@end

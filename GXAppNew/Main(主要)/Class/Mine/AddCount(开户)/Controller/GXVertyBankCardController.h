//
//  GXVertyBankCardController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/24.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXMineBankModel.h"
#import "GXAddCountSuccessController.h"
#import "GXAddCountSucessModel.h"
@interface GXVertyBankCardController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btn_next;
@property(nonatomic,strong)GXMineBankModel*model;
@property (weak, nonatomic) IBOutlet GXMineBaseTextField *TF_bankCardNum;
@end

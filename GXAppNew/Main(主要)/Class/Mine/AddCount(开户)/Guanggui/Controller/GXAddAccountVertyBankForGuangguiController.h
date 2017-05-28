//
//  GXAddAccountVertyBankForGuangguiController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXAddAccountBankListForGuangguiController.h"
#import "GXMineBankModel.h"
#import "GXVertyBankPhoneNumForGuangguiView.h"
#import "GXAddAccountSuccessForGuangguiController.h"
#import "GXGuangguiSelectProvinceController.h"
#import "GXGuangguiProvince_rowModel.h"
#import "GXGuangguiCityModel.h"
@interface GXAddAccountVertyBankForGuangguiController : GXMineBaseViewController<GXVertyBankPhoneNumForGuangguiViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *TF_cardOwner;
@property (weak, nonatomic) IBOutlet UITextField *TF_cardNum;

@property (weak, nonatomic) IBOutlet UIButton *btn_bankName;
@property (weak, nonatomic) IBOutlet UIButton *btn_bankAddress;
@property (weak, nonatomic) IBOutlet UITextField *TF_cardPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *label_agreement;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;

@end

//
//  GXVertyIdentifyWithPhoneController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXChangePhoneNumController.h"
@interface GXVertyIdentifyWithPhoneController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet GXMineBaseTextField *TF_phoneNum;
@property (weak, nonatomic) IBOutlet GXMineBaseTextField *TF_vertyCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_sendVertyCode;



@property (weak, nonatomic) IBOutlet UIButton *btn_next;

@end

//
//  GXSignAgreementFinishedController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXCustomerSurveyOneController.h"
#import "GXAgreementController.h"
@interface GXSignAgreementFinishedController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UIView *view_agree1;
@property (weak, nonatomic) IBOutlet UIButton *btn_agrees;

@property (weak, nonatomic) IBOutlet UIView *view_agree2;
@property (weak, nonatomic) IBOutlet UIButton *btn_agree;

@property (weak, nonatomic) IBOutlet UIButton *btn_finish;
@property (weak, nonatomic) IBOutlet UILabel *label_agree1;

@end

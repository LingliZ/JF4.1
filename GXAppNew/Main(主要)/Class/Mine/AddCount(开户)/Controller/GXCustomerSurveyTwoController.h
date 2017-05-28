//
//  GXCustomerSurveyTwoController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXAddCountSetPasswordController.h"
#import "MySelectQuestionsView.h"
#import "GXCustomerSurveyThreeController.h"
#import "GXAddCountSelectBankController.h"
#import "GXAddCountSucessModel.h"
#import "GXAddShanxiAccountSuccessController.h"
#import "GXAddShanxiAccountSuccessModel.h"
@interface GXCustomerSurveyTwoController : GXMineBaseViewController<MyselectQuestionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn_finish;
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (weak, nonatomic) IBOutlet UILabel *label_mark_step4;
@property (weak, nonatomic) IBOutlet UIView *view_answerResult;
@property (weak, nonatomic) IBOutlet UIButton *btn_testAgain;

@end

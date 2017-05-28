//
//  GXSignAgreementController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXSignAgreementFinishedController.h"
#import "GXCustomerSurveyOneController.h"
@interface GXSignAgreementController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *btn_next;
@property (weak, nonatomic) IBOutlet UIView *view_line;
@property(nonatomic,strong)UIWebView*webView_agree;
@property (weak, nonatomic) IBOutlet UILabel *label_mark_step4;
@end

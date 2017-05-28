//
//  GXAddCountController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXAddCountIdentityController.h"
#import "GXAccountDetailViewController.h"
#import "GXAccountStatusModel.h"
#import "GXAddCountIdentityForShanxiController.h"
#import "GXCustomerSurveyTwoController.h"
@interface GXAddCountController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_bottom;

@property (weak, nonatomic) IBOutlet UIView *view_bottom;
@property (weak, nonatomic) IBOutlet UIView *view_addCountForQilu;
@property (weak, nonatomic) IBOutlet UIButton *btn_addCountForQilu;

@property (weak, nonatomic) IBOutlet UIView *view_shanxi;
@property (weak, nonatomic) IBOutlet UIButton *btn_addCountForShanxi;

@property (weak, nonatomic) IBOutlet UIView *view_addCountForTianjin;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddCountForTianjin;
@property(nonatomic,strong)NSMutableArray*arr_dataSource;
@end

//
//  GXCustomerSurveyThreeController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXMineInvestExpirement.h"
#import "GXAddCountSetPasswordController.h"
#import "GXMineInvestYearsModel.h"
#import "GXMineInvestTypeModel.h"
#import "GXMineInvestTypesView.h"
#import "GXAddCountSelectBankController.h"
@interface GXCustomerSurveyThreeController : GXMineBaseViewController<GXMineInvestExpirementCellDelegate,GXMineInvestTypesViewDelegate>
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)UIButton*btn_next;
@property(nonatomic,strong)GXMineBaseView*view_footerView;
@property(nonatomic,strong)GXMineInvestTypesView*view_investTypes;//投资偏好
@property (weak, nonatomic) IBOutlet UILabel *label_instruct;
@property(nonatomic,strong)NSMutableArray*arr_investYears;//投资年限
@property(nonatomic,strong)NSMutableArray*arr_investTypes;//投资偏好
@end

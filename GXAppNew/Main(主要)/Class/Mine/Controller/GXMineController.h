//
//  GXMineController.h
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXBaseViewController.h"
#import "GXMine_HeadView_Login.h"
#import "GXMine_HeadView_noLogin.h"
#import "GXMine_HomeCell.h"
#import "GXmine_HomeModel.h"
#import "GXUserInfoModel.h"
#import "GXLoginByVertyViewController.h"
#import "GXSettingController.h"
#import "GXHelpCenterController.h"
#import "GXFeedBackController.h"
#import "GXAddCountController.h"
#import "GXAddCountIdentityController.h"
#import "GXAddCountSelectBankController.h"
#import "GXCustomerSurveyThreeController.h"
#import "GXAccountDetailViewController.h"
#import "GXCustomerInfoController.h"
#import "GXHomeMsgCenterController.h"
#import "GXVertyBankCardController.h"
#import "ChatViewController.h"

#import "GXAddCountIdentityForShanxiController.h"
#import "GXAddShanxiAccountSuccessController.h"
#import "GXCustomerSurveyTwoController.h"
#import "GXPickerImageController.h"
#import "GXAddAccountIdentifyForGuangguiController.h"
#import "GXAddAccountSuccessForGuangguiController.h"
#import "GXGuangguiSelectProvinceController.h"
#import "GXAddAccountSetKeywordsForGuangguiController.h"
#import "GXAddAccountVertyBankForGuangguiController.h"
@interface GXMineController : GXBaseViewController<UITableViewDelegate,UITableViewDataSource,GXMine_HomeCellDelegate>
@property(nonatomic,strong)GXMine_HeadView_Login*view_login;
@property(nonatomic,strong)GXMine_HeadView_noLogin*view_noLogin;
@property(nonatomic,strong)NSMutableArray*arr_dataSource;
@property(nonatomic,strong)GXUserInfoModel*model_userInfo;
@end

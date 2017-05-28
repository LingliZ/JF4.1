//
//  GXAccountListController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/3.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXAddAccountListCell.h"
#import "GXAddAccountListModel.h"
#import "GXAddCountIdentityController.h"
#import "GXAddCountIdentityForShanxiController.h"
#import "GXAddAccountIdentifyForGuangguiController.h"
#import "GXAccountDetailViewController.h"
@interface GXAccountListController : GXMineBaseViewController<GXAddAccountListCellDelegate>
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)NSMutableArray*arr_dataSource;
@end

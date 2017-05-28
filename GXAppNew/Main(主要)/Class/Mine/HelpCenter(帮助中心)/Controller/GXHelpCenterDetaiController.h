//
//  GXHelpCenterDetaiController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/10.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXHelpModel.h"
#import "GXHelpDetailFootView.h"
#import "GXHelpDetailCell.h"
#import "GXHelpDetaiSectionlHeaderView.h"
#import "GXHelpItemDetailController.h"
#import "GXInvestmentProductViewController.h"
@interface GXHelpCenterDetaiController : GXMineBaseViewController<GXHelpDetailSectionHeaderViewDelegate>
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)NSMutableArray*arr_dataSource;
@end

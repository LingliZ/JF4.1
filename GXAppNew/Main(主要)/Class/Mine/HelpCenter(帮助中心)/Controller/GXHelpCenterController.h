//
//  GXHelpCenterController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXHelpCenterDetaiController.h"
#import "GXHelpModel.h"
@interface GXHelpCenterController : GXMineBaseViewController
@property(nonatomic,strong)NSArray*arr_DataSource;
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@end

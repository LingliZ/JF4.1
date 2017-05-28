//
//  GXShortMsgAlertController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/14.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXShortMsgAlertCell.h"
#import "GXPushSetModel.h"
@interface GXShortMsgAlertController : GXMineBaseViewController<GXShortMsgAlertCellDelegate>
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)NSMutableArray*arr_dataSource;
@end

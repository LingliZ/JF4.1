//
//  GXPushSetViewController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXPushSetCell.h"
#import "GXPushSetModel.h"
@interface GXPushSetViewController : GXMineBaseViewController<GXPushSetCellDelegate>
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)NSMutableArray*arr_dataSource;
@end

//
//  GXAddAccountBankListForGuangguiController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXMineBankModel.h"
#import "GXBankForGuangguiCell.h"
typedef void(^bankBlocks) (GXMineBankModel*model);
@interface GXAddAccountBankListForGuangguiController : GXMineBaseViewController
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)NSMutableArray*arr_dataSource;
@property(nonatomic,copy)bankBlocks selectBank;
@end

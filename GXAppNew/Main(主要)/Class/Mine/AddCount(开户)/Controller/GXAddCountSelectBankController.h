//
//  GXAddCountSelectBankController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXMineBankCell.h"
#import "GXMineBankModel.h"
#import "GXVertyBankCardController.h"
#import "ChatViewController.h"
@interface GXAddCountSelectBankController : GXMineBaseViewController
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)NSArray*dataSource;
@end

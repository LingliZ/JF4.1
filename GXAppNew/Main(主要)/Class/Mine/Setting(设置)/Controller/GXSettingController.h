//
//  GXSettingController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXSetModel.h"
#import "GXSetCell.h"
#import "GXLoginByVertyViewController.h"
#import "GXSecurityController.h"
#import "GXShortMsgAlertController.h"
#import "GXPushSetViewController.h"
#import "GXAboutUsViewController.h"

@interface GXSettingController : GXMineBaseViewController<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn_LoginOut;
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)NSMutableArray*arr_dataSource;
@end

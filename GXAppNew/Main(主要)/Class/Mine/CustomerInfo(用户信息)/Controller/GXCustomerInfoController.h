//
//  GXCustomerInfoController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXCustomerInfoCell.h"
#import "GXCustomerInfoCellModel.h"
#import "GXChangeNameOrNickNameController.h"
#import "GXPickerImageController.h"
@interface GXCustomerInfoController : GXMineBaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)NSMutableArray*arr_dataSource;
@end

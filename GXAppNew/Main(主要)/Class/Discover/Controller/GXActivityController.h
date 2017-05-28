//
//  GXActivityController.h
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXBaseTableViewController.h"
#import "GXHomeAdvertistsModel.h"


@interface GXActivityController : GXBaseTableViewController

@property (nonatomic,strong) GXHomeAdvertistsModel *advModel;
@property (nonatomic,strong) NSMutableArray *recieveArray;


@end

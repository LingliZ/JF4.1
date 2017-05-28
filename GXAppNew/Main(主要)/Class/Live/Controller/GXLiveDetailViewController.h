//
//  GXLiveDetailViewController.h
//  GXAppNew
//
//  Created by maliang on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXBaseViewController.h"
#import "GXVideoModel.h"


@interface GXLiveDetailViewController : GXBaseViewController

@property(nonatomic,strong)NSString * roomID;
@property(nonatomic, strong) NSString * nameTitle;

@property(nonatomic, strong) GXVideoModel *detailModel;

@end

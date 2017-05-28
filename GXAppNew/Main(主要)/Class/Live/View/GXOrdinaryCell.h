//
//  GXOrdinaryCell.h
//  GXAppNew
//
//  Created by maliang on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXVideoModel.h"


typedef void(^myBlock)();

@interface GXOrdinaryCell : UITableViewCell

@property(nonatomic, copy) GXVideoModel *model;
@property(nonatomic, copy) void(^myBlock)();
@end

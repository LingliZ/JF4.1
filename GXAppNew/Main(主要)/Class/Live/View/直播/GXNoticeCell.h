//
//  GXNoticeCell.h
//  GXAppNew
//
//  Created by maliang on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXNoticeModel.h"

@interface GXNoticeCell : UITableViewCell

@property(nonatomic, strong) GXNoticeModel *model;

@property (nonatomic, assign) CGFloat cellHeight;


@end

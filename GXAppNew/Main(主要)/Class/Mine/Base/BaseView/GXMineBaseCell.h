//
//  GXMineBaseCell.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXMineBaseModel.h"
@interface GXMineBaseCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath*indexPath;
-(void)setModel:(GXMineBaseModel*)model;
@end

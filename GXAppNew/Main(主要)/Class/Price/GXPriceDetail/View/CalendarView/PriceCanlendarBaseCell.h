//
//  PriceCanlendarBaseCell.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceCanlendarBaseModel;

@interface PriceCanlendarBaseCell : UITableViewCell

- (void)setModel:(PriceCanlendarBaseModel *)model;

+ (instancetype)cellWithTable:(UITableView *)tablew Model:(PriceCanlendarBaseModel *)model  indexPath:(NSIndexPath *)indexpath;

@end

//
//  GXHomeTextCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXHomeTextModel.h"
@interface GXHomeTextCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *sourceLabel;
@property (strong, nonatomic) UILabel *readCountLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (nonatomic,strong)GXHomeTextModel *model;

@end

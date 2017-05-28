//
//  GXHomeMsgCenterCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeMsgCenterCell.h"

@implementation GXHomeMsgCenterCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.warnLabel.layer.cornerRadius = 7.5;
    self.warnLabel.layer.masksToBounds = YES;
    UIView *lineView =[[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@-0.5);
        make.height.equalTo(@0.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  GXBankForGuangguiCell.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXBankForGuangguiCell.h"

@implementation GXBankForGuangguiCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setModel:(GXMineBaseModel *)model
{
    GXMineBankModel*bankModel=(GXMineBankModel*)model;
    [self.img_mark sd_setImageWithURL:[NSURL URLWithString:bankModel.imageUrl]];
    self.label_name.text=bankModel.name;
    self.label_introduce.text=bankModel.introduce;
}
@end

//
//  GXSingleCell.m
//  GXApp
//
//  Created by maliang on 2016/11/15.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXSingleCell.h"

@interface GXSingleCell ()

@property (nonatomic, strong) UILabel *leftL;
@property (nonatomic, strong) UILabel *centerL;
@property (nonatomic, strong) UILabel *rightL;

@end



@implementation GXSingleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    UILabel *leftL = [UILabel new];
    leftL.font = GXFONT_PingFangSC_Regular(14);
    leftL.textColor = GXRGBColor(134, 134, 134);
    UILabel *centerL = [UILabel new];
    centerL.font = GXFONT_PingFangSC_Regular(14);
    centerL.textColor = GXRGBColor(134, 134, 134);
    UILabel *rightL = [UILabel new];
    rightL.font = GXFONT_PingFangSC_Regular(14);
    rightL.textColor = GXRGBColor(134, 134, 134);
    
    [self.contentView addSubview:leftL];
    [self.contentView addSubview:centerL];
    [self.contentView addSubview:rightL];
    
    self.leftL = leftL;
    self.centerL = centerL;
    self.rightL = rightL;
    
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(2 * Margin);
        make.top.equalTo(self.contentView).offset(0.5 * Margin);
        make.bottom.equalTo(self.contentView).offset(- 0.5 * Margin);
        make.width.equalTo(@(WidthScale_IOS6(80)));
    }];
    
    [centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WidthScale_IOS6(95));
        make.centerY.equalTo(leftL);
    }];
    
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-WidthScale_IOS6(15));
        make.centerY.equalTo(centerL);
    }];
}

- (void)setModel:(GXOperationItemModel *)model
{
    _model = model;
    self.leftL.text = model.leftStr;
    self.centerL.text = model.centerStr;
    self.rightL.text = model.rightStr;
}


@end

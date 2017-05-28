//
//  GXTopDoubleCell.m
//  GXApp
//
//  Created by maliang on 2016/11/18.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXTopDoubleCell.h"

@interface GXTopDoubleCell ()

@property (nonatomic, strong)UILabel *leftL;
@property (nonatomic, strong)UILabel *centerUL;
@property (nonatomic, strong)UILabel *centerDL;
@property (nonatomic, strong)UILabel *rightL;

@end

@implementation GXTopDoubleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UILabel *leftL = [UILabel new];
    leftL.font = GXFONT_PingFangSC_Medium(16);
    leftL.textColor = [UIColor whiteColor];
    leftL.textAlignment = NSTextAlignmentCenter;
    UILabel *centerUL = [UILabel new];
    centerUL.font = GXFONT_PingFangSC_Regular(14);
    centerUL.textColor = GXRGBColor(134, 134, 134);
    UILabel *centerDL = [UILabel new];
    centerDL.font = GXFONT_PingFangSC_Regular(14);
    centerDL.textColor = GXRGBColor(134, 134, 134);
    UILabel *rightL = [UILabel new];
    rightL.font = GXFONT_PingFangSC_Regular(14);
    rightL.textColor = GXRGBColor(134, 134, 134);
    
    [self.contentView addSubview:leftL];
    [self.contentView addSubview:centerUL];
    [self.contentView addSubview:centerDL];
    [self.contentView addSubview:rightL];
    
    self.leftL = leftL;
    self.centerUL = centerUL;
    self.centerDL = centerDL;
    self.rightL = rightL;
    
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(2 * Margin);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@(WidthScale_IOS6(80)));
    }];
    
    [centerUL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WidthScale_IOS6(95));
        make.top.equalTo(self.contentView).offset(0.5 * Margin);
    }];
    
    [centerDL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerUL.mas_left);
        make.top.equalTo(centerUL.mas_bottom).offset(-0.5 * Margin);
        make.bottom.equalTo(self.contentView).offset(-0.5 * Margin);
    }];
    
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-WidthScale_IOS6(15));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setModel:(GXOperationItemModel *)model
{
    _model = model;
    self.leftL.text = model.leftStr;
    
    [self.leftL sizeToFit];
    NSInteger width = self.leftL.frame.size.width + WidthScale_IOS6(8);
    
    [self.leftL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    
    if ([model.leftStr isEqualToString:@"减持"]) {
        self.centerUL.text = [NSString stringWithFormat:@"点位:%@",model.stopPrice];
        self.centerDL.text = [NSString stringWithFormat:@"仓位:%@%%",model.positions];
    }else{
        self.centerUL.text = [NSString stringWithFormat:@"止损价修改为:%@",model.stopPrice];
        self.centerDL.text = [NSString stringWithFormat:@"目标价修改为:%@",model.targetPrice];
    }
    self.rightL.text = model.rightStr;
    
    if ([self.model.leftStr isEqualToString:@"减持"]) {
        self.leftL.backgroundColor = [UIColor getColor:@"569AE0"];
    }else if ([self.model.leftStr isEqualToString:@"平仓"] || [self.model.leftStr isEqualToString:@"已回购"]) {
        self.leftL.backgroundColor = [UIColor getColor:@"C5C5C5"];
    }else if ([self.model.leftStr isEqualToString:@"撤单"]) {
        self.leftL.backgroundColor = [UIColor getColor:@"C5C5C5"];
    }else {
        self.leftL.backgroundColor = [UIColor getColor:@"E4A928"];
    }
}

@end

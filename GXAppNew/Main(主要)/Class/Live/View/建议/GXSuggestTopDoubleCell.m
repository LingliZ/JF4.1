//
//  GXSuggestTopDoubleCell.m
//  GXAppNew
//
//  Created by maliang on 2016/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSuggestTopDoubleCell.h"

@interface GXSuggestTopDoubleCell ()

@property (nonatomic, strong)UILabel *leftL;
@property (nonatomic, strong)UILabel *centerUL;
@property (nonatomic, strong)UILabel *centerDL;
@property (nonatomic, strong)UILabel *rightL;

@end

@implementation GXSuggestTopDoubleCell

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
    UIView *topDoubleCellBackView = [[UIView alloc] init];
    topDoubleCellBackView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = GXRGBColor(237, 238, 245);
    [self.contentView addSubview:topDoubleCellBackView];
    UILabel *leftL = [UILabel new];
    leftL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    leftL.textColor = GXRGBColor(161, 166, 187);
    UILabel *centerUL = [UILabel new];
    centerUL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    centerUL.textColor = GXRGBColor(161, 166, 187);
    UILabel *centerDL = [UILabel new];
    centerDL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    centerDL.textColor = GXRGBColor(161, 166, 187);
    UILabel *rightL = [UILabel new];
    rightL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    rightL.textColor = GXRGBColor(161, 166, 187);
    
    [topDoubleCellBackView addSubview:leftL];
    [topDoubleCellBackView addSubview:centerUL];
    [topDoubleCellBackView addSubview:centerDL];
    [topDoubleCellBackView addSubview:rightL];
    
    self.leftL = leftL;
    self.centerUL = centerUL;
    self.centerDL = centerDL;
    self.rightL = rightL;
    
    [topDoubleCellBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@0);
    }];
    
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topDoubleCellBackView).offset(2 * WidthScale_IOS6(15));
        make.centerY.equalTo(topDoubleCellBackView);
        make.width.equalTo(@(WidthScale_IOS6(80)));
    }];
    
    [centerUL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topDoubleCellBackView).offset(WidthScale_IOS6(100));
        make.top.equalTo(topDoubleCellBackView).offset(WidthScale_IOS6(7));
    }];
    
    [centerDL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerUL.mas_left);
        make.top.equalTo(centerUL.mas_bottom).offset(-WidthScale_IOS6(5));
        make.bottom.equalTo(topDoubleCellBackView).offset(WidthScale_IOS6(0));
    }];
    
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topDoubleCellBackView).offset(-WidthScale_IOS6(15));
        make.centerY.equalTo(topDoubleCellBackView);
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
}


@end

//
//  GXSuggestSingleCell.m
//  GXAppNew
//
//  Created by maliang on 2016/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSuggestSingleCell.h"

@interface GXSuggestSingleCell ()

@property (nonatomic, strong) UILabel *leftL;
@property (nonatomic, strong) UILabel *centerL;
@property (nonatomic, strong) UILabel *rightL;

@end

@implementation GXSuggestSingleCell

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
    UIView *singleCellBackView = [[UIView alloc] init];
    singleCellBackView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = GXRGBColor(237, 238, 245);
    [self.contentView addSubview:singleCellBackView];
    UILabel *leftL = [UILabel new];
    leftL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    leftL.textColor = GXRGBColor(161, 166, 187);
    UILabel *centerL = [UILabel new];
    centerL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    centerL.textColor = GXRGBColor(161, 166, 187);
    UILabel *rightL = [UILabel new];
    rightL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    rightL.textColor = GXRGBColor(161, 166, 187);
    
    [singleCellBackView addSubview:leftL];
    [singleCellBackView addSubview:centerL];
    [singleCellBackView addSubview:rightL];
    
    self.leftL = leftL;
    self.centerL = centerL;
    self.rightL = rightL;
    
    [singleCellBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@0);
    }];
    
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(singleCellBackView).offset(2 * WidthScale_IOS6(15));
        make.top.equalTo(singleCellBackView).offset(0.5 * WidthScale_IOS6(10));
        make.bottom.equalTo(singleCellBackView).offset(- 0.5 * WidthScale_IOS6(10));
        make.width.equalTo(@(WidthScale_IOS6(80)));
    }];
    
    [centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(singleCellBackView).offset(WidthScale_IOS6(100));
        make.centerY.equalTo(leftL);
    }];
    
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(singleCellBackView).offset(-WidthScale_IOS6(15));
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

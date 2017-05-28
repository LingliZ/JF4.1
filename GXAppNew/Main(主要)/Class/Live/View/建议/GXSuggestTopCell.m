//
//  GXSuggestTopCell.m
//  GXAppNew
//
//  Created by maliang on 2016/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSuggestTopCell.h"

@interface GXSuggestTopCell ()

@property (nonatomic, strong)UILabel *leftL;
@property (nonatomic, strong)UILabel *centerL;
@property (nonatomic, strong)UILabel *rightL;

@end


@implementation GXSuggestTopCell


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
    UIView *topCellBackView = [[UIView alloc] init];
    topCellBackView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = GXRGBColor(237, 238, 245);
    [self.contentView addSubview:topCellBackView];
    UILabel *leftL = [UILabel new];
    leftL.textColor = GXRGBColor(161, 166, 187);
    leftL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    
    UILabel *centerL = [UILabel new];
    centerL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    centerL.textColor = GXRGBColor(161, 166, 187);
    
    UILabel *rightL = [UILabel new];
    rightL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    rightL.textColor = GXRGBColor(161, 166, 187);
    
    [topCellBackView addSubview:leftL];
    [topCellBackView addSubview:centerL];
    [topCellBackView addSubview:rightL];
    
    self.leftL = leftL;
    self.centerL = centerL;
    self.rightL = rightL;
    
    [topCellBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@0);
    }];
    
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topCellBackView).offset(2 * WidthScale_IOS6(15));
        make.top.equalTo(topCellBackView).offset(WidthScale_IOS6(10));
        make.bottom.equalTo(topCellBackView).offset(WidthScale_IOS6(-10));
    }];
    
    [centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topCellBackView).offset(WidthScale_IOS6(100));
        make.centerY.equalTo(leftL);
        make.width.equalTo(@(WidthScale_IOS6(180)));
    }];
    
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topCellBackView).offset(-WidthScale_IOS6(15));
        make.centerY.equalTo(centerL);
    }];
}

- (void)setModel:(GXOperationItemModel *)model
{
    _model = model;
    
    if ([model.types intValue] == 2) {
        self.leftL.text = [model.leftStr substringFromIndex:1];
    } else {
        self.leftL.text = model.leftStr;
    }
    [self.leftL sizeToFit];
    NSInteger width = self.leftL.frame.size.width + WidthScale_IOS6(8);
    
    [self.leftL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    self.rightL.text = model.rightStr;
    if ([model.types integerValue] == 3) {
        self.centerL.text = @"";
    }else{
        self.centerL.text = model.centerStr;
    }
}


@end

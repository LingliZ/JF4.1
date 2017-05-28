//
//  GXNoticeCell.m
//  GXAppNew
//
//  Created by maliang on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXNoticeCell.h"
#import <YYText/YYText.h>
#import "NSString+GXEmotAttributedString.h"
#import "GXLiveTimeTool.h"

@interface GXNoticeCell ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) YYLabel *contentL;
@property (nonatomic, strong) UIView *bgView;


@end

@implementation GXNoticeCell

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
    self.bgView = [[UIView alloc] init];
    self.bgView.layer.cornerRadius = WidthScale_IOS6(10);
    self.bgView.layer.masksToBounds = YES;
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.titleL = [[UILabel alloc] init];
    self.titleL.font = GXFONT_PingFangSC_Regular(GXFitFontSize16);
    self.titleL.textColor = GXRGBColor(18, 29, 61);
    self.titleL.numberOfLines = 0;
    self.nameL = [[UILabel alloc] init];
    self.nameL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.nameL.textColor = GXRGBColor(161, 166, 187);
    self.timeL = [[UILabel alloc] init];
    self.timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.timeL.textColor = GXRGBColor(161, 166, 187);
    self.contentL = [[YYLabel alloc] init];
    self.contentL.preferredMaxLayoutWidth = WidthScale_IOS6(325);
    self.contentL.numberOfLines = 0;
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleL];
    [self.bgView addSubview:self.nameL];
    [self.bgView addSubview:self.timeL];
    [self.bgView addSubview:self.contentL];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(WidthScale_IOS6(10));
        make.right.bottom.equalTo(self.contentView).offset(WidthScale_IOS6(-10));
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(WidthScale_IOS6(10)));
        make.top.mas_equalTo(@(HeightScale_IOS6(20)));
        make.right.mas_equalTo(@(WidthScale_IOS6(-10)));
    }];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL);
        make.right.mas_equalTo(self.titleL);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(HeightScale_IOS6(10));
    }];
    [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(WidthScale_IOS6(10)));
        make.top.mas_equalTo(self.contentL.mas_bottom).offset(HeightScale_IOS6(15));
        make.bottom.equalTo(@(WidthScale_IOS6(-15)));
    }];
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@(WidthScale_IOS6(-10)));
        make.centerY.mas_equalTo(self.nameL);
    }];
    
}
- (void)setModel:(GXNoticeModel *)model
{
    _model = model;
    self.titleL.text = model.title;
    self.contentL.attributedText = [NSString dealContentText:model.content withView:self];
    self.contentL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.contentL.textColor = GXRGBColor(101, 106, 137);
    self.nameL.text = model.creatorName;
    self.timeL.text = [GXLiveTimeTool getTimeString:model.startTime];
    
}

@end

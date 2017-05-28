//
//  GXQAndACell.m
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXQAndAUpCell.h"
#import <YYText/YYText.h>
#import "NSString+GXEmotAttributedString.h"
#import "GXPicturesView.h"
#import "GXLiveCommonSize.h"
#import "GXLiveTimeTool.h"
#import "GXHeadReduceTool.h"

@interface GXQAndAUpCell ()

@property (nonatomic, strong)UIImageView *headV;
@property (nonatomic, strong)UILabel *nameL;
@property (nonatomic, strong)UILabel *timeL;
@property (nonatomic, strong)YYLabel *contentL;
@property (nonatomic, strong)GXPicturesView *picturesView;

@end

@implementation GXQAndAUpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.contentView.backgroundColor = AdviserBGColor;
        self.backgroundColor = AdviserBGColor;
    }
    return self;
}

- (void)createUI
{
    UIImageView *headV = [[UIImageView alloc] init];
    headV.layer.cornerRadius = WidthScale_IOS6(20);
    headV.layer.masksToBounds = YES;
    UILabel *nameL = [[UILabel alloc] init];
    nameL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    nameL.textColor = GXRGBColor(64, 130, 244);
    UILabel *timeL = [[UILabel alloc] init];
    timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    timeL.textColor = GXRGBColor(161, 166, 187);
    YYLabel *contentL = [[YYLabel alloc] init];
    contentL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    contentL.preferredMaxLayoutWidth = WidthScale_IOS6(285);
    contentL.numberOfLines = 0;
    
    [self.contentView addSubview:headV];
    [self.contentView addSubview:nameL];
    [self.contentView addSubview:timeL];
    [self.contentView addSubview:contentL];
    
    self.headV = headV;
    self.nameL = nameL;
    self.timeL = timeL;
    self.contentL = contentL;
    
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(@(WidthScale_IOS6(10)));
        make.width.height.mas_equalTo(@(WidthScale_IOS6(40)));
    }];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headV.mas_top);
        make.left.mas_equalTo(headV.mas_right).offset(WidthScale_IOS6(10));
    }];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameL);
        make.left.mas_equalTo(nameL.mas_right).offset(WidthScale_IOS6(7));
    }];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameL.mas_left);
        make.top.mas_equalTo(nameL.mas_bottom).offset(HeightScale_IOS6(5));
        make.width.equalTo(@(WidthScale_IOS6(285)));
        make.bottom.mas_equalTo(@(-GXMargin));
    }];
    
}

- (void)setModel:(GXQAndAModel *)model
{
    _model = model;
    [GXHeadReduceTool loadImageForImageView:self.headV withUrlString:model.photo placeHolderImageName:@"mine_head_placeholder"];
    NSMutableAttributedString *mAS = [[NSMutableAttributedString alloc] initWithString:model.answerName attributes:@{NSForegroundColorAttributeName : GXRGBColor(64, 130, 244), NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14)}];
    NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:@"回复" attributes:@{NSForegroundColorAttributeName : GXRGBColor(161, 166, 187), NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14)}];
    [mAS appendAttributedString:attrS];
    self.nameL.attributedText = mAS;
    self.timeL.text = [GXLiveTimeTool changeTimeString:model.answerTime];
    self.contentL.attributedText = [NSString dealContentText:model.answer withView:self];
    self.contentL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.contentL.textColor = GXRGBColor(101, 106, 137);
}



- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.tag == 0) {
        UIBezierPath *maskPath;
        CGRect rect = self.bounds;
        UIView *bgV = [[UIView alloc] initWithFrame:rect];
        maskPath = [UIBezierPath bezierPathWithRoundedRect:bgV.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(GXMargin, GXMargin)];
        [self.contentView addSubview:bgV];
        [self.contentView sendSubviewToBack:bgV];
        
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = bgV.bounds;
        shapeLayer.path = maskPath.CGPath;
        bgV.layer.mask = shapeLayer;
        bgV.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = GXAdviserBGColor;
    }
}
@end

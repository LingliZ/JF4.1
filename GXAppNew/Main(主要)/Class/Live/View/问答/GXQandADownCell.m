//
//  GXTeacherAnswerCell.m
//  GXAppNew
//
//  Created by maliang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXQandADownCell.h"
#import <YYText/YYText.h>
#import "NSString+GXEmotAttributedString.h"
#import "GXPicturesView.h"
#import "GXLiveCommonSize.h"
#import "GXLiveTimeTool.h"
#import "GXHeadReduceTool.h"

#define AskPictureWidth (GXScreenWidth - WidthScale_IOS6(112) - 2 * imageMargin) / 3.0

@interface GXQandADownCell ()

@property (nonatomic, strong)UIImageView *headV;
@property (nonatomic, strong) YYLabel *questionL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) MASConstraint *leftCons;

@end

@implementation GXQandADownCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.contentView.backgroundColor = AdviserBGColor;
        
    }
    return self;
}

- (void)createUI
{
    UIImageView *headV = [[UIImageView alloc] init];
    
    YYLabel *questionL = [[YYLabel alloc] init];
    //需要先设置Font
    questionL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    questionL.numberOfLines = 0;
    questionL.textColor = GXRGBColor(101, 106, 137);
    questionL.preferredMaxLayoutWidth = WidthScale_IOS6(255);
    
    UILabel *nameL = [[UILabel alloc] init];
    nameL.textColor = GXRGBColor(64, 130, 244);
    nameL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.nameL = nameL;
    UILabel *timeL = [[UILabel alloc] init];
    timeL.textColor = GXRGBColor(161, 166, 187);
    timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    self.timeL = timeL;
    
    [self.contentView addSubview:headV];
    [self.contentView addSubview:questionL];
    [self.contentView addSubview:nameL];
    [self.contentView addSubview:timeL];
    
    self.headV = headV;
    self.headV.layer.cornerRadius = WidthScale_IOS6(30) / 2;
    self.headV.layer.masksToBounds = YES;
    self.questionL = questionL;
    
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(WidthScale_IOS6(55)));
        make.top.mas_equalTo(@(0));
        make.width.height.mas_equalTo(@(WidthScale_IOS6(30)));
    }];
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV);
        make.left.equalTo(headV.mas_right).offset(GXMargin);
    }];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        self.leftCons = make.left.equalTo(nameL.mas_right).offset(GXMargin);
        make.centerY.equalTo(nameL);
        make.top.equalTo(self.headV);
    }];
    
    [questionL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headV.mas_right).offset(WidthScale_IOS6(10));
        make.top.mas_equalTo(headV.mas_bottom).offset((-GXMargin));
        make.bottom.mas_equalTo(@(-imageMargin));
    }];
    
}

- (void)setModel:(GXAskModel *)model
{
    _model = model;
    [GXHeadReduceTool loadImageForImageView:self.headV withUrlString:model.avatar placeHolderImageName:@"mine_head_placeholder"];
    self.nameL.text = model.nickName;
    self.timeL.text = [GXLiveTimeTool changeTimeString:model.createdTime];
    [self.leftCons uninstall];
    [self.timeL mas_updateConstraints:^(MASConstraintMaker *make) {
        if (model.nickName.length > 0) {
            self.leftCons = make.left.equalTo(self.nameL.mas_right).offset(GXMargin);
        } else {
            self.leftCons = make.left.equalTo(self.headV.mas_right).offset(GXMargin);
        }
    }];
    
    
    self.questionL.attributedText = [NSString dealContentText:model.question withView:self];
    self.questionL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.questionL.textColor = GXRGBColor(101, 106, 137);
}


- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.tag == -2) {
        UIBezierPath *maskPath;
        CGRect rect = self.bounds;
        UIView *bgV = [[UIView alloc] initWithFrame:rect];
        maskPath = [UIBezierPath bezierPathWithRoundedRect:bgV.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(GXMargin, GXMargin)];
        bgV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgV];
        [self.contentView sendSubviewToBack:bgV];
        
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = bgV.bounds;
        shapeLayer.path = maskPath.CGPath;
        bgV.layer.mask = shapeLayer;
    }else{
        UIView *bgV = [[UIView alloc] initWithFrame:self.bounds];
        bgV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgV];
        [self.contentView sendSubviewToBack:bgV];
    }
    
    self.contentView.backgroundColor = GXAdviserBGColor;
}
@end

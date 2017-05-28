//
//  PriceLandHeaderView.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "PriceLandHeaderView.h"
#import "PriceMarketModel.h"


@interface PriceLandHeaderView ()

@property (nonatomic, weak) UILabel *codeNameLabel;
@property (nonatomic, weak) UILabel *fromLabel;
@property (nonatomic, weak) UILabel *lastLabel;
@property (nonatomic, weak) UILabel *increaseLabel;
@property (nonatomic, weak) UILabel *increasePercentageLabel;
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) UILabel *quoteTimeLabel;
@property (nonatomic, weak) UIButton *closeButton;

@end


@implementation PriceLandHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}


- (void)config {

    // 关闭按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    closeButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentCenter;
    [closeButton setImage:IMAGE_NAMED(@"priceClose") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(BackToVerticalPriceVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    // code名字
    UILabel *codeNameLabel = [[UILabel alloc] init];
    self.codeNameLabel = codeNameLabel;
    [self addSubview:codeNameLabel];
    
    [codeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(15);
    }];
    
    //rgb 231 231 231
    codeNameLabel.textColor = GXRGBColor(231, 231, 231);
    codeNameLabel.text = @"现货银";
    codeNameLabel.font = GXFONT_PingFangSC_Regular(14);
    
    
    
    //来自
    UILabel *fromLabel = [[UILabel alloc] init];
    self.fromLabel = fromLabel;
    [self addSubview:fromLabel];
    
    [fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(codeNameLabel.mas_right).offset(5);
    }];
    
    //rgb 120 126 156
    fromLabel.textColor = GXRGBColor(120, 126, 156);
    fromLabel.text = @"齐鲁";
    fromLabel.font = GXFONT_PingFangSC_Regular(12);
    
    // 数值viewBG
    UIView *valueBgView = [[UIView alloc] init];
    [self addSubview:valueBgView];
    [valueBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.mas_height);
        make.leading.mas_equalTo(fromLabel.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
    }];

    
    
    //lastLabel
    UILabel *lastLabel = [[UILabel alloc] init];
    self.lastLabel = lastLabel;
    [valueBgView addSubview:lastLabel];
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(valueBgView.mas_leading);
        make.centerY.mas_equalTo(valueBgView.mas_centerY);
        make.width.mas_equalTo(valueBgView.mas_width).multipliedBy(0.33);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    lastLabel.textColor = GXRGBColor(231, 231, 231);
    lastLabel.text = @"-- --";
    lastLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    lastLabel.textAlignment = NSTextAlignmentRight;
    
    
    // increasePercentageLabel
    // increaseLabel
    
    UILabel *increaseLabel = [[UILabel alloc] init];
    self.increaseLabel = increaseLabel;
    [valueBgView addSubview:increaseLabel];
    [increaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(lastLabel.mas_trailing);
        make.centerY.mas_equalTo(valueBgView.mas_centerY);
        make.width.mas_equalTo(valueBgView.mas_width).multipliedBy(0.33);
        make.height.mas_equalTo(self.mas_height);
    }];
    
    increaseLabel.textColor = GXRGBColor(231, 231, 231);
    increaseLabel.text = @"-- --";
    increaseLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    increaseLabel.textAlignment = NSTextAlignmentCenter;
    
    
    //increaseLabel
    UILabel *increasePercentageLabel = [[UILabel alloc] init];
    self.increasePercentageLabel = increasePercentageLabel;
    [valueBgView addSubview:increasePercentageLabel];
    [increasePercentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(increaseLabel.mas_trailing);
        make.centerY.mas_equalTo(valueBgView.mas_centerY);
        make.width.mas_equalTo(valueBgView.mas_width).multipliedBy(0.33);
        make.height.mas_equalTo(self.mas_height);
    }];
    

    
    increasePercentageLabel.textColor = GXRGBColor(231, 231, 231);
    increasePercentageLabel.text = @"-- --";
    increasePercentageLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    increasePercentageLabel.textAlignment = NSTextAlignmentLeft;
    
    
    // 交易时间view
    UIView *tradTimeBgView = [[UIView alloc] init];
    [self addSubview:tradTimeBgView];

    
    [tradTimeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(valueBgView.mas_trailing);
        make.trailing.mas_equalTo(closeButton.mas_leading);
        make.height.mas_equalTo(self.mas_height);
    }];
    
 
    
    
    
    UILabel *quoteTimeLabel = [[UILabel alloc] init];
    self.quoteTimeLabel = quoteTimeLabel;
    [tradTimeBgView addSubview:quoteTimeLabel];
    
    [quoteTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tradTimeBgView.mas_centerY);
        make.trailing.mas_equalTo(tradTimeBgView.mas_trailing);
    }];
    
    //rgb 231 231 231
    quoteTimeLabel.textColor = GXRGBColor(120, 126, 156);
    quoteTimeLabel.text = @"--/-- --:--:--";
    quoteTimeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    
    
    
    // 交易状态
    UILabel *statusLabel = [[UILabel alloc] init];
    self.statusLabel = statusLabel;
    [tradTimeBgView addSubview:statusLabel];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tradTimeBgView.mas_centerY);
        make.trailing.mas_equalTo(quoteTimeLabel.mas_leading).offset(-5);
    }];
    
    //rgb 231 231 231
    statusLabel.textColor = GXRGBColor(120, 126, 156);
    statusLabel.text = @"交易中";
    statusLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    

   
}

- (void)BackToVerticalPriceVC {
    if ([self.delegate respondsToSelector:@selector(PriceLandHeaderViewBack:)]) {
        [self.delegate PriceLandHeaderViewBack:self];
    }
}

- (void)setModel:(PriceMarketModel *)model {
    _model = model;
    
    self.codeNameLabel.text = model.name;
    self.fromLabel.text = model.exname;
    self.lastLabel.text = model.last;
    self.increaseLabel.text = model.increase;
    self.increasePercentageLabel.text = model.increasePercentage;
    self.statusLabel.text = model.status;
    self.quoteTimeLabel.text = model.quoteTime;
    
    
    //颜色
    self.lastLabel.textColor = model.lastColor;
    self.increaseLabel.textColor = model.increaseBackColor;
    self.increasePercentageLabel.textColor = model.increaseBackColor;
}


@end

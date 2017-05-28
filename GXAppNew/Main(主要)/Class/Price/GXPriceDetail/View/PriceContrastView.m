//
//  PriceContrastView.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "PriceContrastView.h"
#import "ASProgressPopUpView.h"


#define Contrast_RedColor GXRGBColor(216, 62, 33)
#define Contrast_GreenColor GXRGBColor(5, 156, 57)


@interface PriceContrastView ()

@property (nonatomic, weak) UILabel *makeLongValue;
@property (nonatomic, weak) UILabel *makeShortValue;
@property (nonatomic, strong) ASProgressPopUpView *leftprogressView;
@property (nonatomic, strong) ASProgressPopUpView *rightprogressView;



@end

@implementation PriceContrastView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}


- (void)config {
    
    self.backgroundColor = GXRGBColor(24, 24, 31);
    
    // 做多数值
    UILabel *makeLongValue = [[UILabel alloc] init];
    self.makeLongValue = makeLongValue;
    [self addSubview:makeLongValue];
    
    makeLongValue.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    makeLongValue.textColor = GXWhiteColor;
    makeLongValue.textAlignment = NSTextAlignmentLeft;
    
    [makeLongValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HeightScale_IOS6(15));
        make.left.mas_equalTo(WidthScale_IOS6(15));
    }];
    
    makeLongValue.text = @"50%";
    
    // 做多
    UILabel *makeLongLabel = [[UILabel alloc] init];
    [self addSubview:makeLongLabel];
    
    makeLongLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    makeLongLabel.textColor = Contrast_RedColor;
    makeLongLabel.textAlignment = NSTextAlignmentLeft;
    
    [makeLongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HeightScale_IOS6(15));
        make.left.mas_equalTo(makeLongValue.mas_right).offset(6);
    }];
    makeLongLabel.text = @"做多";
    
    
    
    
    // 做空数值
    UILabel *makeShortValue = [[UILabel alloc] init];
    self.makeShortValue = makeShortValue;
    [self addSubview:makeShortValue];
    
    makeShortValue.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    makeShortValue.textColor = GXWhiteColor;
    makeShortValue.textAlignment = NSTextAlignmentRight;
    
    [makeShortValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HeightScale_IOS6(15));
        make.right.mas_equalTo(WidthScale_IOS6(-15));
    }];
    
    makeShortValue.text = @"50%";
    
    // 做空
    UILabel *makeShortLable = [[UILabel alloc] init];
    [self addSubview:makeShortLable];
    
    makeShortLable.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    makeShortLable.textColor = Contrast_GreenColor;
    makeShortLable.textAlignment = NSTextAlignmentRight;
    
    [makeShortLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HeightScale_IOS6(15));
        make.right.mas_equalTo(makeShortValue.mas_left).offset(-6);
    }];
    makeShortLable.text = @"做空";
    
    
    
    // 做多做空视图
    ASProgressPopUpView *rightprogressView = [[ASProgressPopUpView alloc] init];
    self.rightprogressView = rightprogressView;
    [self addSubview:self.rightprogressView];
    
    [rightprogressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(1.5);
        make.height.mas_equalTo(5);
    }];
    
    self.rightprogressView.popUpViewAnimatedColors = @[Contrast_GreenColor, Contrast_GreenColor];
    self.rightprogressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:30];
    self.rightprogressView.type = ASProgressPopUpViewRight;
    self.rightprogressView.progress = 1;
    
    
    ASProgressPopUpView * leftprogressView= [[ASProgressPopUpView alloc] init];
    self.leftprogressView = leftprogressView;
    [self addSubview:self.leftprogressView];
    
    [leftprogressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-30);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(1.5);
        make.height.mas_equalTo(5);
    }];
    
    self.leftprogressView.popUpViewAnimatedColors = @[Contrast_RedColor, Contrast_RedColor];
    self.leftprogressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:30];
    self.leftprogressView.type = ASProgressPopUpViewLeft;
    self.leftprogressView.progress = 0.5;
    
    
    
    // 蓝色补充说明图
    UIButton *supplementButton = [[UIButton alloc] init];
    [self addSubview:supplementButton];
    
    [supplementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftprogressView.mas_centerY);
        make.left.mas_equalTo(leftprogressView.mas_right).offset(5);
        make.width.height.mas_equalTo(12);
    }];
    
    
    [supplementButton setImage:[UIImage imageNamed:@"upplement"] forState:UIControlStateNormal];
    [supplementButton addTarget:self action:@selector(showSupplementInfo) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)showSupplementInfo {
    if ([self.delegate respondsToSelector:@selector(priceConstrastClickOnSupplementBtn:)]) {
        [self.delegate priceConstrastClickOnSupplementBtn:self];
    }
}




- (void)setPriceLong:(float)valueLong shortValue:(float)shortValue {
    
    [self.leftprogressView setProgress:valueLong * 1.0f/(valueLong + shortValue) animated:YES];
    
    float longPersent = ( valueLong * 1.0f/(valueLong + shortValue) )* 100;
    //float shortPersent = ( (100 - valueLong) * 1.0f/(valueLong + shortValue) ) * 100;
    float shortPersent = (100 - longPersent);
    
    self.makeLongValue.text = [NSString stringWithFormat:@"%.0f%%",longPersent];
    self.makeShortValue.text = [NSString stringWithFormat:@"%.0f%%",shortPersent];
    

}



@end

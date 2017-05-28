//
//  PriceTabbar.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "PriceTabbar.h"

@interface PriceTabbar ()
@property (nonatomic, strong) UIButton *selectBtn;
@end


@implementation PriceTabbar {
    BOOL isSelected;
}



- (void)configTradebar {
    

    // 交易按钮
    UIButton *tradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tradeBtn.frame = CGRectMake(0, 0, WidthScale_IOS6(125), self.height);
    tradeBtn.backgroundColor = GXRGBColor(64, 130, 244);
    [tradeBtn setTitle:@"交易" forState:UIControlStateNormal];
    [tradeBtn setTitleColor:GXWhiteColor forState:UIControlStateNormal];
    tradeBtn.titleLabel.font = GXFONT_PingFangSC_Medium(17);
    tradeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [tradeBtn addTarget:self action:@selector(tradeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tradeBtn];
    
    
    
    CGFloat width = (self.width - tradeBtn.width)/3;
    CGFloat height = self.height;
    
    //规则
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn.frame = CGRectMake(CGRectGetMaxX(tradeBtn.frame), 0, width, height);
    [ruleBtn setTitleColor:GXRGBColor(184, 194, 199) forState:UIControlStateNormal];
    [ruleBtn setTitle:@"规则" forState:UIControlStateNormal];
    ruleBtn.titleLabel.font = GXFONT_PingFangSC_Regular(10);
    ruleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImage *image1 = IMAGE_NAMED(@"priceRule");
    [ruleBtn setImage:image1 forState:UIControlStateNormal];
    [ruleBtn setImagePosition:GXImagePositionTop spacing:0];
    [ruleBtn addTarget:self action:@selector(ruleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ruleBtn];
    
    
    // 提醒
    UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alertBtn.frame = CGRectMake(CGRectGetMaxX(ruleBtn.frame), 0, width, height);
    [alertBtn setTitleColor:GXRGBColor(184, 194, 199) forState:UIControlStateNormal];
    [alertBtn setTitle:@"提醒" forState:UIControlStateNormal];
    alertBtn.titleLabel.font = GXFONT_PingFangSC_Regular(10);
    alertBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    UIImage *image2 = IMAGE_NAMED(@"priceAlert");
    [alertBtn setImage:image2 forState:UIControlStateNormal];
    [alertBtn setImagePosition:GXImagePositionTop spacing:0];
    [alertBtn addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:alertBtn];
    
    //添加自选
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn = selectBtn;
    selectBtn.frame = CGRectMake(CGRectGetMaxX(alertBtn.frame), 0, width, height);
    [selectBtn setTitleColor:GXRGBColor(184, 194, 199) forState:UIControlStateNormal];
    selectBtn.titleLabel.font = GXFONT_PingFangSC_Regular(10);
    selectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
}


- (void)configNoTradebar {
    
    
    self.backgroundColor = GXRGBColor(38, 40, 52);
    
    // 提醒
    UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alertBtn.frame = CGRectMake(0, 0, self.width/2, self.height);
    [alertBtn setTitleColor:GXRGBColor(184, 194, 199) forState:UIControlStateNormal];
    [alertBtn setTitle:@"提醒" forState:UIControlStateNormal];
    alertBtn.titleLabel.font = GXFONT_PingFangSC_Regular(10);
    alertBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    UIImage *image2 = IMAGE_NAMED(@"priceAlert");
    [alertBtn setImage:image2 forState:UIControlStateNormal];
    [alertBtn setImagePosition:GXImagePositionTop spacing:0];
    [alertBtn addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:alertBtn];
    
    //添加自选
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn = selectBtn;
    selectBtn.frame = CGRectMake(self.width/2, 0, self.width/2, self.height);
    [selectBtn setTitleColor:GXRGBColor(184, 194, 199) forState:UIControlStateNormal];
    selectBtn.titleLabel.font = GXFONT_PingFangSC_Regular(10);
    selectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
}


- (void)cofigTabbar:(PriceMarketModel *)model {
    
    if (model.tradeDetail) {
        [self configTradebar];
    } else {
        [self configNoTradebar];
    }
}

- (void)setSelectBtnTitle:(PriceMarketModel *)model {
    
    
    NSArray *localar = [GXUserdefult objectForKey:PersonSelectCodesKey];
    
    if (localar.count == 0) {
        [self.selectBtn setTitle:@"请添加" forState:UIControlStateNormal];
        [self.selectBtn setImage:IMAGE_NAMED(@"priceAdd") forState:UIControlStateNormal];
        [self.selectBtn setImagePosition:GXImagePositionTop spacing:0];
        isSelected = NO;
        
    } else {
        
        for (NSString *codes in localar) {
            if([[codes lowercaseString] isEqualToString:[model.code lowercaseString]]) {
                [self.selectBtn setTitle:@"删除自选" forState:UIControlStateNormal];
                [self.selectBtn setImage:IMAGE_NAMED(@"priceNoAdd") forState:UIControlStateNormal];
                [self.selectBtn setImagePosition:GXImagePositionTop spacing:0];
                isSelected = YES;
                break;
            } else {
                [self.selectBtn setTitle:@"添加自选" forState:UIControlStateNormal];
                [self.selectBtn setImage:IMAGE_NAMED(@"priceAdd") forState:UIControlStateNormal];
                [self.selectBtn setImagePosition:GXImagePositionTop spacing:0];
                isSelected = NO;
            }
        }
        
    }
    

}

- (void)tradeClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(PriceTabbarClickOnTrade:)]) {
        [self.delegate PriceTabbarClickOnTrade:self];
    }
}

- (void)ruleClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(PriceTabbarClickOnCodeRule:)]) {
        [self.delegate PriceTabbarClickOnCodeRule:self];
    }
}
- (void)alertClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(PriceTabbarClickOnCodeRemind:)]) {
        [self.delegate PriceTabbarClickOnCodeRemind:self];
    }
}

- (void)selectClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(PriceTabbar:ClickOnSelectButton:isSelected:)]) {
        [self.delegate PriceTabbar:self ClickOnSelectButton:sender isSelected:isSelected];
    }
}


@end

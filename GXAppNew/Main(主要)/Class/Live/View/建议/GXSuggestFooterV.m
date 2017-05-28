//
//  GXSuggestFooterV.m
//  GXAppNew
//
//  Created by maliang on 2016/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSuggestFooterV.h"

@interface GXSuggestFooterV ()

@property (nonatomic, strong)UILabel *contentL;

@end

@implementation GXSuggestFooterV

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIView *footerBackView = [[UIView alloc]init];
    footerBackView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = GXRGBColor(237, 238, 245);
    footerBackView.layer.cornerRadius = WidthScale_IOS6(5);
    footerBackView.layer.masksToBounds = YES;
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"观点";
    titleL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    titleL.textColor = GXRGBColor(101, 106, 137);
    UILabel *contentL = [[UILabel alloc] init];
    contentL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    contentL.numberOfLines = 0;
    UIImageView *iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hint"]];
    UILabel *suggestL = [[UILabel alloc] init];
    suggestL.text = @"个人建议仅供参考，风险自担";
    suggestL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    suggestL.textColor = GXRGBColor(101, 106, 137);
    [self addSubview:footerBackView];
    [footerBackView addSubview:titleL];
    [footerBackView addSubview:contentL];
    [footerBackView addSubview:iconV];
    [footerBackView addSubview:suggestL];
    
    self.contentL = contentL;
    
    [footerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@-5);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@0);
    }];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerBackView.mas_left).offset(WidthScale_IOS6(15));
        make.top.mas_equalTo(@(HeightScale_IOS6(5)));
        make.width.mas_equalTo(@(WidthScale_IOS6(66)));
        make.height.mas_equalTo(@(HeightScale_IOS6(22)));
    }];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleL.mas_left);
        make.top.mas_equalTo(titleL.mas_bottom).offset(HeightScale_IOS6(1));
        make.right.mas_equalTo(@(WidthScale_IOS6(-5)));
    }];
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentL.mas_left);
        make.top.mas_equalTo(contentL.mas_bottom).offset(HeightScale_IOS6(12));
        make.width.height.mas_equalTo(@(WidthScale_IOS6(12)));
        make.bottom.mas_equalTo(@(WidthScale_IOS6(-10)));
    }];
    [suggestL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(iconV);
        make.left.mas_equalTo(iconV.mas_right).offset(WidthScale_IOS6(7));
    }];
}

- (void)setModel:(GXSuggestionModel *)model
{
    _model = model;
    self.contentL.attributedText = model.attriMForContent;
    self.contentL.textColor = GXRGBColor(101, 106, 137);
}

@end

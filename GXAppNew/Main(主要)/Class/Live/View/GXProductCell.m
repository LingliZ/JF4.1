//
//  GXProductCell.m
//  GXAppNew
//
//  Created by zhudong on 2017/1/12.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXProductCell.h"
#import "GXProductView.h"

@interface GXProductCell ()
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *sourceL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *percentL;
@end

@implementation GXProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UILabel *nameL = [[UILabel alloc] init];
    nameL.textColor = [UIColor whiteColor];
    nameL.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    
    UILabel *sourceL = [[UILabel alloc] init];
    sourceL.textColor = GXRGBColor(120, 126, 156);
    sourceL.font = GXFONT_PingFangSC_Regular(GXFitFontSize10);
    
    UILabel *priceL = [[UILabel alloc] init];
    priceL.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    priceL.textColor =  GXRGBColor(216, 62, 33);
    
    UILabel *percentL = [[UILabel alloc] init];
    percentL.textColor = [UIColor whiteColor];
    percentL.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    
    [self.contentView addSubview: nameL];
    [self.contentView addSubview: sourceL];
    [self.contentView addSubview: priceL];
    [self.contentView addSubview: percentL];
    self.nameL = nameL;
    self.sourceL = sourceL;
    self.priceL = priceL;
    self.percentL = percentL;

    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(2*GXMargin));
        make.left.equalTo(@(2*GXMargin));
    }];
    [sourceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameL);
        make.top.equalTo(nameL.mas_bottom).offset(GXMargin * 0.5);
        make.bottom.equalTo(@0);
    }];
    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@(GXMargin));
    }];
    [percentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceL);
        make.centerX.equalTo(self.contentView.mas_right).offset(-TopViewLeftOffset);
    }];
    
}

- (void)setModel:(PriceMarketModel  *)model{
    _model = model;
    self.nameL.text = model.name;
    self.sourceL.text = model.exname;
    self.priceL.text = model.last;
    self.priceL.textColor = model.lastColor;
    self.percentL.text = model.increasePercentage;
    self.percentL.textColor = model.lastColor;
}

@end

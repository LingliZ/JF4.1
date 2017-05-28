//
//  PriceCanlendarDataCell.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "PriceCanlendarDataCell.h"
#import "StarRateView.h"


@interface PriceCanlendarDataCell ()

@end

@implementation PriceCanlendarDataCell


- (void)awakeFromNib {
    [super awakeFromNib];
    

    self.bgView.backgroundColor = PriceVertiacl_CalandarCellColor;
    
    
    
    // 时间
    self.timeLabel.textColor = GXRGBColor(101, 106, 137);
    self.timeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    
    // name
    self.nameLabel.textColor = GXWhiteColor;
    self.nameLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = GXWhiteColor;
}




- (void)setModel:(PriceCalendarDataModel *)model {
    
    _model = model;
    
    self.timeLabel.text = model.time;
    self.nameLabel.text = model.name;
   
    self.frontValueLabel.text = (model.frontValue.length == 0) ? @"--" : model.frontValue;
    self.foreCastLabel.text = (model.forecast.length == 0) ? @"--" : model.forecast;
    self.resultLabel.text = [model.result isEqualToString:@"0"] ? @"0" : model.result;

    
    // 星星
    StarRateView *starRateView = [[StarRateView alloc] initWithFrame:CGRectMake(0, 0, WidthScale_IOS6(80), HeightScale_IOS6(10)) numberOfStars:5];
    self.starRateView = starRateView;
    starRateView.hasAnimation = YES;
    [self.bgView addSubview:starRateView];
    
    [starRateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(12);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(10);
    }];
    // 设置星星
    [self.starRateView setCurrent:[model.importance integerValue]];
    
    
    if (!model.res) {
        // 更新约束
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.bgView.mas_width).multipliedBy(0.9);
        }];
    }
   
    
    
    // 公布label
    UILabel *PublishLabel = [[UILabel alloc] init];
    [self.bgView addSubview:PublishLabel];
    [PublishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.starRateView.mas_centerY);
        make.left.mas_equalTo(self.starRateView.mas_right).offset(20);
        make.width.mas_equalTo(WidthScale_IOS6(40));
        make.height.mas_equalTo(HeightScale_IOS6(18));
    }];
    
    PublishLabel.textColor = GXWhiteColor;
    PublishLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize10);
    PublishLabel.textAlignment = NSTextAlignmentCenter;
    
    
    // rgb 55 54 72
    PublishLabel.backgroundColor = GXRGBColor(55, 54, 72);
    PublishLabel.text = [model.result isEqualToString:@"0"] ? @"未公布" : @"已公布";
    
    // 利空金银结果
    if (model.res && model.res.length != 0) {
        self.resLabel.hidden = NO;
        self.resLabel.text = model.res;
        
        if ([model.res rangeOfString:@"|"].location != NSNotFound) {
        
            NSArray *array = [model.res componentsSeparatedByString:@"|"];
            
            NSString *firstStr = array.firstObject;
            NSString *lastStr = array.lastObject;
            
            if (firstStr.length > 0) {
                // rgb 255 61 1
                self.resLabel.backgroundColor = GXRGBColor(255, 61, 1);
                self.resLabel.text = firstStr;
            } else {
                
                // 0 168 74
                self.resLabel.text = lastStr;
                self.resLabel.backgroundColor = GXRGBColor(0, 168, 74);
            }
            
        }
 
    }

}

@end

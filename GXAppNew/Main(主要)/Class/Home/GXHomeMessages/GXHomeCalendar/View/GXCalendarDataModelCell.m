//
//  GXCalendarDataModelCell.m
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCalendarDataModelCell.h"
#import "GXAdaptiveHeightTool.h"
#import "StarRateView.h"

@interface GXCalendarDataModelCell ()
@property (weak, nonatomic) IBOutlet UILabel *qianzhi;
@property (weak, nonatomic) IBOutlet UILabel *yuce;
@property (weak, nonatomic) IBOutlet UILabel *jieguo;
@property (nonatomic,strong)StarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *resLabel;

@end


@implementation GXCalendarDataModelCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(45, 47, 59));
    self.nameLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor],[UIColor whiteColor]);
    UIView *lineView = [[UIView alloc]init];
    lineView.dk_backgroundColorPicker = DKColorPickerWithColors(GXRGBColor(231, 235, 243),GXRGBColor(40, 40, 54));
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@-0.5);
        make.height.equalTo(@0.5);
    }];
}


-(void)setModel:(GXCalendarDataModel *)model{
    if (_model != model) {
        _model = model;
        
        self.timeLabel.text = self.model.time;
        self.nameLabel.text = self.model.name;
        // 利空金银结果
        self.resLabel.hidden = YES;
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
        if (self.model.frontValue.length <= 0 || [self.model.frontValue isEqualToString:@"待公布"]) {
            self.frontValueLabel.text = @"--";
        }else{
            self.frontValueLabel.text = self.model.frontValue;
        }
        if (self.model.forecast.length <= 0 || [self.model.forecast isEqualToString:@"待公布"]) {
            self.foreCastLabel.text = @"--";
        }else{
            self.foreCastLabel.text = self.model.forecast;
        }
        if ([self.model.result isEqualToString:@"待公布"] || self.model.result.length <= 0) {
            self.resultLabel.text = @"0";
        }else{
            self.resultLabel.text = self.model.result;
        }
        self.star1ImageView.image = [UIImage imageNamed:@"white_star"];
        self.star2ImageView.image = [UIImage imageNamed:@"white_star"];
        self.star3ImageView.image = [UIImage imageNamed:@"white_star"];
        self.star4ImageView.image = [UIImage imageNamed:@"white_star"];
        self.star5ImageView.image = [UIImage imageNamed:@"white_star"];

        if ([self.model.importance isEqualToString:@"1"]) {
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
        }else if ([self.model.importance isEqualToString:@"2"]){
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
            self.star2ImageView.image = [UIImage imageNamed:@"star"];
        }else if ([self.model.importance isEqualToString:@"3"]){
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
            self.star2ImageView.image = [UIImage imageNamed:@"star"];
            self.star3ImageView.image = [UIImage imageNamed:@"star"];
        }else if ([self.model.importance isEqualToString:@"4"]){
            self.star2ImageView.image = [UIImage imageNamed:@"star"];
            self.star3ImageView.image = [UIImage imageNamed:@"star"];
            self.star4ImageView.image = [UIImage imageNamed:@"star"];
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
        }else{
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
            self.star2ImageView.image = [UIImage imageNamed:@"star"];
            self.star3ImageView.image = [UIImage imageNamed:@"star"];
            self.star4ImageView.image = [UIImage imageNamed:@"star"];
            self.star5ImageView.image = [UIImage imageNamed:@"star"];
        }
    }
}


@end

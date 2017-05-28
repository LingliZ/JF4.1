//
//  GXCalendarEventModelCell.m
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCalendarEventModelCell.h"
#import "UIImageView+WebCache.h"
#import "GXAdaptiveHeightTool.h"
@implementation GXCalendarEventModelCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.gxBaseView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(45, 47, 59));
    self.eventLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor],[UIColor whiteColor]);
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
-(void)setModel:(GXCalendarEventModel *)model{
    if (_model != model) {
        _model = model;
        self.timeLabel.text = self.model.time;
        self.eventLabel.text =[NSString stringWithFormat:@"【事件】%@",self.model.event];
        self.countryLabel.text = self.model.country;
        self.areaLabel.text = self.model.area;
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
            self.star1ImageView.image = [UIImage imageNamed:@"star"];
            self.star2ImageView.image = [UIImage imageNamed:@"star"];
            self.star3ImageView.image = [UIImage imageNamed:@"star"];
            self.star4ImageView.image = [UIImage imageNamed:@"star"];
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

//
//  GXHomeTextCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeTextCell.h"

@implementation GXHomeTextCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithColors(GXHomeDKWhiteColor,GXHomeDKBlackColor);
    //标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    //来源
    self.sourceLabel = [[UILabel alloc]init];
    self.sourceLabel.layer.cornerRadius = 8;
    self.sourceLabel.layer.masksToBounds = YES;
    self.sourceLabel.layer.borderWidth = 1;
    self.sourceLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.sourceLabel.textAlignment = NSTextAlignmentCenter;
    self.sourceLabel.textColor = GXRGBColor(64, 130, 244);
    [self.contentView addSubview:self.sourceLabel];
    //阅读次数
    self.readCountLabel = [[UILabel alloc]init];
    self.readCountLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.readCountLabel.textColor = GXRGBColor(161, 166, 187);
    self.readCountLabel.textAlignment = NSTextAlignmentCenter;
    //[self.contentView addSubview:self.readCountLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = GXRGBColor(161, 166, 187);
    [self.contentView addSubview:self.timeLabel];
    
    //分割线
    UIView *lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.dk_backgroundColorPicker = DKColorPickerWithColors( UIColorFromRGB(0xeeeeee),GXRGBColor(40, 40, 54));
    self.titleLabel.dk_textColorPicker=DKColorPickerWithColors(GXRGBColor(18, 29, 61),RGBACOLOR(231, 231, 231, 1));
    self.readCountLabel.dk_textColorPicker=DKColorPickerWithColors(RGBACOLOR(143, 150, 188, 1),GXRGBColor(101, 106, 137));
    self.timeLabel.dk_textColorPicker=DKColorPickerWithColors(RGBACOLOR(143, 150, 188, 1),GXRGBColor(101, 106, 137));
    self.sourceLabel.dk_textColorPicker=DKColorPickerWithColors(RGBACOLOR(143, 150, 188, 1),GXRGBColor(101, 106, 137));
    self.sourceLabel.layer.dk_borderColorPicker = DKColorPickerWithColors(RGBACOLOR(143, 150, 188, 1),GXRGBColor(101, 106, 137));
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.right.equalTo(@-15);
    }];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@17);
        make.bottom.equalTo(@-10);
    }];

    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.top.equalTo(self.sourceLabel);
        make.height.equalTo(self.sourceLabel);
        make.bottom.equalTo(self.sourceLabel);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@-0.5);
    }];
}
-(void)layoutSubviews{
    [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.width.equalTo(@(self.model.sourceWidth + 10));
        make.height.equalTo(@17);
        make.bottom.equalTo(@-10);
    }];
}
-(void)setModel:(GXHomeTextModel *)model{
    _model = model;
    //赋值
    self.titleLabel.text = self.model.title;
    self.sourceLabel.text = self.model.tagName;
    self.readCountLabel.text = @"4w次阅读";
    NSString *timeStr;
    NSDate *date = [GXAdaptiveHeightTool dateFromStringWithDateStyle:@"yyyy-MM-dd HH:mm:SS" withDateString:self.model.created];
    NSString *dateStr = [GXAdaptiveHeightTool compareTodayOrYestodayOrTomorrowDate:date];
    if ([dateStr isEqualToString:@"今天"]) {
        timeStr = [GXAdaptiveHeightTool compareCurrentTime:date];
    }else if ([dateStr isEqualToString:@"昨天"]){
        timeStr = [NSString stringWithFormat:@"昨天%@",[GXAdaptiveHeightTool getDateStyle:@"HH:mm" withDate:self.model.created]];
    }else{
        NSString *timeStr1 = [GXAdaptiveHeightTool getDateStyle:@"MM-dd HH:mm:ss" withDate:self.model.created];
        timeStr = timeStr1;
    }
    self.timeLabel.text = timeStr;
}

@end

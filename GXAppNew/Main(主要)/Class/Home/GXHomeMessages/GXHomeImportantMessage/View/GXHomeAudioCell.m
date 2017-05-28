//
//  GXHomeAudioCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/11.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeAudioCell.h"
#import "GXAudioManager.h"

@interface GXHomeAudioCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *sourceLabel;
@property (strong, nonatomic) UILabel *playCountLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIImageView *userImgView;
@property (strong, nonatomic) UIView *audioView;
@end

@implementation GXHomeAudioCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithColors(GXHomeDKWhiteColor,GXHomeDKBlackColor);
    //分割线
    UIView *lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
   
    //标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    //音频View
    self.audioView = [[UIView alloc]init];
    self.audioView.backgroundColor = GXRGBColor(88, 118, 189);
    self.audioView.layer.cornerRadius = 10;
    self.audioView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.audioView];

    //头像
    self.userImgView = [[UIImageView alloc]init];
    self.userImgView.layer.cornerRadius = HeightScale_IOS6(44) / 2;
    self.userImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.userImgView];
    [self.contentView bringSubviewToFront:self.userImgView];

    //来源
    self.sourceLabel = [[UILabel alloc]init];
    self.sourceLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.sourceLabel.textAlignment = NSTextAlignmentCenter;
    self.sourceLabel.textColor = GXRGBColor(64, 130, 244);
    self.sourceLabel.layer.cornerRadius = 8;
    self.sourceLabel.layer.masksToBounds = YES;
    self.sourceLabel.layer.borderWidth = 1;
    self.sourceLabel.layer.borderColor =GXRGBColor(161, 166, 187).CGColor;
    [self.contentView addSubview:self.sourceLabel];
    //播放次数
    self.playCountLabel = [[UILabel alloc]init];
    self.playCountLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.playCountLabel.textColor = GXRGBColor(161, 166, 187);
    self.playCountLabel.textAlignment = NSTextAlignmentCenter;
    //[self.contentView addSubview:self.playCountLabel];
    //创建时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = GXRGBColor(161, 166, 187);
    [self.contentView addSubview:self.timeLabel];
    //音频View上控件
    //滑竿
    self.audioSlider = [[UISlider alloc]init];
    [self.audioSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [self.audioSlider setMaximumTrackTintColor:GXRGBColor(181, 181, 181)];
    
    UIImage *thumbImg = [UIImage imageNamed:@"home_slider_pic"];
    [self.audioSlider setThumbImage:thumbImg forState:UIControlStateNormal];
    self.audioSlider.userInteractionEnabled = false;
    [self.audioView addSubview:self.audioSlider];
    //当前时间
    self.audioCurrentTimeLabel = [[UILabel alloc]init];
    self.audioCurrentTimeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.audioCurrentTimeLabel.textColor = GXRGBColor(161, 166, 187);
    [self.audioView addSubview:self.audioCurrentTimeLabel];
    //总时间
    self.audioTotalTimeLabel = [[UILabel alloc]init];
    self.audioTotalTimeLabel.textAlignment = NSTextAlignmentRight;
    self.audioTotalTimeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.audioTotalTimeLabel.textColor = GXRGBColor(161, 166, 187);
    [self.audioView addSubview:self.audioTotalTimeLabel];
    //播放按钮
    self.audioPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.audioPlayBtn setImage:[UIImage imageNamed:@"home_audio_play_pic"] forState:UIControlStateNormal];
    [self.audioView addSubview:self.audioPlayBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.equalTo(@10);
    }];
    [self.userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.equalTo(@(HeightScale_IOS6(44)));
        make.height.equalTo(@(HeightScale_IOS6(44)));
    }];
    [self.audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@37);
        make.centerY.equalTo(self.userImgView);
        make.right.equalTo(@-15);
        make.height.equalTo(@(HeightScale_IOS6(56)));
    }];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.audioView.mas_bottom).offset(5);
        make.height.equalTo(@17);
        make.bottom.equalTo(@(-10));
    }];
//    [self.playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.sourceLabel.mas_right).offset(30);
//        make.width.equalTo(@70);
//        make.height.equalTo(self.sourceLabel);
//        make.top.equalTo(self.sourceLabel);
//        make.bottom.equalTo(self.sourceLabel);
//    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.top.equalTo(self.sourceLabel);
        make.height.equalTo(self.sourceLabel);
        make.bottom.equalTo(self.sourceLabel);
    }];
    [self.audioSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImgView.mas_right).offset(WidthScale_IOS6(20));
        make.top.equalTo(self.audioView.mas_top).offset(HeightScale_IOS6(23));
        make.bottom.equalTo(self.audioView.mas_bottom).offset(-HeightScale_IOS6(23));
        make.right.equalTo(self.audioPlayBtn.mas_left).offset(-10);
    }];
    [self.audioCurrentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.audioSlider);
        make.top.equalTo(self.audioSlider.mas_top).offset(10);
        make.height.equalTo(@13);
        make.width.equalTo(@50);
        make.bottom.equalTo(self.audioView.mas_bottom).offset(0);
    }];
    [self.audioTotalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.audioPlayBtn.mas_left).offset(-10);
        make.top.equalTo(self.audioCurrentTimeLabel);
        make.height.equalTo(self.audioCurrentTimeLabel);
        make.width.equalTo(self.audioCurrentTimeLabel);
        make.bottom.equalTo(self.audioCurrentTimeLabel);
    }];
    [self.audioPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioView.mas_top).offset(HeightScale_IOS6(13));
        make.right.equalTo(self.audioView.mas_right).offset(-25);
        make.width.equalTo(@(WidthScale_IOS6(30)));
        make.height.equalTo(@(WidthScale_IOS6(30)));
        make.bottom.equalTo(self.audioView.mas_bottom).offset(-HeightScale_IOS6(13));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@-0.5);
    }];

    self.titleLabel.dk_textColorPicker=DKColorPickerWithColors(GXRGBColor(18, 29, 61),RGBACOLOR(231, 231, 231, 1));
    self.playCountLabel.dk_textColorPicker=DKColorPickerWithColors(RGBACOLOR(143, 150, 188, 1),GXRGBColor(101, 106, 137));
    self.timeLabel.dk_textColorPicker=DKColorPickerWithColors(RGBACOLOR(143, 150, 188, 1),GXRGBColor(101, 106, 137));
    lineView.dk_backgroundColorPicker = DKColorPickerWithColors( UIColorFromRGB(0xeeeeee),GXRGBColor(40, 40, 54));
    self.sourceLabel.dk_textColorPicker=DKColorPickerWithColors(RGBACOLOR(143, 150, 188, 1),GXRGBColor(101, 106, 137));
    self.sourceLabel.layer.dk_borderColorPicker = DKColorPickerWithColors(RGBACOLOR(143, 150, 188, 1),GXRGBColor(101, 106, 137));
//    self.contentView.backgroundColor = GXRGBColor(34, 35, 45);
}
-(void)layoutSubviews{
    [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.audioView.mas_bottom).offset(5);
        make.width.equalTo(@(self.model.sourceWidth + 10));
        make.height.equalTo(@17);
        make.bottom.equalTo(@(-10));
    }];
}

-(void)setModel:(GXHomeAudioModel *)model{
    if (_model != model) {
        _model = model;

        self.titleLabel.text = self.model.title;
        [self.userImgView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl] placeholderImage:[UIImage imageNamed:@"analyst_1"]];
        self.sourceLabel.text = self.model.tagName;
        self.playCountLabel.text = @"398次播放";
        self.audioCurrentTimeLabel.text = @"00:00";
        self.audioTotalTimeLabel.text = model.totalTimeStr;
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
}
@end

//
//  GXHomeVedioCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeVedioCell.h"

@interface GXHomeVedioCell ()


@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic)  UILabel *sourceLabel;
@property (strong, nonatomic)  UILabel *playCountLabel;
@property (strong, nonatomic)  UILabel *timeLabel;

@property (nonatomic, strong)  UIImageView *vedioImageView;

@end


@implementation GXHomeVedioCell

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

    //视频View
    self.vedioView = [[UIView alloc]init];
    self.vedioView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.vedioView];
    
    //标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = GXFONT_PingFangSC_Medium(GXFitFontSize14);
    [self.contentView addSubview:self.titleLabel];
    
    //内容
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.contentLabel.textColor = GXRGBColor(118, 124, 154);
    [self.contentView addSubview:self.contentLabel];
    
    //来源
    self.sourceLabel = [[UILabel alloc]init];
    self.sourceLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.sourceLabel.textAlignment = NSTextAlignmentCenter;
    self.sourceLabel.textColor = GXRGBColor(64, 130, 244);
    self.sourceLabel.layer.cornerRadius = 8;
    self.sourceLabel.layer.masksToBounds = YES;
    self.sourceLabel.layer.borderWidth = 1;
    self.sourceLabel.layer.borderColor = GXRGBColor(161, 166, 187).CGColor;
    [self.contentView addSubview:self.sourceLabel];
    
    //播放次数
    self.playCountLabel = [[UILabel alloc]init];
    self.playCountLabel.text = @"398次播放";
    self.playCountLabel.textAlignment = NSTextAlignmentCenter;
    self.playCountLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.playCountLabel.textColor = GXRGBColor(161, 166, 187);
    //[self.contentView addSubview:self.playCountLabel];
    
    //发布时间
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.timeLabel.textColor = GXRGBColor(161, 166, 187);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    
    //图片
    self.vedioImageView = [[UIImageView alloc]init];
    self.vedioImageView.image = [UIImage imageNamed:@"vedio_logo"];
    [self.vedioView addSubview:self.vedioImageView];
    
    
    //按钮
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"home_msg_video_play_pic"] forState:UIControlStateNormal];
    [self.vedioView addSubview:self.playBtn];
    
    [self.vedioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@((GXScreenWidth - 30) * 0.5));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(self.vedioView);
        make.top.equalTo(self.vedioView.mas_bottom).offset(5);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.height.equalTo(@17);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
//    [self.playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.sourceLabel.mas_right).offset(30);
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
//        make.width.equalTo(@70);
//        make.height.equalTo(@17);
//        make.bottom.equalTo(self.sourceLabel);
//    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.height.equalTo(@17);
        make.bottom.equalTo(self.sourceLabel);
    }];
    
    [self.vedioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vedioView.mas_top).offset(0);
        make.left.equalTo(self.vedioView.mas_left).offset(0);
        make.right.equalTo(self.vedioView.mas_right).offset(0);
        make.bottom.equalTo(self.vedioView.mas_bottom).offset(0);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vedioView.mas_top).offset((((GXScreenWidth - 30) * 0.5) - 80) * 0.5);
        make.centerX.equalTo(self.vedioView);
        make.height.equalTo(@80);
        make.width.equalTo(@80);
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
}
-(void)layoutSubviews{
    [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.width.equalTo(@(self.model.sourceWidth + 10));
        make.height.equalTo(@17);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

-(void)setModel:(GXHomeVedioModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.metadesc;
    self.sourceLabel.text = model.tagName;
    [self.vedioImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl] placeholderImage:[UIImage imageNamed:@"vedio_logo"]];
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

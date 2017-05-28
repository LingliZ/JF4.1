//
//  GXVideoCell.m
//  GXAppNew
//
//  Created by maliang on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXVideoCell.h"
#import "GXLiveBtn.h"

@interface GXVideoCell ()

@property (nonatomic, strong) UIImageView *headV;
@property (nonatomic, strong) GXLiveBtn *stateBtn;
@property (nonatomic, strong) UILabel *describeL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *introduceL;
//@property (nonatomic, strong) UILabel *sloganL;

@end

@implementation GXVideoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:bgView];
    UIImageView *headV = [[UIImageView alloc] init];
    [bgView addSubview:headV];
    
    GXLiveBtn *stateBtn = [[GXLiveBtn alloc] initWithFrame:CGRectMake(0, 0, 80, 23)];
    stateBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    stateBtn.layer.cornerRadius = 5;
    stateBtn.layer.masksToBounds = YES;
    [bgView addSubview:stateBtn];
    
    UILabel *describeL = [[UILabel alloc] init];
    describeL.font = GXFONT_PingFangSC_Medium(GXFitFontSize16);
    describeL.textColor = GXRGBColor(18, 29, 61);
    [self.contentView addSubview:describeL];
    
    UILabel *timeL = [[UILabel alloc] init];
    timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    timeL.textColor = GXRGBColor(18, 29, 61);
    [self.contentView addSubview:timeL];
    
    UILabel *introduceL = [[UILabel alloc] init];
    introduceL.font = GXFONT_PingFangSC_Light(GXFitFontSize12);
    introduceL.textColor = GXRGBColor(101, 106, 137);
    [self.contentView addSubview:introduceL];
    
//    UILabel *sloganL = [[UILabel alloc] init];
//    sloganL.numberOfLines = 0;
//    sloganL.font = GXFONT_PingFangSC_Regular(GXFitFontSize16);
//    sloganL.textColor = GXRGBColor(18, 29, 61);
//    [self.contentView addSubview:sloganL];
    
    self.headV = headV;
    self.stateBtn = stateBtn;
    self.describeL = describeL;
    self.timeL = timeL;
    self.introduceL = introduceL;
//    self.sloganL = sloganL;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(WidthScale_IOS6(15)));
        make.left.mas_equalTo(@(1.5 * GXMargin));
        make.right.bottom.mas_equalTo(self.contentView).offset(WidthScale_IOS6(-15));
    }];
    
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top);
        make.left.mas_equalTo(bgView.mas_left);
        make.right.mas_equalTo(bgView.mas_right);
        make.bottom.mas_equalTo(bgView.mas_bottom).offset(-WidthScale_IOS6(60));
        
    }];

    [stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@(-WidthScale_IOS6(10)));
        make.top.mas_equalTo(@(WidthScale_IOS6(10)));
        make.height.equalTo(@(WidthScale_IOS6(23)));
    }];
    [describeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headV.mas_left).mas_offset(WidthScale_IOS6(10));
        make.top.mas_equalTo(headV.mas_bottom).mas_offset(WidthScale_IOS6(13));
        make.height.mas_equalTo(@(WidthScale_IOS6(16)));
        
    }];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(describeL);
        make.right.mas_equalTo(headV.mas_right).offset(WidthScale_IOS6(-10));
    }];
    
    [introduceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.describeL);
        make.right.mas_equalTo(@(WidthScale_IOS6(-5)));
        make.top.mas_equalTo(self.describeL.mas_bottom).mas_offset(HeightScale_IOS6(5));
    }];
    
//    [sloganL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(headV.mas_left).mas_offset(WidthScale_IOS6(10));
//        make.top.mas_equalTo(headV.mas_bottom).mas_offset(WidthScale_IOS6(13));
//        make.height.mas_equalTo(@(WidthScale_IOS6(16)));
//    }];
    
}

- (void)setModel:(GXVideoModel *)model
{
    _model = model;
    self.introduceL.text = model.intro;
    [self.headV sd_setImageWithURL:[NSURL URLWithString:model.imageUrlApp] placeholderImage:[UIImage imageNamed:@"live_backView_placeHolder"]];
    if (model.currentCourse == nil) {
        [self.stateBtn setImage:[UIImage imageNamed:@"rest"] forState:UIControlStateNormal];
        self.describeL.text = model.slogan;
    } else {
        self.timeL.text = model.timeStr;
        
        if (model.isPlaying) {
            [self.stateBtn setImage:[UIImage imageNamed:@"living"] forState:UIControlStateNormal];
            self.describeL.text = [NSString stringWithFormat:@"正在直播:%@",model.nameStr];
        } else {
            [self.stateBtn setImage:[UIImage imageNamed:@"immediately"] forState:UIControlStateNormal];
            self.describeL.text = [NSString stringWithFormat:@"即将播出:%@",model.nameStr];
        }
    }
}

@end


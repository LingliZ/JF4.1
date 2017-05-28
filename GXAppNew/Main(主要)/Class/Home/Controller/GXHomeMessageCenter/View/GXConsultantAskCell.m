//
//  GXAskCell.m
//  GXApp
//
//  Created by zhudong on 16/8/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXConsultantAskCell.h"
#import "NSDateFormatter+GXDateFormatter.h"
#import "NSString+GXEmotAttributedString.h"
#import <YYText/YYText.h>
#import "UIColor+Add.h"
#define iconWidth 50
#define kMargin WidthScale_IOS6(10)

@interface GXConsultantAskCell ()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) YYLabel *contentLabel;
@property (nonatomic,strong) MASConstraint *leftCons;
@end
@implementation GXConsultantAskCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.contentView.backgroundColor = GXRGBColor(237, 237, 243);
    }
    return self;
}
- (void)setupUI{
    //1创建控件
    UIView *whiteView1 = [[UIView alloc]init];
    UIView *whiteView2 = [[UIView alloc]init];
    whiteView1.backgroundColor = [UIColor whiteColor];
    whiteView2.backgroundColor = [UIColor whiteColor];
    UIView *backGroundView = [[UIView alloc]init];
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = RGBACOLOR(244, 244, 244, 6.4);
    backGroundView.layer.cornerRadius = 5;
    backGroundView.layer.masksToBounds = YES;
    backGroundView.backgroundColor = [UIColor whiteColor];
    self.iconView = [[UIImageView alloc]init];
    self.iconView.layer.cornerRadius = 15;
    self.iconView.layer.masksToBounds = YES;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    nameLabel.textColor = GXRGBColor(64, 130, 244);
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    timeLabel.textColor = [UIColor grayColor];
//    timeLabel.backgroundColor = [UIColor redColor];
    YYLabel *contentLabel = [[YYLabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.preferredMaxLayoutWidth = WidthScale_IOS6(235);
    contentLabel.textColor = GXRGBColor(101, 106, 137);
    self.nameLabel = nameLabel;
    self.timeLabel = timeLabel;
    self.contentLabel = contentLabel;
    [self.contentView addSubview:backGroundView];
    [backGroundView addSubview:backView];
    [backGroundView addSubview:self.iconView];
    [backView addSubview:nameLabel];
    [backView addSubview:timeLabel];
    [backView addSubview:contentLabel];
    [backGroundView addSubview:whiteView1];
    [backGroundView addSubview:whiteView2];
    [backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@0);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@0);
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.top.equalTo(@10);
        make.width.height.equalTo(@30);
    }];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(0);
        make.top.equalTo(@0);
        make.right.equalTo(@-10);
        make.bottom.equalTo(@-10);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(kMargin);
        make.top.equalTo(backView.mas_top).offset(10);
        make.width.equalTo(@100);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.leftCons = make.right.equalTo(backView.mas_right).offset(-kMargin);
        make.centerY.equalTo(self.nameLabel);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(kMargin);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(kMargin);
        make.right.equalTo(backView).offset(-kMargin);
        make.bottom.equalTo(backView).offset(-kMargin);
    }];
    [whiteView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundView.mas_left).offset(0);
        make.top.equalTo(backGroundView.mas_top).offset(-5);
        make.width.equalTo(@5);
        make.height.equalTo(@10);
    }];
    [whiteView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backGroundView.mas_right).offset(0);
        make.top.equalTo(backGroundView.mas_top).offset(-5);
        make.width.equalTo(@5);
        make.height.equalTo(@10);
    }];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(kMargin * 2);
//        make.right.equalTo(self).offset(-kMargin * 2);
//        make.top.bottom.equalTo(self);
//    }];
}
- (void)setConsultantReplyModel:(GXConsultantReplyModel *)consultantReplyModel{
    _consultantReplyModel = consultantReplyModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:consultantReplyModel.AskerPic] placeholderImage:[UIImage imageNamed:@"placeHolder_pic"]];
    self.nameLabel.text = consultantReplyModel.NickName;
    NSDateFormatter *formatter = [NSDateFormatter shareFormatter];
    /*
     yyyy-MM-dd HH:mm:ss.SSS
     */
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:consultantReplyModel.CreatedTime];
    formatter.dateFormat = @"yyyy.MM.dd  HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeLabel.text = dateStr;
    if (consultantReplyModel.AskerList.count == 0) {
        self.contentLabel.attributedText = [NSString dealContentText:consultantReplyModel.Question];
    }else{
        self.contentLabel.attributedText = [NSString dealContentText:consultantReplyModel.AskerList[self.tag + 1]];
    }
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    
//    if (consultantReplyModel.isRead) {
//        [self setContentColor:[UIColor lightGrayColor]];
//    }else{
//        [self setContentColor:[UIColor blackColor]];
//    }
}
- (void)setContentColor:(UIColor *)color{
    self.contentLabel.textColor = color;
    self.nameLabel.textColor = color;
}

@end

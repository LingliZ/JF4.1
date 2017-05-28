//
//  GXConsultantReplyCell.m
//  GXApp
//
//  Created by zhudong on 16/7/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXConsultantReplyCell.h"
#import "NSDateFormatter+GXDateFormatter.h"
#import "NSString+GXEmotAttributedString.h"
#import <YYText/YYText.h>
//#import "GXPicturesView.h"
#import "GXMsgPicturesView.h"
#define iconWidth 40
#define kMargin WidthScale_IOS6(10)
#define seperatorColor [UIColor colorWithRed:200 / 250.0 green:200 / 250.0 blue:200 / 250.0 alpha:0.6]

@interface GXConsultantReplyCell ()
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
//@property (nonatomic,strong) YYLabel *contentLabel;
@property (nonatomic,strong) GXMsgPicturesView *picturesView;
@property (nonatomic,strong) MASConstraint *bottomConstraint;
@end
@implementation GXConsultantReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.contentView.backgroundColor =  GXRGBColor(237, 237, 243);
    }
    return self;
}
- (void)setupUI{
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    UIView *whiteView1 = [[UIView alloc]init];
    UIView *whiteView2 = [[UIView alloc]init];
    whiteView1.backgroundColor = [UIColor whiteColor];
    whiteView2.backgroundColor = [UIColor whiteColor];
    //1创建控件
    UIImageView *iconV = [[UIImageView alloc] init];
    iconV.contentMode = UIViewContentModeScaleAspectFill;
    iconV.layer.cornerRadius = iconWidth / 2;
    iconV.layer.masksToBounds = YES;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = GXRGBColor(64, 130, 244);
    nameLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    timeLabel.textColor = GXRGBColor(161, 166, 187);
//    self.contentLabel = [[YYLabel alloc] init];
    self.contentLabel.preferredMaxLayoutWidth = WidthScale_IOS6(275);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = GXRGBColor(101, 106, 137);
    //控件和属性关联,将控件变为全局变量,可以在setModel方法中对控件设置内容
    self.iconView = iconV;
    self.nameLabel = nameLabel;
    self.timeLabel = timeLabel;
//    self.contentLabel = contentLabel;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(PictureWidth, PictureWidth);
    flowLayout.minimumLineSpacing = kMargin;
    flowLayout.minimumInteritemSpacing = kMargin;
    self.picturesView = [[GXMsgPicturesView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.picturesView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:backView];
    [backView addSubview:self.picturesView];
    //2添加控件,控件要添加的cell的contentView属性内,要不然会造成摸不清的错误
    [backView addSubview:iconV];
    [backView addSubview:nameLabel];
    [backView addSubview:timeLabel];
    [backView addSubview:self.contentLabel];
    [self.contentView addSubview:whiteView1];
    [self.contentView addSubview:whiteView2];
    //3设置约束,每个控件设置约束的方式类似xib中的AutoLayout(有疑问的可以参考简书:http://www.jianshu.com/p/23919e649084);
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@0);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView).offset(kMargin);
        make.width.height.equalTo(@iconWidth);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).offset(kMargin);
        make.width.equalTo(@100);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-20);
        make.centerY.equalTo(self.nameLabel);
//        make.top.equalTo(self.nameLabel);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kMargin);
        make.right.equalTo(backView).offset(-kMargin);
        //设置iconView底部相对cell的contentView底部偏移量大于等于(-kMargin)
        self.bottomConstraint = make.bottom.equalTo(backView).offset(-kMargin);
    }];
    [whiteView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(5);
        make.width.equalTo(@5);
        make.height.equalTo(@10);
    }];
    [whiteView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(0);
        make.bottom.equalTo(backView.mas_bottom).offset(5);
        make.width.equalTo(@5);
        make.height.equalTo(@10);
    }];


    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)setConsultantReplyModel:(GXConsultantReplyModel *)consultantReplyModel{
    _consultantReplyModel = consultantReplyModel;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:consultantReplyModel.AnswerPic] placeholderImage:[UIImage imageNamed:@"placeHolder_pic"]];
    NSMutableAttributedString *mAS = [[NSMutableAttributedString alloc] initWithString:consultantReplyModel.AnswerName attributes:@{NSForegroundColorAttributeName : GXRGBColor(64, 130, 244), NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14)}];
    NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:@"回复" attributes:@{NSForegroundColorAttributeName : GXRGBColor(161, 166, 187), NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14)}];
    [mAS appendAttributedString:attrS];
    self.nameLabel.attributedText = mAS;
    NSDateFormatter *formatter = [NSDateFormatter shareFormatter];
    /*
        yyyy-MM-dd HH:mm:ss.SSS
     */
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:consultantReplyModel.AnswerTime];
    formatter.dateFormat = @"yyyy.MM.dd  HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeLabel.text = dateStr;
    NSString *replyStr = [NSString stringWithFormat:@"%@",consultantReplyModel.Answer];
    self.contentLabel.attributedText = [NSString dealContentText:replyStr];
    self.contentLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    if (consultantReplyModel.Imgs.count > 0) {
        [self.bottomConstraint uninstall];
        self.picturesView.hidden = NO;
        CGSize picturesViewSize = [self getSize:consultantReplyModel.Imgs.count];
        [self.picturesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(kMargin);
            make.left.equalTo(self.contentLabel);
            make.height.equalTo(@(picturesViewSize.height));
            make.width.equalTo(@(picturesViewSize.width));
        }];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomConstraint =  make.bottom.equalTo(self.picturesView.mas_bottom).offset(kMargin);
        }];
        self.picturesView.Imgs = consultantReplyModel.Imgs;
    }
    else{
        [self.bottomConstraint uninstall];
        self.picturesView.hidden = YES;
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomConstraint = make.bottom.equalTo(self.contentLabel.mas_bottom).offset(kMargin);
        }];
        self.picturesView.Imgs = nil;
    }
//    GXLog(@"*****%@",NSStringFromCGRect(self.iconView.frame));
//    GXLog(@"+++++%@",NSStringFromCGRect(self.contentLabel.frame));
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
- (CGSize)getSize:(NSUInteger)count{
    CGSize size;
    if (count <= 3) {
      return size = CGSizeMake(PictureWidth * 3 + 2 * kMargin, PictureWidth);
    }
    if (count == 4) {
      return  size = CGSizeMake(PictureWidth * 2 + kMargin,PictureWidth * 2 + kMargin);
    }
    if (count == 5 || count == 6) {
      return size = CGSizeMake(PictureWidth * 3 + 2 * kMargin, PictureWidth * 2 + kMargin);
    }
    return size = CGSizeMake(PictureWidth * 3 + 2 * kMargin, PictureWidth * 3 + 2 * kMargin);
}
@end

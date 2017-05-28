//
//  GXQuestionCell.m
//  GXAppNew
//
//  Created by zhudong on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXQuestionCell.h"
#import "NSString+GXEmotAttributedString.h"

#define IconViewHeight 32

@interface GXQuestionCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) YYLabel *contentLable;
@end

@implementation GXQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = GXRGBColor(59, 62, 76);
    
    UIView *bgV = [[UIView alloc] init];
    bgV.backgroundColor = UIColorFromRGB(0x272933);
    bgV.layer.cornerRadius = 15;
    bgV.layer.masksToBounds = true;
    [self.contentView addSubview:bgV];
    
    YYLabel *nameL = [[YYLabel alloc] init];
    nameL.text = @"心脏病";
    nameL.textColor = GXRGBColor(64, 130, 244);
    nameL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    [self.contentView addSubview:nameL];
    self.nameLable = nameL;
    
    YYLabel *contentL = [[YYLabel alloc] init];
    contentL.textColor = [UIColor whiteColor];
    contentL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    contentL.numberOfLines = 0;
    contentL.preferredMaxLayoutWidth = WidthScale_IOS6(300);
    [self.contentView addSubview:contentL];
    self.contentLable = contentL;
    
    UIImageView *iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0"]];
    iconV.layer.cornerRadius = IconViewHeight / 2;
    iconV.layer.masksToBounds = true;
    [self.contentView addSubview:iconV];
    self.iconView = iconV;
    
    UILabel *timeL = [[UILabel alloc] init];
    timeL.textColor = GXRGBColor(127, 137, 162);
    timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize10);
    [self.contentView addSubview:timeL];
    self.timeLable = timeL;
    
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(1.5 * GXMargin);
        make.top.equalTo(self.contentView).offset(1.5 * GXMargin);
        make.width.height.equalTo(@IconViewHeight);
    }];
    
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.top.equalTo(self.contentView).offset(0.5 * GXMargin);
        make.bottom.equalTo(self.contentView);
        make.right.greaterThanOrEqualTo(self.contentLable.mas_right).offset(GXMargin);
        make.right.greaterThanOrEqualTo(self.timeLable.mas_right).offset(GXMargin);
    }];
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(1.5 * GXMargin);
        make.left.equalTo(iconV.mas_right).offset(GXMargin);
        make.width.lessThanOrEqualTo(@(GXScreenWidth - 1.5*IconViewHeight - 4 * GXMargin));
    }];
    
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameL.mas_right).offset(GXMargin);
        make.centerY.equalTo(nameL);
    }];
    
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameL);
        make.top.equalTo(nameL.mas_bottom);
        make.bottom.equalTo(self.contentView).offset(-0.5*GXMargin);
    }];
}

- (void)setQuestionModel:(GXQuestion *)questionModel{
    _questionModel = questionModel;
    
    if (questionModel.replyNickName.length > 0) {
        NSMutableAttributedString *mutAtt = [[NSMutableAttributedString alloc] initWithString:questionModel.nickName attributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(GXFitFontSize12), NSForegroundColorAttributeName:GXRGBColor(64, 130, 244)}];
        NSAttributedString *replyAttr = [[NSAttributedString alloc] initWithString:@"回复" attributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(GXFitFontSize12), NSForegroundColorAttributeName:GXRGBColor(127, 137, 162)}];
        NSAttributedString *replyNameAttr = [[NSAttributedString alloc] initWithString:questionModel.replyNickName attributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(GXFitFontSize12), NSForegroundColorAttributeName:GXRGBColor(64, 130, 244)}];
        
        [mutAtt appendAttributedString:replyAttr];
        [mutAtt appendAttributedString:replyNameAttr];
        self.nameLable.attributedText = mutAtt;
    }else {
        self.nameLable.text = questionModel.nickName;
    }
    self.timeLable.text = questionModel.questionTimeStr;
    self.contentLable.attributedText = [NSString dealContentText:questionModel.content];
    self.contentLable.textColor = [UIColor whiteColor];
    self.contentLable.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:questionModel.userPic] placeholderImage:[UIImage imageNamed:@"mine_head_placeholder"]];
}
@end

//
//  GXExchangeCell.m
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXExchangeCell.h"
#import "NSString+GXEmotAttributedString.h"
#import "GXLiveTimeTool.h"
#import "RegexKitLite.h"
#import "GXHeadReduceTool.h"
#define IconViewHeight 40

@interface GXExchangeCell ()

@property (nonatomic, strong)UIImageView *headV;
@property (nonatomic, strong)UILabel *timeL;
@property (nonatomic, strong)YYLabel *contentL;

@end

@implementation GXExchangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor = GXAdviserBGColor;
    
    UIView *bgV = [[UIView alloc] init];
    bgV.userInteractionEnabled = YES;
    bgV.backgroundColor = [UIColor whiteColor];
    bgV.layer.cornerRadius = 15;
    bgV.layer.masksToBounds = YES;
    [self.contentView addSubview:bgV];
    
    YYLabel *nameL = [[YYLabel alloc] init];
    nameL.textColor = GXRGBColor(64, 130, 244);
    nameL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    [self.contentView addSubview:nameL];
    self.nameLable = nameL;
    
    UILabel *timeL = [[UILabel alloc] init];
    timeL.textColor = GXGrayColor;
    timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    [self.contentView addSubview:timeL];
    self.timeL = timeL;
    
    YYLabel *contentL = [[YYLabel alloc] init];
    contentL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    contentL.preferredMaxLayoutWidth = GXScreenWidth - WidthScale_IOS6(85);
    contentL.numberOfLines = 0;
    [self.contentView addSubview:contentL];
    self.contentL = contentL;
    
    UIImageView *iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0"]];
    iconV.layer.cornerRadius = IconViewHeight / 2;
    iconV.layer.masksToBounds = YES;
    self.headV = iconV;
    
    [self.contentView addSubview:iconV];
    
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(1.5 * GXMargin);
        make.top.equalTo(self.contentView).offset(2 * GXMargin);
        make.width.height.equalTo(@IconViewHeight);
    }];
    
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WidthScale_IOS6(40));
        make.top.equalTo(self.contentView).offset(GXMargin);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-1.5 * GXMargin);
    }];
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(1.5 * GXMargin);
        make.left.equalTo(iconV.mas_right).offset(GXMargin);
    }];
    
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameL);
        make.left.equalTo(nameL.mas_right).offset(GXMargin);
    }];
    
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameL);
        make.top.equalTo(nameL.mas_bottom);
        make.bottom.equalTo(self.contentView).offset(-GXMargin);
    }];
}


- (void)setModel:(GXExchangeModel *)model
{
    _model = model;
    [GXHeadReduceTool loadImageForImageView:self.headV withUrlString:model.userPic placeHolderImageName:@"mine_head_placeholder"];
    [self dealName:model];
    self.timeL.text = [GXLiveTimeTool getTimeString:model.createdTime];
    self.contentL.attributedText = [NSString dealContentText:model.content withView:self];
    self.contentL.attributedText = [NSString dealContentText:model.content];
    self.contentL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.contentL.textColor = GXRGBColor(101, 106, 137);
}

#pragma mark - 用户昵称显示处理(限制用户昵称最多现实十个字符,多出来的以...显示) -
- (void)dealName: (GXExchangeModel *)model{

    NSString *nickName = model.nickName;
    
    for (int i = 0; i < nickName.length; i++) {
        
        NSArray *nameArr = [model.nickName componentsMatchedByRegex:@"[^\\x00-\\xff]"];
        if(model.nickName.length + [nameArr count] > 10)
        {
            model.nickName = [model.nickName substringToIndex:model.nickName.length - 1];
        }else
        {
            if(nickName.length > model.nickName.length)
            {
                model.nickName = [NSString stringWithFormat:@"%@...",model.nickName ];
            }
            break;
        }
    }
    if (model.replyNickName.length == 0) {
        self.nameLable.text = model.nickName;
        return;
    }
    NSString *replyNickName = model.replyNickName;
    
    for (int i = 0; i < replyNickName.length; i++) {
        
        NSArray *rNameArr = [model.replyNickName componentsMatchedByRegex:@"[^\\x00-\\xff]"];
        if(model.replyNickName.length + [rNameArr count] > 10)
        {
            model.replyNickName = [model.replyNickName substringToIndex:model.replyNickName.length - 1];
        }else
        {
            if(replyNickName.length>model.replyNickName.length)
            {
                model.replyNickName = [NSString stringWithFormat:@"%@...",model.replyNickName ];
            }
        }
    }
    NSMutableAttributedString *aStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@回复%@",model.nickName,model.replyNickName]];
    [aStr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(64, 130, 244) range:NSMakeRange(0, model.nickName.length)];
    [aStr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(101, 106, 137) range:NSMakeRange(model.nickName.length,2)];
    [aStr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(64, 130, 244) range:NSMakeRange(model.nickName.length+2,model.replyNickName.length)];
    [aStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(GXFitFontSize14) range:NSMakeRange(0, aStr.length)];
    self.nameLable.attributedText = aStr;

}
@end

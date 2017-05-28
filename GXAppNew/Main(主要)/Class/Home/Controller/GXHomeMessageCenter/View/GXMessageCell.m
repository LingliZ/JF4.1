//
//  GXMessageCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMessageCell.h"
#import "NSString+GXTimeString.h"

@interface GXMessageCell ()
@property (nonatomic,strong) UILabel *contentsLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@end

#define kMargin WidthScale_IOS6(10)
#define GrayColor [UIColor colorWithRed:235 / 250.0 green:237 / 250.0 blue:243 / 250.0 alpha:1]
@implementation GXMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier messageModel:(GXMessagesModel *)messageModel{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:messageModel];
        self.contentView.backgroundColor = GXRGBColor(237, 237, 245);
    }
    return self;
}
- (void)setupUI:(GXMessagesModel *)messageModel{
    UIView *backView = [[UIView alloc]init];
    UIImageView *iconView = [[UIImageView alloc]init];
    self.contentsLabel = [[UILabel alloc]init];
    self.timeLabel = [[UILabel alloc] init];
    UIImageView *triangleView = [[UIImageView alloc]init];

    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    iconView.image = [UIImage imageNamed:@"home_gxmsg_laba_pic"];
    triangleView.image = [UIImage imageNamed:@"home_guoxin_message_pic"];
    self.contentsLabel.font = GXFONT_PingFangSC_Light(GXFitFontSize14);
    self.contentsLabel.textColor = GXRGBColor(1, 1, 1);
    self.contentsLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.contentsLabel.numberOfLines = 0;
    self.timeLabel.textColor = GXRGBColor(145, 145, 145);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize10);
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:iconView];
    [self.contentView addSubview:triangleView];
    [self.contentView addSubview:backView];
    [backView addSubview:self.contentsLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@20);
    }];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.width.height.equalTo(@30);
    }];
    [triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(3);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(15);
        make.width.equalTo(@10);
        make.height.equalTo(@12);
    }];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.right.equalTo(@-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    [self.contentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(10);
        make.left.equalTo(backView.mas_left).offset(10);
        make.right.equalTo(backView.mas_right).offset(-10);
        make.bottom.equalTo(backView.mas_bottom).offset(-10);
    }];
}
- (void)setMessageModel:(GXMessagesModel *)messageModel{
    _messageModel = messageModel;
    NSString *contentStr = [self filterHTML:messageModel.Content];
    self.contentsLabel.text = contentStr;
    self.timeLabel.text = messageModel.timeStr;
}
- (void)setContentColor:(UIColor *)color{
    self.contentsLabel.textColor = color;
    self.timeLabel.textColor = color;
}
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


@end

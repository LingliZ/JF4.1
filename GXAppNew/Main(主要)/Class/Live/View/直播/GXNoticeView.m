//
//  GXNoticeView.m
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXNoticeView.h"
#import "GXNoticeModel.h"

@interface GXNoticeView ()

@end

@implementation GXNoticeView

- (instancetype)initWithFrame:(CGRect)frame withRoomId: (NSString *)roomId
{
    self = [super initWithFrame:frame];
    if (self) {
        self.roomID = roomId;
        [self createUI];
//        [self loadData];
    }
    return self;
}
- (void)createUI
{
    UIImageView *leftV = [[UIImageView alloc] init];
    leftV.image = [UIImage imageNamed:@"notice"];
    leftV.contentMode = UIViewContentModeCenter;
    
    UIImageView *rightV = [[UIImageView alloc] init];
    rightV.image = [UIImage imageNamed:@"right_arrows"];
    rightV.contentMode = UIViewContentModeCenter;
    
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.textColor = GXGrayColor;
    self.titleLable.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
//    self.titleLable.text = @"天青色等烟雨，而我在等你······";
    self.titleLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:rightV];
    [self addSubview:leftV];
    [self addSubview:self.titleLable];
    
    [leftV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@GXMargin);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(WidthScale_IOS6(30)));
    }];
    
    [rightV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-GXMargin));
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(WidthScale_IOS6(30)));
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(leftV.mas_right).offset(GXMargin);
        make.right.equalTo(rightV.mas_left).offset((-GXMargin));
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.delegate) {
        [self.delegate clickedNoticeView: self];
    }
}

#pragma mark - 数据请求 -
//- (void)loadData
//{
//
//}

@end

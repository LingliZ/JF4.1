 //
//  GXInformationCell.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXInformationCell.h"

@interface GXInformationCell ()
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *subTitle;
@end

@implementation GXInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.font = GXFONT_PingFangSC_Regular(GXFitFontSize17);
    self.titleLable.textColor = [UIColor blackColor];
    self.titleLable.numberOfLines = 0;
    
    
    self.subTitle = [[UILabel alloc] init];
    self.subTitle.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    self.subTitle.textColor = GXGrayColor;
    self.subTitle.numberOfLines = 2;
    
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.subTitle];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(2 * GXMargin));
        make.right.equalTo(@(-2 * GXMargin));
        make.top.equalTo(@(2 * GXMargin));
    }];
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(2 * GXMargin));
        make.right.equalTo(@(-2 * GXMargin));
        make.top.equalTo(self.titleLable.mas_bottom).offset(2 * GXMargin);
        make.bottom.equalTo(@(-GXMargin));
    }];
    
    self.titleLable.text = @"贵金属早评";
    self.subTitle.text = @"欧洲央行周四, 欧洲央行周四, 欧洲央行周四, 欧洲央行周四, 欧洲央行周四,欧洲央行周四";
    
}

@end

//
//  GXDiscoverCell.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/9.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXDiscoverCell.h"
#import "UITableViewCell+GXAddSeperator.h"
#import "GXLiveCommonSize.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define IconH 35

@interface GXDiscoverCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@end

@implementation GXDiscoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.iconView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.subLabel = [[UILabel alloc] init];
    
    [self.iconView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"cycle_Banner_placeholder_pic"]];
    self.titleLabel.text = @"资讯";
    self.subLabel.text = @"新手专享开户抽大奖";
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(@(2*GXMargin));
        make.width.height.equalTo(@IconH);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset((GXMargin));
        make.top.equalTo(self.iconView.mas_top);
//        make.height.equalTo(@20);
    }];
    self.titleLabel.font=GXFONT_PingFangSC_Medium(15);
    self.titleLabel.textColor=RGBACOLOR(18, 29, 61, 1);
    
    
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
//        make.bottom.equalTo(self.contentView).offset(-GXMargin);
    }];
    self.subLabel.font=GXFONT_PingFangSC_Regular(12);
    self.subLabel.textColor=RGBACOLOR(161, 166, 187, 1);
    
    
    [self addSepeartorX:15 width:0.5 color:RGBACOLOR(200, 199, 204, 1) top:false bottom:true];
}

- (void)setDiscoverModel:(GXDiscoverModel *)discoverModel{
    _discoverModel = discoverModel;
    self.iconView.image = [UIImage imageNamed:discoverModel.iconName];
    self.titleLabel.text = discoverModel.title;
    self.subLabel.text = discoverModel.subTitle;
}
@end

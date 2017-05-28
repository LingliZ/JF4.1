    //
//  GXDiscoverVideoCell.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXDiscoverVideoCell.h"

@interface GXDiscoverVideoCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *subTitleLable;
@property (nonatomic, strong) UILabel *hostLabel;
@property (nonatomic, strong) UILabel *analystLabel;

@property (nonatomic, strong) UIView *backgView;


@end

@implementation GXDiscoverVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        
        self.contentView.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void)setupUI{
    self.iconView = [[UIImageView alloc] init];
//    self.iconView.backgroundColor = [UIColor cyanColor];
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.font = GXFONT_PingFangSC_Regular(GXFitFontSize17);
    self.subTitleLable = [[UILabel alloc] init];
    self.subTitleLable.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.hostLabel = [[UILabel alloc] init];
    self.hostLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.analystLabel = [[UILabel alloc]init];
    self.analystLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    self.backgView= [[UIView alloc]init];
    self.backgView.backgroundColor=RGBACOLOR(241, 242, 247, 1);
    
    
    [self.contentView addSubview:self.iconView];

    [self.contentView addSubview:self.backgView];
    
    [self.backgView addSubview:self.titleLable];
    [self.backgView addSubview:self.subTitleLable];
    [self.backgView addSubview:self.hostLabel];
    [self.backgView addSubview:self.analystLabel];
    
    self.iconView.contentMode=UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds=YES;
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.right.equalTo(@0);
        make.height.equalTo(@200);
    }];
    
    [self.backgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).offset(0);
        make.left.right.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@-10);
    }];
    
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.left.equalTo(@(15));
        make.right.equalTo(@(-15));
    }];
    [self.analystLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).offset(10);
        make.left.equalTo(self.titleLable);
        make.bottom.equalTo(@-10);
    }];
    
    [self.hostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.analystLabel.mas_right).offset(30);
        make.top.equalTo(self.analystLabel);
        make.bottom.equalTo(self.analystLabel);
    }];
    [self.subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable);
        make.right.equalTo(@-15);
        make.bottom.equalTo(self.titleLable);
    }];
    
}
-(void)setModel:(GXFindVedioModel *)model{
    if (_model != model) {
        _model = model;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"live_ordinary_placeHolder"]];
        self.titleLable.text = model.name;
        self.subTitleLable.text = [NSString stringWithFormat:@"关键词:%@",model.keyWords];
        self.hostLabel.text = [NSString stringWithFormat:@"主持:%@",model.host];
        self.analystLabel.text = [NSString stringWithFormat:@"主讲:%@",model.analysts];
    }
}


@end

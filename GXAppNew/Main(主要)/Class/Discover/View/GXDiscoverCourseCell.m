//
//  GXCourseCell.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXDiscoverCourseCell.h"

@interface GXDiscoverCourseCell ()
@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;
@property(nonatomic,strong)UIView *rootView;
@end

@implementation GXDiscoverCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor=RGBACOLOR(241, 242, 247, 1);
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    self.rootView=[[UIView alloc]initWithFrame:CGRectMake(15, 10, GXScreenWidth-30, 90)];
    self.rootView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:self.rootView];
    self.rootView.layer.cornerRadius=6;
    self.rootView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.rootView.layer.shadowOffset=CGSizeMake(2, 0);
    self.rootView.layer.shadowOpacity=0.1;
    
    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode=UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds=YES;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = GXFONT_PingFangSC_Medium(16);
    self.titleLabel.numberOfLines = 1;
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.font = GXFONT_PingFangSC_Regular(12);
    self.subTitleLabel.textColor = GXGrayColor;
    self.subTitleLabel.numberOfLines = 2;
    
    [self.rootView addSubview:self.iconView];
    [self.rootView addSubview:self.titleLabel];
    [self.rootView addSubview:self.subTitleLabel];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@6);
        make.top.equalTo(@6);
        make.height.equalTo(@78);
        make.width.equalTo(@72);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).offset(8);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@20);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.iconView);
    }];
}
-(void)setModel:(GXInvestListModel *)model{
    if (_model != model) {
        _model = model;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@""]];
        self.titleLabel.text = model.title;
        self.subTitleLabel.text = model.descrip;
    }
}



@end

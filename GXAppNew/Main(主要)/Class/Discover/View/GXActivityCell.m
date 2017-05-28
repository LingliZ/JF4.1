//
//  GXActivityCell.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXActivityCell.h"

@interface GXActivityCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageV;
@end

@implementation GXActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize17);
    self.titleLabel.numberOfLines = 0;
    
    self.imageV = [[UIImageView alloc] init];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imageV];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(2*GXMargin));
        make.right.equalTo(@(-2*GXMargin));
        make.top.equalTo(@(2*GXMargin));
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2*GXMargin);
        make.left.equalTo(@(2*GXMargin));
        make.right.equalTo(@(-2*GXMargin));
        make.height.equalTo(@200);
        make.bottom.equalTo(@(-GXMargin));
    }];
}
-(void)setModel:(GXHomeAdvertistsModel *)model{
    if (_model != model) {
        _model = model;
        self.titleLabel.text = _model.name;
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:_model.imgurl] placeholderImage:[UIImage imageNamed:@""]];
        
    }
}
@end

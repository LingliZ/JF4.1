//
//  GXDetailCourseCell.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXDetailCourseCell.h"

@interface GXDetailCourseCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descripLabel;

@end

@implementation GXDetailCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.titleLabel = [[UILabel alloc] init];
    self.descripLabel = [[UILabel alloc]init];
    
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    self.descripLabel.font = GXFONT_PingFangSC_Light(GXFitFontSize12);
    self.descripLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descripLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.right.equalTo(@-15);
        make.height.equalTo(@20);
    }];
    [self.descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.titleLabel);
        make.bottom.equalTo(@-10);
    }];
}
-(void)setModel:(GXChapterListModel *)model{
    if (_model != model) {
        _model = model;
        self.titleLabel.text = model.title;
        self.descripLabel.text = model.descrip;
    }
}
@end

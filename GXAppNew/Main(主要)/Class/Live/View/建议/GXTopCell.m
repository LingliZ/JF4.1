//
//  GXTopCell.m
//  GXApp
//
//  Created by maliang on 2016/11/15.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXTopCell.h"

@interface GXTopCell ()

@property (nonatomic, strong)UILabel *leftL;
@property (nonatomic, strong)UILabel *centerL;
@property (nonatomic, strong)UILabel *rightL;

@end

@implementation GXTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    UILabel *leftL = [UILabel new];
    leftL.textColor = [UIColor whiteColor];
    leftL.font = GXFONT_PingFangSC_Medium(16);
    leftL.textAlignment = NSTextAlignmentCenter;
    
    UILabel *centerL = [UILabel new];
    centerL.font = GXFONT_PingFangSC_Regular(14);
    centerL.textColor = GXRGBColor(56, 56, 56);
    
    UILabel *rightL = [UILabel new];
    rightL.font = GXFONT_PingFangSC_Regular(14);
    rightL.textColor = GXRGBColor(56, 56, 56);
    
    [self.contentView addSubview:leftL];
    [self.contentView addSubview:centerL];
    [self.contentView addSubview:rightL];
    
    self.leftL = leftL;
    self.centerL = centerL;
    self.rightL = rightL;
    
    [leftL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WidthScale_IOS6(15));
        make.top.equalTo(self.contentView).offset(Margin);
        make.bottom.equalTo(self.contentView).offset(-Margin);
    }];
    
    [centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(WidthScale_IOS6(95));
        make.centerY.equalTo(leftL);
        make.width.equalTo(@(WidthScale_IOS6(180)));
    }];
    
    [rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-WidthScale_IOS6(15));
        make.centerY.equalTo(centerL);
    }];
}

- (void)setModel:(GXOperationItemModel *)model
{
    _model = model;
    self.leftL.text = model.leftStr;
    [self.leftL sizeToFit];
    NSInteger width = self.leftL.frame.size.width + WidthScale_IOS6(8);
    
    [self.leftL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
    }];
    self.rightL.text = model.rightStr;
    if ([self.model.leftStr isEqualToString:@"减持"]) {
        self.leftL.backgroundColor = [UIColor getColor:@"569AE0"];
    }else if ([self.model.leftStr isEqualToString:@"平仓"] || [self.model.leftStr isEqualToString:@"已回购"]) {
        self.leftL.backgroundColor = [UIColor getColor:@"C5C5C5"];
    }else if ([self.model.leftStr isEqualToString:@"撤单"]) {
        self.leftL.backgroundColor = [UIColor getColor:@"C5C5C5"];
    }else {
        self.leftL.backgroundColor = [UIColor getColor:@"E4A928"];
    }
    if ([model.types integerValue] == 3) {
        self.centerL.text = @"";
    }else{
        self.centerL.text = model.centerStr;
    }
}

@end


//
//  GXLiveCell.m
//  GXAppNew
//
//  Created by maliang on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLiveCell.h"
#import <YYText/YYText.h>
#import "NSString+GXEmotAttributedString.h"
#import "GXPicturesView.h"
#import "GXLiveCommonSize.h"
#import "GXLiveTimeTool.h"
#import "GXHeadReduceTool.h"

@interface GXLiveCell ()

@property (nonatomic, strong) UIImageView *headV;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) YYLabel *contentL;
@property (nonatomic, strong) GXPicturesView *picturesView;
@property (nonatomic, strong) MASConstraint *bottomConstraint;
@property (nonatomic, strong) UIImageView *topV;
@end

@implementation GXLiveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.backgroundColor = GXRGBColor(241, 242, 247);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createUI
{
    self.contentView.layer.cornerRadius = WidthScale_IOS6(10);
    self.contentView.layer.masksToBounds = YES;
    //置顶标识
    UIImageView *topV = [[UIImageView alloc] init];
    //分析师头像
    UIImageView *headV = [[UIImageView alloc] init];
    headV.layer.cornerRadius = WidthScale_IOS6(22);
    headV.layer.masksToBounds = YES;
    //分析师名字
    UILabel *nameL = [[UILabel alloc] init];
    nameL.font = GXFONT_PingFangSC_Regular(14);
    nameL.textColor = GXRGBColor(64, 130, 244);
    //分析师头衔
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale_IOS6(116), HeightScale_IOS6(10), WidthScale_IOS6(101), HeightScale_IOS6(17))];
    titleL.font = GXFONT_PingFangSC_Regular(14);
    titleL.textColor = GXRGBColor(161, 166, 187);
    titleL.text = @"高级策略分析师";
    //时间显示
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(titleL.origin.x + titleL.size.width + WidthScale_IOS6(60), HeightScale_IOS6(10), WidthScale_IOS6(70), HeightScale_IOS6(13))];
    timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    timeL.textColor = GXRGBColor(161, 166, 187);
    //直播内容显示
    YYLabel *contentL = [[YYLabel alloc] init];
    contentL.preferredMaxLayoutWidth = WidthScale_IOS6(283);
    contentL.numberOfLines = 0;

    [self.contentView addSubview:topV];
    [self.contentView addSubview:headV];
    [self.contentView addSubview:nameL];
    [self.contentView addSubview:titleL];
    [self.contentView addSubview:timeL];
    [self.contentView addSubview:contentL];
    
    self.headV = headV;
    self.nameL = nameL;
    self.timeL = timeL;
    self.contentL = contentL;
    self.topV = topV;
    
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.width.mas_equalTo(@(WidthScale_IOS6(20)));
        make.height.mas_equalTo(@(WidthScale_IOS6(20)));
    }];
    
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).offset(WidthScale_IOS6(10));
        make.width.height.mas_equalTo(@(WidthScale_IOS6(44)));
    }];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headV.mas_top);
        make.left.mas_equalTo(headV.mas_right).offset(WidthScale_IOS6(7));
    }];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameL);
        make.left.mas_equalTo(nameL.mas_right).offset(WidthScale_IOS6(15));
    }];
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleL);
        make.right.mas_equalTo(self.contentView).offset(WidthScale_IOS6(-15));
    }];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameL.mas_left);
        make.right.mas_equalTo(timeL);
        make.top.mas_equalTo(nameL.mas_bottom).offset(WidthScale_IOS6(10));
       self.bottomConstraint =  make.bottom.equalTo(@(-GXMargin));
    }];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(PictureWidth, PictureWidth);
    flowLayout.minimumLineSpacing = imageMargin;
    flowLayout.minimumInteritemSpacing = imageMargin;
    self.picturesView = [[GXPicturesView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.contentView addSubview:self.picturesView];

}

- (void)setModel:(GXLiveModel *)model
{
    _model = model;
    [GXHeadReduceTool loadImageForImageView:self.headV withUrlString:model.photo placeHolderImageName:@"mine_head_placeholder"];
    self.nameL.text = model.userName;
    self.timeL.text = [GXLiveTimeTool getTimeString:model.createdTime];
    self.contentL.attributedText = [NSString dealContentText:model.content withView:self];
    self.contentL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.contentL.textColor = GXRGBColor(101, 106, 137);
    if ([model.isTop integerValue] == 1) {
        self.topV.image = [UIImage imageNamed:@"isTop_pic"];
    }else{
        self.topV.image = nil;
    }

    if (self.bottomConstraint) {
        [self.bottomConstraint uninstall];
    }
    NSArray *pictureArray = model.livePicsArray;
    if (pictureArray.count > 0) {
        self.picturesView.hidden = NO;
        CGSize picturesViewSize = [self getSize:pictureArray.count];
        [self.picturesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentL.mas_bottom).offset(imageMargin);
            make.left.equalTo(self.contentL);
            make.height.equalTo(@(picturesViewSize.height + 1));
            make.width.equalTo(@(picturesViewSize.width + 1));
            self.bottomConstraint = make.bottom.equalTo(@(-imageMargin));
        }];
        self.picturesView.Imgs = pictureArray;
    }
    else{
        self.picturesView.hidden = YES;
        [self.contentL mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomConstraint = make.bottom.mas_equalTo(@(-imageMargin));
        }];
        self.picturesView.Imgs = nil;
    }

}

- (CGSize)getSize:(NSUInteger)count{
    CGSize size;
    if (count <= 3) {
        size = CGSizeMake(PictureWidth * 3 + 2 * imageMargin, PictureWidth);
    }
    else if (count == 4) {
        size = CGSizeMake(PictureWidth * 2 + imageMargin,PictureWidth * 2 + imageMargin);
    }
    else if (count == 5 || count == 6) {
        size = CGSizeMake(PictureWidth * 3 + 2 * imageMargin, PictureWidth * 2 + imageMargin);
    }else{
        size = CGSizeMake(PictureWidth * 3 + 2 * imageMargin, PictureWidth * 3 + 2 * imageMargin);
    }
    return size;
}
@end

//
//  GXOrdinaryCell.m
//  GXAppNew
//
//  Created by maliang on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXOrdinaryCell.h"
#import "GXLiveBtn.h"
#import "GXLoginByVertyViewController.h"
#import "GXUserInfoTool.h"

@interface GXOrdinaryCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headV;
@property (nonatomic, strong) GXLiveBtn *stateBtn;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *analystL;
//@property (nonatomic, strong) UILabel *leftL;
//@property (nonatomic, strong) UILabel *rightL;
@property (nonatomic, strong) UILabel *popularL;
@property (nonatomic, strong) UILabel *descL;
@property (nonatomic, strong) UIButton *boundingBtn;
@property (nonatomic, strong) UIButton *vipBtn;

@end

@implementation GXOrdinaryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)createUI
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.layer.shadowColor = [[UIColor blackColor]CGColor];
    bgView.layer.shadowOffset = CGSizeMake(0, 3.0f);
    bgView.layer.shadowOpacity = 0.02;
    bgView.layer.shadowRadius = 0.3;
    UIImageView *headV = [[UIImageView alloc] init];
    GXLiveBtn *stateBtn = [[GXLiveBtn alloc] initWithFrame:CGRectMake(0, 0, 80, 23)];
    stateBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize13);
    stateBtn.layer.cornerRadius = WidthScale_IOS6(7);
    stateBtn.layer.masksToBounds = YES;
    UILabel *nameL = [[UILabel alloc] init];
    nameL.font = GXFONT_PingFangSC_Medium(GXFitFontSize18);
    nameL.textColor = GXRGBColor(18, 29, 61);
    nameL.textAlignment = NSTextAlignmentCenter;
    UIButton *vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *analystL = [[UILabel alloc] init];
    analystL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    analystL.textColor = GXRGBColor(101, 106, 137);
//    UILabel *leftL = [[UILabel alloc] init];
//    leftL.font = GXFONT_PingFangSC_Light(GXFitFontSize11);
//    leftL.textColor = GXRGBColor(161, 166, 187);
//    leftL.layer.borderColor = GXRGBColor(161, 166, 187).CGColor;
//    leftL.layer.borderWidth = 1;
//    leftL.layer.cornerRadius = WidthScale_IOS6(8);
//    leftL.layer.masksToBounds = YES;
//    leftL.textAlignment = NSTextAlignmentCenter;
//    UILabel *rightL = [[UILabel alloc] init];
//    rightL.font = GXFONT_PingFangSC_Light(GXFitFontSize11);
//    rightL.textColor = GXRGBColor(161, 166, 187);
//    rightL.layer.borderColor = GXRGBColor(161, 166, 187).CGColor;
//    rightL.layer.borderWidth = 1;
//    rightL.layer.cornerRadius = WidthScale_IOS6(8);
//    rightL.layer.masksToBounds = YES;
//    rightL.textAlignment = NSTextAlignmentCenter;
    UILabel *popularL = [[UILabel alloc] init];
    popularL.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    popularL.textColor = GXRGBColor(161, 166, 187);
    
    UILabel *descL = [[UILabel alloc] init];
    descL.numberOfLines = 0;
//    descL.textAlignment = NSTextAlignmentRight;
    descL.font = GXFONT_PingFangSC_Light(GXFitFontSize12);
    descL.textColor = GXRGBColor(101, 106, 137);
    
    UIButton *boundingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    boundingBtn.titleLabel.textColor = GXRGBColor(64, 130, 244);
    boundingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    boundingBtn.layer.cornerRadius = WidthScale_IOS6(12);
    boundingBtn.layer.masksToBounds = YES;

    [self.contentView addSubview:bgView];
    [bgView addSubview:headV];
    [bgView addSubview:nameL];
    [bgView addSubview:vipBtn];
    [bgView addSubview:analystL];
//    [bgView addSubview:leftL];
//    [bgView addSubview:rightL];
    [bgView addSubview:boundingBtn];
    [bgView addSubview:popularL];
    [bgView addSubview:descL];
    [headV addSubview:stateBtn];
    
    
    self.bgView = bgView;
    self.headV = headV;
    self.nameL = nameL;
    self.stateBtn = stateBtn;
    self.analystL = analystL;
//    self.leftL = leftL;
//    self.rightL = rightL;
    self.popularL = popularL;
    self.descL = descL;
    self.boundingBtn = boundingBtn;
    self.vipBtn = vipBtn;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@(1.5 * GXMargin));
        make.right.bottom.mas_equalTo(self.contentView).offset(WidthScale_IOS6(-15));
    }];
    [headV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(bgView);
        make.right.mas_equalTo(bgView);
        make.bottom.mas_equalTo(HeightScale_IOS6(-90));
    }];
    [stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@(WidthScale_IOS6(-10)));
        make.top.mas_equalTo(@(WidthScale_IOS6(10)));
        make.height.equalTo(@(HeightScale_IOS6(24)));
    }];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(WidthScale_IOS6(3)));
        make.top.mas_equalTo(headV.mas_bottom).offset(WidthScale_IOS6(10));
    }];
    [vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameL.mas_right).offset(WidthScale_IOS6(3));
        make.centerY.mas_equalTo(nameL);
        make.width.mas_equalTo(@(WidthScale_IOS6(26)));
        make.height.mas_equalTo(@(WidthScale_IOS6(13)));
    }];
    [analystL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameL);
        make.top.mas_equalTo(nameL.mas_bottom).offset(HeightScale_IOS6(5));
        make.height.mas_equalTo(@(HeightScale_IOS6(10)));
//        make.bottom.mas_equalTo(leftL.mas_top).offset(HeightScale_IOS6(-5));
    }];
    [descL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.analystL);
        make.right.mas_equalTo(@(WidthScale_IOS6(-5)));
        make.top.mas_equalTo(self.analystL.mas_bottom).mas_offset(HeightScale_IOS6(7));
//        make.bottom.mas_equalTo(@(HeightScale_IOS6(-5)));
    }];
}

- (void)setModel:(GXVideoModel *)model
{
    _model = model;
    [self.headV sd_setImageWithURL:[NSURL URLWithString:model.imageUrlApp] placeholderImage:[UIImage imageNamed:@"live_ordinary_placeHolder"]];
    if (model.isLive) {
        [self.stateBtn setImage:[UIImage imageNamed:@"living"] forState:UIControlStateNormal];
    }else{
        [self.stateBtn setImage:[UIImage imageNamed:@"rest"] forState:UIControlStateNormal];
    }
    if ([model.isVip integerValue] == 1) {
        [self.vipBtn setImage:[UIImage imageNamed:@"vip"] forState:UIControlStateNormal];
    }
    self.nameL.text = model.name;
    //分析师在线状态处理
    if (model.analyst.length > 0) {
        NSString *analystStr = @"";
        NSArray *analystArr = [self.model.analyst componentsSeparatedByString:@","];
        NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(GXFitFontSize12), NSForegroundColorAttributeName:GXRGBColor(101, 106, 137)}];
        for (NSString *analyst in analystArr) {
            if ([[[analyst componentsSeparatedByString:@"/"] objectAtIndex:1] isEqualToString:@"在线"]) {
                analystStr = [NSString stringWithFormat:@"%@[在线] ",[[analyst componentsSeparatedByString:@"/"] objectAtIndex:0]];
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:analystStr attributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(GXFitFontSize12), NSForegroundColorAttributeName:GXRGBColor(101, 106, 137)}];
                [att addAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(GXFitFontSize12), NSForegroundColorAttributeName:GXRGBColor(64, 130, 244)} range:NSMakeRange(att.length - 5, 4)];
                [attrM appendAttributedString:att];
            }
            if ([[[analyst componentsSeparatedByString:@"/"] objectAtIndex:1] isEqualToString:@"离线"]) {
                analystStr = [NSString stringWithFormat:@"%@[离线] ",[[analyst componentsSeparatedByString:@"/"] objectAtIndex:0]];
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:analystStr attributes:@{NSFontAttributeName:GXFONT_PingFangSC_Regular(GXFitFontSize12), NSForegroundColorAttributeName:GXRGBColor(101, 106, 137)}];
                [attrM appendAttributedString:att];
                
             }
        }
        self.analystL.attributedText = attrM;
    }else{
        self.analystL.text = @"";
    }
    

//    NSArray *arr = [model.roomTags componentsSeparatedByString:@","];
//    if (arr.count == 1) {
//        self.leftL.text = arr[0];
//        self.rightL.text = nil;
//    }else{
//        self.leftL.text = arr[0];
//        self.rightL.text = arr[1];
//    }
    self.descL.text = model.intro;
    self.popularL.text = [NSString stringWithFormat:@"人气:%@",model.bindCount];
    //获取绑定按钮的显示状态
    if ([self.model.isBindRoom integerValue] == 0) {
        [self.boundingBtn setTitle:@"绑定" forState:UIControlStateNormal];
        self.boundingBtn.titleLabel.textColor = [UIColor whiteColor];
        [self.boundingBtn setBackgroundColor:GXRGBColor(64, 130, 244)];
        self.boundingBtn.titleLabel.font = GXFONT_PingFangSC_Regular(15);
        [self.boundingBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.boundingBtn setTitle:@"解绑" forState:UIControlStateNormal];
        self.boundingBtn.layer.borderWidth = 1.0;
        self.boundingBtn.layer.borderColor = GXRGBColor(64, 130, 244).CGColor;
        [self.boundingBtn setTitleColor:GXRGBColor(64, 130, 244) forState:UIControlStateNormal];
        [self.boundingBtn setBackgroundColor:[UIColor whiteColor]];
        self.boundingBtn.titleLabel.font = GXFONT_PingFangSC_Regular(15);
        [self.boundingBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
//    CGSize size = [self.leftL.text boundingWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) FontSize:GXFitFontSize11];
//    [self.leftL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.nameL);
//        make.bottom.mas_equalTo(HeightScale_IOS6(-10));
//        make.width.mas_equalTo(size.width + 10);
//        make.height.mas_equalTo(HeightScale_IOS6(15));
//    }];
//    [self.rightL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.leftL.mas_right).offset(10);
//        make.bottom.mas_equalTo(HeightScale_IOS6(-10));
//        if (self.rightL.text.length > 0) {
//            make.width.mas_equalTo(size.width + 10);
//        }
//        
//    }];
    [self.popularL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.vipBtn);
        make.left.mas_equalTo(self.vipBtn.mas_right).offset(WidthScale_IOS6(5));
    }];
    [self.boundingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.analystL);
        make.right.mas_equalTo(self.contentView.mas_right).offset(WidthScale_IOS6(-20));
        make.width.mas_equalTo(@(WidthScale_IOS6(64)));
        make.height.mas_equalTo(@(HeightScale_IOS6(25)));
    }];

}

- (void)buttonClicked:(UIButton *)sender
{
    if (![GXUserInfoTool isLogin]) {
        self.myBlock();
        return;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"roomId"] = self.model.id;
    if ([self.model.isBindRoom integerValue] == 0) {
        [GXHttpTool POST:GXUrl_select_room parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
            }else
            {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"绑定成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
                
                self.model.isBindRoom=@"1";
            }
        } failure:^(NSError *error) {
            
        }];
    } else {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要解绑该播间吗？" delegate:self
    cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];
        [self.boundingBtn setTitle:@"解绑" forState:UIControlStateNormal];
        self.boundingBtn.layer.borderColor = GXRGBColor(64, 130, 244).CGColor;
        [self.boundingBtn setTitleColor:GXRGBColor(64, 130, 244) forState:UIControlStateNormal];
        [self.boundingBtn setBackgroundColor:[UIColor whiteColor]];
    }
}

//alertV代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [MobClick event:@"counselor_set"];
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        param[@"roomId"] = self.model.id;
        [GXHttpTool POST:GXUrl_cancel_room parameters:param success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
            } else {
                self.model.isBindRoom=@"0";
                [MobClick event:@"counselor_set"];
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"解绑成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
                [self.boundingBtn setTitle:@"绑定" forState:UIControlStateNormal];
                [self.boundingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.boundingBtn setBackgroundColor:GXRGBColor(64, 130, 244)];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

@end

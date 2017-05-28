//
//  GXSuggestionCell.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSuggestionCell.h"
#import "NSString+GXTimeString.h"

#define ArrowBtnW WidthLandScale_IOS6(30)

@interface GXSuggestionCell()
@property (nonatomic, strong) UILabel *operationLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *varietyLabel;
@property (nonatomic, strong) UILabel *nameLable;
@end

@implementation GXSuggestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{
    self.operationLabel = [[UILabel alloc] init];
    self.dateLabel = [[UILabel alloc] init];
    self.varietyLabel = [[UILabel alloc] init];
    self.nameLable = [[UILabel alloc] init];
    
    [self addLable:self.operationLabel leftCenterMargin:WidthScale_IOS6(40)];
    [self addLable:self.dateLabel leftCenterMargin:WidthScale_IOS6(140)];
    [self addLable:self.varietyLabel leftCenterMargin:WidthScale_IOS6(220)];
    [self addLable:self.nameLable leftCenterMargin:WidthScale_IOS6(300)];
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    iconBtn.enabled = false;
    self.iconBtn = iconBtn;
    
    [self.contentView addSubview:iconBtn];
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-GXMargin);
        make.height.width.equalTo(@ArrowBtnW);
    }];
    
}
- (void)addLable: (UILabel *)lable leftCenterMargin: (CGFloat)margin{
    lable.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    lable.textColor = [UIColor whiteColor];
    [self.contentView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView.mas_left).offset(margin);
    }];
}

- (void)setSuggestionModel:(GXSuggestionModel *)suggestionModel{
    _suggestionModel = suggestionModel;
    self.operationLabel.text = ((GXOperationItemModel *)suggestionModel.operationItems.firstObject).leftStr;
    self.dateLabel.text = [NSString getTimeString:@"MM.dd" sourceTimeStr:((GXOperationItemModel *)suggestionModel.operationItems.firstObject).createdTime];
    self.varietyLabel.text = suggestionModel.varieties;
    self.nameLable.text = suggestionModel.userName;
}

@end

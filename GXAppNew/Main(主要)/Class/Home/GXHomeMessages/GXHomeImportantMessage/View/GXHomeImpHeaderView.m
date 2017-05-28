//
//  GXHomeImpHeaderView.m
//  GXAppNew
//
//  Created by 王振 on 2017/1/23.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXHomeImpHeaderView.h"

@interface GXHomeImpHeaderView ()
@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation GXHomeImpHeaderView
+ (instancetype)headerViewWihtTableView:(UITableView *)tableView{
    static NSString *ID = @"header";
    GXHomeImpHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[GXHomeImpHeaderView alloc]initWithReuseIdentifier:ID];
    }
    return header;
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(45, 47, 59));
        UIView *leftLineView = [[UIView alloc]init];
        UILabel *titleLabel = [[UILabel alloc]init];
        UIView *rightLineView = [[UIView alloc]init];
        leftLineView.dk_backgroundColorPicker = DKColorPickerWithColors(GXRGBColor(231, 235, 243),GXRGBColor(40,40,54));
        titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
        titleLabel.textColor = GXRGBColor(101, 106, 137);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        rightLineView.dk_backgroundColorPicker = DKColorPickerWithColors(GXRGBColor(231, 235, 243),GXRGBColor(40,40,54));
        //[self.contentView addSubview:leftLineView];
        [self.contentView addSubview:titleLabel];
        //[self.contentView addSubview:rightLineView];
        
//        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@0);
//            make.right.equalTo(titleLabel.mas_left).offset(0);
//            make.height.equalTo(@1);
//            make.centerY.equalTo(self.contentView);
//        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
//            make.width.equalTo(@80);
            make.centerX.equalTo(self.contentView);
        }];
//        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(@0);
//            make.left.equalTo(titleLabel.mas_right).offset(0);
//            make.height.equalTo(@1);
//            make.centerY.equalTo(self.contentView);
//        }];
    }return self;
}
- (void)setTitle:(NSString *)title{
    if (_title != title) {
        _title = title;
        self.titleLabel.text = title;
    }
}

@end

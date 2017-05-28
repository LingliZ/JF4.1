//
//  GXHomeUserStatisticsCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeUserStatisticsCell.h"

@implementation GXHomeUserStatisticsCell
- (IBAction)homeBtnDidClickAction:(UIButton *)sender {
   _homeBtnBlock(sender.tag);
}
- (void)awakeFromNib {
    [super awakeFromNib];

    self.backGroundView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(34, 35, 45));
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithColors(RGBACOLOR(241, 241, 245, 1),GXRGBColor(34, 35, 45));
    [self.homeBtn1 dk_setTitleColorPicker:DKColorPickerWithColors(RGBACOLOR(18, 29, 61, 1),RGBACOLOR(88, 118, 189, 1)) forState:UIControlStateNormal];
    [self.homeBtn2 dk_setTitleColorPicker:DKColorPickerWithColors(RGBACOLOR(18, 29, 61, 1),RGBACOLOR(88, 118, 189, 1)) forState:UIControlStateNormal];
    [self.homeBtn3 dk_setTitleColorPicker:DKColorPickerWithColors(RGBACOLOR(18, 29, 61, 1),RGBACOLOR(88, 118, 189, 1)) forState:UIControlStateNormal];
    [self.homeBtn4 dk_setTitleColorPicker:DKColorPickerWithColors(RGBACOLOR(18, 29, 61, 1),RGBACOLOR(88, 118, 189, 1)) forState:UIControlStateNormal];
    [self.homeBtn1 dk_setImage:DKImagePickerWithNames(@"brand_advantage_pic_night", @"brand_advantage_pic")  forState:UIControlStateNormal];
    [self.homeBtn2 dk_setImage:DKImagePickerWithNames(@"profit_ranking_pic_night", @"profit_ranking_pic")  forState:UIControlStateNormal];
    [self.homeBtn3 dk_setImage:DKImagePickerWithNames(@"open_account_pic_night", @"open_account_pic")  forState:UIControlStateNormal];
    [self.homeBtn4 dk_setImage:DKImagePickerWithNames(@"online_service_pic_night", @"online_service_pic")  forState:UIControlStateNormal];
    [self.homeBtn1 setImagePosition:GXImagePositionTop spacing:5];
    [self.homeBtn2 setImagePosition:GXImagePositionTop spacing:5];
    [self.homeBtn3 setImagePosition:GXImagePositionTop spacing:5];
    [self.homeBtn4 setImagePosition:GXImagePositionTop spacing:5];
    self.homeBtn1.showsTouchWhenHighlighted = YES;
    self.homeBtn2.showsTouchWhenHighlighted = YES;
    self.homeBtn3.showsTouchWhenHighlighted = YES;
    self.homeBtn4.showsTouchWhenHighlighted = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

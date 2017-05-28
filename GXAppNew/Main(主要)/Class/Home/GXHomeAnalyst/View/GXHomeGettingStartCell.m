//
//  GXHomeGettingStartCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeGettingStartCell.h"

@interface GXHomeGettingStartCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine;

@end

@implementation GXHomeGettingStartCell
- (IBAction)didClickNewOneStartAction:(UIButton *)sender {
    _didNewOneClickAction(sender.tag);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.dk_backgroundColorPicker = DKColorPickerWithColors(GXRGBColor(237, 237, 243),GXRGBColor(34, 35, 45));
    self.backGroundView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(34, 35, 45));
    self.rootView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(42, 44, 60));
    self.homeNewOneLabel.dk_textColorPicker=DKColorPickerWithColors(RGBACOLOR(18, 29, 61, 1),GXRGBColor(231, 231, 231));
    
    [self.homeNewOneBtn1 dk_setTitleColorPicker:DKColorPickerWithColors(RGBACOLOR(18, 29, 61, 1),GXRGBColor(231, 231, 231)) forState:UIControlStateNormal];
    [self.homeNewOneBtn2 dk_setTitleColorPicker:DKColorPickerWithColors(RGBACOLOR(18, 29, 61, 1),GXRGBColor(231, 231, 231)) forState:UIControlStateNormal];
    [self.homeNewOneBtn3 dk_setTitleColorPicker:DKColorPickerWithColors(RGBACOLOR(18, 29, 61, 1),GXRGBColor(231, 231, 231)) forState:UIControlStateNormal];
    [self.homeNewOneBtn1 setShowsTouchWhenHighlighted:YES];
    [self.homeNewOneBtn2 setShowsTouchWhenHighlighted:YES];
    [self.homeNewOneBtn3 setShowsTouchWhenHighlighted:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

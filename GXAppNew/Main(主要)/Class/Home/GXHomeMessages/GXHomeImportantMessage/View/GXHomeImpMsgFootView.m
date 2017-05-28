//
//  GXHomeImpMsgFootView.m
//  GXAppNew
//
//  Created by 王振 on 2017/2/16.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXHomeImpMsgFootView.h"

@implementation GXHomeImpMsgFootView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.sepLineView.dk_backgroundColorPicker = DKColorPickerWithColors(GXRGBColor(219, 219, 219),[UIColor whiteColor]);
    self.createdLabel.dk_backgroundColorPicker = DKColorPickerWithColors(GXRGBColor(241, 241, 245),GXHomeDKBlackColor);
    self.dk_backgroundColorPicker = DKColorPickerWithColors(GXRGBColor(241, 241, 245),GXHomeDKBlackColor);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

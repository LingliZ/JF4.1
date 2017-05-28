//
//  GXHomeRemindRoomCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeRemindRoomCell.h"


@implementation GXHomeRemindRoomCell

-(void)setModel:(GXHomeRemindRoomModel *)model{
    if (_model != model) {
        _model = model;
        self.roomNameLabel.text = self.model.name;
        if (![self.model.imgUrl containsString:@"http"]) {
            self.model.imgUrl = [baseImageUrl stringByAppendingString:self.model.imgUrl];
        }
        [self.userImgView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl] placeholderImage:[UIImage imageNamed:@"cycle_Banner_placeholder_pic"]];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.dk_backgroundColorPicker= DKColorPickerWithColors(RGBACOLOR(241, 241, 245, 1),GXRGBColor(34, 35, 45));
    self.backGroundView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(34, 35, 45));
    self.rootView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(42, 44, 60));
    self.roomNameLabel.dk_textColorPicker = DKColorPickerWithColors(GXRGBColor(18, 29, 61),GXRGBColor(231, 231, 231));
    self.userImgView.backgroundColor=[UIColor blackColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

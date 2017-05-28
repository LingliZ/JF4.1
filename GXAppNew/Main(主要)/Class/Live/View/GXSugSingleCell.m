//
//  GXSugSingleCell.m
//  GXAppNew
//
//  Created by zhudong on 2017/1/13.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXSugSingleCell.h"

@interface GXSugSingleCell ()
@property (weak, nonatomic) IBOutlet UILabel *operateL;
@property (weak, nonatomic) IBOutlet UILabel *centerL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidthCons;

@end

@implementation GXSugSingleCell

- (void)setOperateModel:(GXOperationItemModel *)operateModel{
    _operateModel = operateModel;
    self.operateL.text = operateModel.leftStr;
    self.centerL.text = operateModel.centerStr;
    self.timeL.text = operateModel.rightStr;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.operateL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.centerL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.rightWidthCons.constant = WidthScale_IOS6(110);
}
@end

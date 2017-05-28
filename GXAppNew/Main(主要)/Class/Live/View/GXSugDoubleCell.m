//
//  GXSugDoubleCell.m
//  GXAppNew
//
//  Created by zhudong on 2017/1/13.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXSugDoubleCell.h"

@interface GXSugDoubleCell()
@property (weak, nonatomic) IBOutlet UILabel *operateL;
@property (weak, nonatomic) IBOutlet UILabel *centerTopL;
@property (weak, nonatomic) IBOutlet UILabel *centerBotL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end

@implementation GXSugDoubleCell

- (void)setOperateModel:(GXOperationItemModel *)operateModel{
    _operateModel = operateModel;
    self.operateL.text = operateModel.leftStr;
    if ([operateModel.leftStr isEqualToString:@"减持"]) {
        self.centerTopL.text = [NSString stringWithFormat:@"点位:%@",operateModel.stopPrice];
        self.centerBotL.text = [NSString stringWithFormat:@"仓位:%@%%",operateModel.positions];
    }else{
        self.centerTopL.text = [NSString stringWithFormat:@"止损价修改为:%@",operateModel.stopPrice];
        self.centerBotL.text = [NSString stringWithFormat:@"目标价修改为:%@",operateModel.targetPrice];
    }
    self.timeL.text = operateModel.rightStr;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.operateL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.centerTopL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.centerBotL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
}
@end

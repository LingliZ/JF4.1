//
//  GXSugFooterCell.m
//  GXAppNew
//
//  Created by zhudong on 2017/1/13.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXSugFooterCell.h"

@interface GXSugFooterCell ()
@property (weak, nonatomic) IBOutlet UILabel *opinionL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@end

@implementation GXSugFooterCell
- (void)setSuggestionModel:(GXSuggestionModel *)suggestionModel{
    _suggestionModel = suggestionModel;
//    if (self.suggestionModel.positions > 0) {
//        contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,仓位%ld%%,",self.suggestionModel.varieties,_suggestionModel.pattern,self.suggestionModel.sellingPrice,self.suggestionModel.direction,self.suggestionModel.stopPrice,self.suggestionModel.targetPrice,self.suggestionModel.positions];
//    } else {
//        contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,",self.suggestionModel.varieties,self.suggestionModel.pattern,self.suggestionModel.sellingPrice,self.suggestionModel.direction,self.suggestionModel.stopPrice,self.suggestionModel.targetPrice];
//    }
    NSString *contentStr;
    if ([self.suggestionModel.pattern isEqualToString:@"挂单"]) {
        if (self.suggestionModel.positions > 0) {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,仓位%ld%%,",self.suggestionModel.varieties,self.suggestionModel.pattern,self.suggestionModel.buyingPrice,self.suggestionModel.direction,self.suggestionModel.stopPrice,self.suggestionModel.targetPrice,self.suggestionModel.positions];
        } else {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,",self.suggestionModel.varieties,self.suggestionModel.pattern,self.suggestionModel.buyingPrice,self.suggestionModel.direction,self.suggestionModel.stopPrice,self.suggestionModel.targetPrice];
        }
    } else {
        if (self.suggestionModel.positions > 0) {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,仓位%ld%%,",self.suggestionModel.varieties,_suggestionModel.pattern,self.suggestionModel.sellingPrice,self.suggestionModel.direction,self.suggestionModel.stopPrice,self.suggestionModel.targetPrice,self.suggestionModel.positions];
        } else {
            contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,",self.suggestionModel.varieties,self.suggestionModel.pattern,self.suggestionModel.sellingPrice,self.suggestionModel.direction,self.suggestionModel.stopPrice,self.suggestionModel.targetPrice];
        }
    }
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;
    NSMutableAttributedString *attriM = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:@{NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14), NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [attriM addAttribute:NSParagraphStyleAttributeName
                   value:paragraph
                   range:NSMakeRange(0, [attriM length])];
    [attriM appendAttributedString: suggestionModel.contentForLive];
    
    self.contentL.attributedText = attriM;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.opinionL.font = GXFONT_PingFangSC_Regular(GXFitFontSize16);
}
@end

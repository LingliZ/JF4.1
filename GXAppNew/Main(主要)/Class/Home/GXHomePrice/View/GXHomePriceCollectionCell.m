//
//  GXHomePriceCollectionCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomePriceCollectionCell.h"

@interface GXHomePriceCollectionCell ()



@end

@implementation GXHomePriceCollectionCell

-(void)setModel:(PriceMarketModel *)model{
    
    if (model.shortName.length > 0) {
        NSString *allStr = [NSString stringWithFormat:@"%@%@",model.name,model.shortName];
        NSMutableAttributedString *allAttStr = [[NSMutableAttributedString alloc]initWithString:allStr];
        NSRange nameR = NSMakeRange(0, model.name.length);
        NSRange shortNameR = NSMakeRange(model.name.length,allStr.length - model.name.length);
        [allAttStr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(18, 29, 61) range:nameR];
        [allAttStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(12) range:nameR];
        [allAttStr addAttribute:NSForegroundColorAttributeName value:GXRGBColor(161, 166, 187) range:shortNameR];
        [allAttStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Light(10) range:shortNameR];
        if (IS_IPHONE_5) {
            [allAttStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Regular(10) range:nameR];
            [allAttStr addAttribute:NSFontAttributeName value:GXFONT_PingFangSC_Light(8) range:shortNameR];
            
        }
        self.nameLabel.attributedText = allAttStr;
    }else{
        self.nameLabel.text = model.name;
    }

    self.priceLabel.text=model.last;
    self.priceLabel.textColor=model.increaseBackColor;
    self.rateLabel.text = [NSString stringWithFormat:@"%@   %@",model.increase,model.increasePercentage];
    self.rateLabel.textColor = model.increaseBackColor;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPHONE_5) {
        self.priceLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize16);
        self.rateLabel.font =GXFONT_PingFangSC_Regular(GXFitFontSize11);
        
    }

}

@end

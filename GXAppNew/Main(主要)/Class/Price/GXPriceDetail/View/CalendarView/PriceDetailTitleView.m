//
//  PriceDetailTitleView.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/18.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "PriceDetailTitleView.h"

@interface PriceDetailTitleView ()
@property (weak, nonatomic) IBOutlet UILabel *codeNameFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation PriceDetailTitleView




//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self = [[[NSBundle mainBundle] loadNibNamed:@"PriceDetailTitleView" owner:nil options:nil] lastObject];
//       // self.center = CGPointMake(self.superview.center.x, self.center.y);
//        
//        DLog(@"%@",NSStringFromCGRect(frame));
//    
//    }
//    return self;
//}



- (void)setTitleWithModel:(PriceMarketModel *)model {
    
    _model = model;

    
    if (model.shortName.length != 0) {
        self.codeNameFromLabel.text = [NSString stringWithFormat:@"%@ %@",model.name,model.shortName];
    } else {
        self.codeNameFromLabel.text = model.name;
    }
  
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.codeNameFromLabel.text];
    if (model.shortName.length != 0) {
        [att addAttributes:@{NSForegroundColorAttributeName:GXRGBColor(120, 126, 156) ,NSFontAttributeName:GXFONT_PingFangSC_Light(12)} range:NSMakeRange(model.name.length, self.codeNameFromLabel.text.length - model.name.length)];
    }
    self.codeNameFromLabel.attributedText = att;
    
    self.statusLabel.text = model.status;
    self.timeLabel.text = model.quoteTime;
}

@end

//
//  GXPriceListAddCodeTableViewCell.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/16.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceListAddCodeTableViewCell.h"

@implementation GXPriceListAddCodeTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeArrowWithUp:(BOOL)up
{
    [UIView animateWithDuration:0.2 animations:^{
        if(!up)
        {
            [self.titBtn.imageView setTransform:CGAffineTransformMakeRotation(2*M_PI)];
        }else
        {
            [self.titBtn.imageView setTransform:CGAffineTransformMakeRotation(M_PI-0.001)];
        }
    }];
}

- (IBAction)btn_addClick:(id)sender {
    [delegate btnAddClick:sender];
}
@end

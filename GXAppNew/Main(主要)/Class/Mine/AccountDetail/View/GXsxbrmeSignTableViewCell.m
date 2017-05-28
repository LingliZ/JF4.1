//
//  GXsxbrmeSignTableViewCell.m
//  GXAppNew
//
//  Created by shenqilong on 17/2/10.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXsxbrmeSignTableViewCell.h"

@implementation GXsxbrmeSignTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bankName.font=GXFONT_PingFangSC_Regular(15);
    self.bankName.textColor=RGBACOLOR(0, 0, 0, 1);
    
    self.bankNameText.font=GXFONT_PingFangSC_Regular(13);
    self.bankNameText.textColor=RGBACOLOR(161, 166, 187, 1);
    
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height-1, GXScreenWidth, 0.5)];
    line.backgroundColor=RGBACOLOR(200, 199, 204, 1);
    [self.contentView addSubview:line];
    
    
    self.bankImgSelect=[[UIImageView alloc]initWithFrame:CGRectMake(73, 7.5, GXScreenWidth/2.0-30, 30)];
    [self.contentView addSubview:self.bankImgSelect];
}


- (void)changeArrowWithUp:(BOOL)up
{
    [UIView animateWithDuration:0.2 animations:^{
        if(!up)
        {
            [self.bankNameArrow setTransform:CGAffineTransformMakeRotation(0)];
        }else
        {
            [self.bankNameArrow setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

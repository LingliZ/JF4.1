//
//  GXHelpDetaiSectionlHeaderView.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/17.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXHelpDetaiSectionlHeaderView.h"

@implementation GXHelpDetaiSectionlHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setModel:(GXMineBaseModel *)model
{
    GXHelpModel*helpModel=(GXHelpModel*)model;
    if(helpModel.isSelected)
    {
        self.img_direction.image=[UIImage imageNamed:@"mine_up"];
    }
    else
    {
        self.img_direction.image=[UIImage imageNamed:@"mine_down"];
    }
    self.label_content.text=helpModel.title;
}
- (IBAction)btnClick:(UIButton *)sender {
    [self.delegate helpSectionHeaderViewDidClickWithSection:self.section];
}


@end

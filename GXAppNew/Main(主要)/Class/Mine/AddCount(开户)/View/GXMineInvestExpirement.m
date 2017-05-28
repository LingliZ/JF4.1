//
//  GXMineInvestExpirement.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineInvestExpirement.h"

@implementation GXMineInvestExpirement

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self createUI];

}
-(void)createUI
{
    for(UIButton*btn in self.view_btns.subviews)
    {
        if([btn isKindOfClass:[UIButton class]])
        {
            [UIView setBorForView:btn withWidth:1 andColor:[UIColor lightGrayColor] andCorner:0];
            [btn setBackgroundImage:ImageFromHex(@"4082F4") forState:UIControlStateSelected];
        }
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    for(UIButton*btn in self.view_btns.subviews)
    {
        if([btn isKindOfClass:[UIButton class]])
        {
            btn.selected=NO;
        }
        if(btn.tag==sender.tag)
        {
            btn.selected=YES;
        }
    }
    [self.delegate selectInvestYearsWithTag:sender.tag andIndexPath:self.indexPath];
}
-(void)setModel:(GXMineBaseModel *)model
{
    GXMineInvestYearsModel*model_year=(GXMineInvestYearsModel*)model;
    self.label_title.text=model_year.value;
    for(UIButton*btn in self.view_btns.subviews)
    {
        if([btn isKindOfClass:[UIButton class]])
        {
            btn.selected=NO;
        }
        if(btn.tag==model_year.selectedBtn)
        {
            btn.selected=YES;
        }
    }
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
@end

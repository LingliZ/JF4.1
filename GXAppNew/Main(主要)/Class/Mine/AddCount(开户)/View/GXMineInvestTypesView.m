//
//  GXMineInvestTypesView.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineInvestTypesView.h"

@implementation GXMineInvestTypesView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self createUI];
}
-(void)createUI
{
    for(UIButton*btn in self.subviews)
    {
        if([btn isKindOfClass:[UIButton class]])
        {
            [UIView setBorForView:btn withWidth:1 andColor:[UIColor lightGrayColor] andCorner:0];
            [btn setBackgroundImage:ImageFromHex(@"4184F4") forState:UIControlStateSelected];
        }
    }
}
-(void)setModelsWithModelsArray:(NSMutableArray *)modelArray
{
    for(UIButton*btn in self.subviews)
    {
        if([btn isKindOfClass:[UIButton class]])
        {
            btn.hidden=NO;
            if(btn.tag>=modelArray.count)
            {
                btn.hidden=YES;
                continue;
            }
            if(btn.tag<modelArray.count)
            {
                GXMineInvestTypeModel*model=modelArray[btn.tag];
                [btn setTitle:model.value forState:UIControlStateNormal];
            }
        }
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    sender.selected=!sender.selected;
    [self.deleagte selectInvestTypeWithValue:sender.selected andTag:sender.tag];
}


@end

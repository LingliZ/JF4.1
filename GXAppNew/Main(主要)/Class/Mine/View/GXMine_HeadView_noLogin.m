//
//  GXMine_HeadView_noLogin.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMine_HeadView_noLogin.h"

@implementation GXMine_HeadView_noLogin

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
//    [UIView setBorForView:self.btn_login withWidth:1 andColor:[UIColor whiteColor] andCorner:5];
    
}
-(void)setModel:(GXMineBaseModel *)model
{
    
}
- (IBAction)btnClick:(UIButton *)sender {
//    [self.delegate toLogin];
    self.toLogin();
}

@end

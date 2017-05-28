//
//  GXMineBankCell.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBankCell.h"

@implementation GXMineBankCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self createUI];
}
-(void)createUI
{
    
//    UIBezierPath*maskeParh=[UIBezierPath bezierPathWithRoundedRect:self.view_bottom.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
//    
//    CAShapeLayer*maskLayer=[[CAShapeLayer alloc]init];
//    maskLayer.frame=self.view_bottom.bounds;
//    maskLayer.path=maskeParh.CGPath;
//    self.view_bottom.layer.mask=maskLayer;
//    [UIView setBorForView:self.view_bottom withWidth:0 andColor:nil andCorner:5];

    self.view_bottom.layer.cornerRadius=10.0;
    [UIView setBorForView:self.img_logo withWidth:0 andColor:nil andCorner:17.5];
//    self.view_bottom.backgroundColor=[UIColor orangeColor];
    self.view_bottom.layer.shadowColor=[UIColor blackColor].CGColor;
    self.view_bottom.layer.shadowOffset=CGSizeMake(0, -1.0f);
    self.view_bottom.layer.shadowOpacity=0.1;
    self.view_bottom.layer.shadowRadius=3.0;
    self.clipsToBounds=YES;
    
    
}
-(void)setModel:(GXMineBaseModel *)model
{
    GXMineBankModel*bankModel=(GXMineBankModel*)model;
    [self.img_logo sd_setImageWithURL:[NSURL URLWithString:bankModel.imageUrl]];
    self.label_bankName.text=bankModel.name;
    self.label_bankType.text=bankModel.contract;
}
@end




























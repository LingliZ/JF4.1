//
//  GXHelpDetailCell.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/17.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXHelpDetailCell.h"

@implementation GXHelpDetailCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor=[UIColor getColor:@"EFEFF4"];
}
-(void)setModel:(GXMineBaseModel *)model
{
    GXHelpModel*helpModel=(GXHelpModel*)model;
    if(helpModel.certificatePic.length)
    {
        self.img_certificate.hidden=NO;
        self.img_certificate.image=[UIImage imageNamed:helpModel.certificatePic];
    }
    else
    {
        self.img_certificate.hidden=YES;
    }
    self.label_content.text=helpModel.content;
}
@end

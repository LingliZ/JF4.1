//
//  GXCustomerInfoCell.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXCustomerInfoCell.h"

@implementation GXCustomerInfoCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [GXNotificationCenter addObserver:self selector:@selector(portraitDidUpload:) name:Mine_Notify_portraitUploadSuccessed object:nil];
    [UIView setBorForView:self.img_portrait withWidth:0 andColor:nil andCorner:26.5];
}

-(void)setModel:(GXMineBaseModel *)model
{
    GXCustomerInfoCellModel*infoModel=(GXCustomerInfoCellModel*)model;
//    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if(self.indexPath.section==0&&self.indexPath.row==0)
    {
        self.label_content.hidden=YES;
        self.img_portrait.hidden=NO;
    }
    else
    {
        self.label_content.hidden=NO;
        self.img_portrait.hidden=YES;
    }
    
    self.label_title.text=infoModel.title;
    self.label_content.text=infoModel.content;
    [self.img_portrait sd_setImageWithURL:[NSURL URLWithString:infoModel.avatar] placeholderImage:[UIImage imageNamed:@"mine_head_placeholder"]];
}
-(void)portraitDidUpload:(NSNotification*)sender
{
    self.img_portrait.image=[UIImage imageWithData:sender.userInfo[@"img"]];
}
@end

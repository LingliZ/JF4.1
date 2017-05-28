//
//  GXSetCell.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXSetCell.h"

@implementation GXSetCell

-(void)setModel:(GXMineBaseModel *)model
{
    GXSetModel*setModel=(GXSetModel*)model;
    self.label_title.text=setModel.title;
    if(!(self.indexPath.section==1&&self.indexPath.row==2))
    {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        self.label_content.hidden=NO;
        self.label_content.text=[NSString stringWithFormat:@"%@ M",setModel.content];
    }
}
@end

//
//  GXPushSetCell.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXPushSetCell.h"

@implementation GXPushSetCell

-(void)setModel:(GXMineBaseModel *)model
{
    GXPushSetModel*setModel=(GXPushSetModel*)model;
    self.label_title.text=setModel.title;
    self.switch_select.on=setModel.isOpened;
}

- (IBAction)switchClick:(UISwitch *)sender {
    switch (self.indexPath.row) {
        case 0:
        {
            //即时建议
            [GXUserdefult setBool:sender.on forKey:IsReceiveAdviceMsg];
            [self.delegate pushCellDidSwitchWithIndePatchx:self.indexPath andValue:sender.on];
            break;
        }
        case 1:
        {
            //顾问回复
            [GXUserdefult setBool:sender.on forKey:IsReceiveReplayMsg];
            [self.delegate pushCellDidSwitchWithIndePatchx:self.indexPath andValue:sender.on];
            break;
        }
        case 2:
        {
            //国鑫消息
            [GXUserdefult setBool:sender.on forKey:IsRecieveGuoXinMsg];
            [self.delegate pushCellDidSwitchWithIndePatchx:self.indexPath andValue:sender.on];
            break;
        }
        case 3:
        {
            //报价提醒
            [GXUserdefult setBool:sender.on forKey:IsReceivePriceWarnMsg];
            [self.delegate pushCellDidSwitchWithIndePatchx:self.indexPath andValue:sender.on];
            break;
        }
            default:
            break;
    }
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
}
@end

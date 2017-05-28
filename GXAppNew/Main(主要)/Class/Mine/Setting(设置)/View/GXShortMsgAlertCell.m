//
//  GXShortMsgAlertCell.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/14.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXShortMsgAlertCell.h"

@implementation GXShortMsgAlertCell

-(void)setModel:(GXMineBaseModel *)model
{
    GXPushSetModel*setModel=(GXPushSetModel*)model;
    self.label_title.text=setModel.title;
    self.switch_select.on=setModel.isOpened;
}
- (IBAction)switchClick:(UISwitch *)sender {
    if(self.indexPath.row==0)
    {
        //短信提示新即时建议
        [GXUserdefult setBool:sender.on forKey:IsRecieveShortMsg_Suggestion];
        [GXUserdefult synchronize];
    }
    if(self.indexPath.row==1)
    {
        //短信提示新报价提醒
        [GXUserdefult setBool:sender.on forKey:IsRecieveShortMsg_Price];
        [GXUserdefult synchronize];
    }
    [self.delegate shortMsgSwitchValueChangedWithValue:sender.on andIndexPath:self.indexPath];
}

@end

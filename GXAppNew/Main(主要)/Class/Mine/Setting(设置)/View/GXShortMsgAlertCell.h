//
//  GXShortMsgAlertCell.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/14.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseCell.h"
#import "GXPushSetModel.h"

@protocol GXShortMsgAlertCellDelegate <NSObject>

-(void)shortMsgSwitchValueChangedWithValue:(BOOL)value andIndexPath:(NSIndexPath*)indexPath;

@end
@interface GXShortMsgAlertCell : GXMineBaseCell
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UISwitch *switch_select;
@property(weak,nonatomic)id<GXShortMsgAlertCellDelegate>delegate;


@end

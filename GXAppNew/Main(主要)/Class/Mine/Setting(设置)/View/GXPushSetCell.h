//
//  GXPushSetCell.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseCell.h"
#import "GXPushSetModel.h"

@protocol GXPushSetCellDelegate <NSObject>

-(void)pushCellDidSwitchWithIndePatchx:(NSIndexPath*)indexPatch andValue:(BOOL)value;

@end

@interface GXPushSetCell : GXMineBaseCell
@property(weak,nonatomic)id<GXPushSetCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UISwitch *switch_select
;

@end

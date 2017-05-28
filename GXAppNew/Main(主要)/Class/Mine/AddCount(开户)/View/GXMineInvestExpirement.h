//
//  GXMineInvestExpirement.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseCell.h"
#import "GXMineInvestYearsModel.h"

@protocol GXMineInvestExpirementCellDelegate <NSObject>

-(void)selectInvestYearsWithTag:(NSInteger)tag andIndexPath:(NSIndexPath*)indexPath;

@end
@interface GXMineInvestExpirement : GXMineBaseCell
@property (weak, nonatomic) IBOutlet UIView *view_btns;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property(nonatomic,weak)id<GXMineInvestExpirementCellDelegate>delegate;


@end

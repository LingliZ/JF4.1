//
//  GXAddAccountListCell.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/20.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseCell.h"
#import "GXAddAccountListModel.h"

@protocol GXAddAccountListCellDelegate <NSObject>

-(void)addAccountCellBtnDidTouchedWith:(NSIndexPath*)indexPatch;

@end
@interface GXAddAccountListCell : GXMineBaseCell
@property (weak, nonatomic) IBOutlet UIView *view_bottom;
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;

@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (weak, nonatomic) IBOutlet UILabel *label_des;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;
@property(nonatomic,weak)id<GXAddAccountListCellDelegate>delegate;


@end

//
//  GXMine_HomeCell.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseCell.h"
#import "GXmine_HomeModel.h"

@protocol GXMine_HomeCellDelegate <NSObject>

-(void)addCountBtnDidSelectedWithIndexPath:(NSIndexPath*)indexPath;

@end
@interface GXMine_HomeCell : GXMineBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *img_mark;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_account;
@property (weak, nonatomic) IBOutlet UIImageView *img_next;
@property (weak, nonatomic) IBOutlet UIButton *btn_addAcount;

@property(nonatomic,weak)id<GXMine_HomeCellDelegate>delegate;
@end

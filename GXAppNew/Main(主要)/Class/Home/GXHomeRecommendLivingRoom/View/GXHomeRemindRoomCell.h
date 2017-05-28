//
//  GXHomeRemindRoomCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXHomeRemindRoomModel.h"

@interface GXHomeRemindRoomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (nonatomic,strong)GXHomeRemindRoomModel *model;

@end

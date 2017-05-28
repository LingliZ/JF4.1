//
//  GXMineBankCell.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseCell.h"
#import "GXMineBankModel.h"
@interface GXMineBankCell : GXMineBaseCell

@property (weak, nonatomic) IBOutlet UIView *view_bottom;
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;
@property (weak, nonatomic) IBOutlet UILabel *label_bankName;
@property (weak, nonatomic) IBOutlet UILabel *label_bankType;

@end

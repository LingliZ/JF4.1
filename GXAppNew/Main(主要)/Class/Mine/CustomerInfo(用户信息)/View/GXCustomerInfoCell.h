//
//  GXCustomerInfoCell.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseCell.h"
#import "GXCustomerInfoCellModel.h"
@interface GXCustomerInfoCell : GXMineBaseCell
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (weak, nonatomic) IBOutlet UIImageView *img_portrait;
@property (weak, nonatomic) IBOutlet UIImageView *img_next;

@end

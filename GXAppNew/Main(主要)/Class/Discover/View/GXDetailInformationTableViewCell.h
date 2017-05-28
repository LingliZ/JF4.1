//
//  GXDetailInformationTableViewCell.h
//  GXAppNew
//
//  Created by shenqilong on 17/1/4.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXInformationModel.h"

@interface GXDetailInformationTableViewCell : UITableViewCell
@property (nonatomic,strong)GXInformationModel *model;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end

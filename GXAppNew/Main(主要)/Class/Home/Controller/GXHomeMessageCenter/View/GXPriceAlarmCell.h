//
//  GXPriceAlarmCell.h
//  GXApp
//
//  Created by 王淼 on 16/8/12.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXPriceAlertModel.h"

@class GXPriceAlertModel;
@interface GXPriceAlarmCell : UITableViewCell
{
    UILabel * codeLabel;        //描述
    UILabel * timeLabel;        //时间
}
@property (nonatomic,strong) GXPriceAlertModel *alartModel;

@end

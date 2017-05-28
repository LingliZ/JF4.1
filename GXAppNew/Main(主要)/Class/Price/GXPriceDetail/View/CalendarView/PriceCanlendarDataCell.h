//
//  PriceCanlendarDataCell.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceCanlendarBaseCell.h"
#import "PriceCalendarDataModel.h"
#import "StarRateView.h"


@interface PriceCanlendarDataCell : PriceCanlendarBaseCell

@property (nonatomic, strong) PriceCalendarDataModel *model;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *frontValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *foreCastLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, weak)  StarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UILabel *resLabel;


@end

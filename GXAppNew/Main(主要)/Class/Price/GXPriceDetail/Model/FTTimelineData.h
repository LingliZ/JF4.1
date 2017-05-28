//
//  FTTimelineData.h
//  ChartDemo
//
//  Created by futang yang on 2016/9/29.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTTimeLineEntity.h"



@interface FTTimelineData : NSObject

@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *lastclose;
@property (nonatomic, assign) long long openTime;
@property (nonatomic, strong) NSArray *timeLineItemList;
@property (nonatomic, copy) NSString *tradeDate;

@end

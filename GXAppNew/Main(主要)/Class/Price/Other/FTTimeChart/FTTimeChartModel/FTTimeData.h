//
//  FTTimeData.h
//  ChartDemo
//
//  Created by futang yang on 2016/9/29.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTTimeData : NSObject


@property (nonatomic, strong) NSMutableArray *context;
@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, copy) NSString *maxValue;
@property (nonatomic, copy) NSString *minValue;
@property (nonatomic, copy) NSString *lastClose;


@end

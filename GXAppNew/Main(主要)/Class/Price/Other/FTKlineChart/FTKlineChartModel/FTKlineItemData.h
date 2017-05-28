//
//  FTKlineItemData.h
//  ChartDemo
//
//  Created by futang yang on 2016/10/18.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTKlineItemData : NSObject



@property (nonatomic, strong) NSArray *context;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSArray *lineContexts;
@property (nonatomic, strong) NSArray *indexContexts;


@property (nonatomic, assign) float maxHighValue;
@property (nonatomic, assign) float minLowValue;
@property (nonatomic, assign) float maxVolValue;
@property (nonatomic, assign) float minVolValue;
@property (nonatomic, assign) float maxMacdValue;
@property (nonatomic, assign) float minMacdValue;






@end

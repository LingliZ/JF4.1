//
//  FTMaParam.h
//  ChartDemo
//
//  Created by futang yang on 2016/12/22.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ta_libc.h"
#import "MJExtension.h"


typedef NS_ENUM(NSInteger, SMADataType) {
    OPEN,
    HIGH,
    LOW,
    CLOSE
};






@interface FTMaParam : NSObject<NSCoding>

/**
 *  MA基准值
 */
@property(assign, nonatomic) SMADataType smaDataType;

/**
 *  线性选择：TA_MAType_SMA=0 算数平均,TA_MAType_EMA=1,线性加权 TA_MAType_WMA=2, 指数加权 TA_MAType_TRIMA=5 三角
 */
@property(assign, nonatomic) TA_MAType type;

/**
 *  周期
 */
@property(assign, nonatomic) int period;

/**
 *  tag
 */
@property(assign, nonatomic) int tag;


@end

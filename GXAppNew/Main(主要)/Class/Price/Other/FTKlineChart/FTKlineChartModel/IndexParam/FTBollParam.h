//
//  FTBollParam.h
//  ChartDemo
//
//  Created by futang yang on 2016/12/22.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTIndexBaseParam.h"

@interface FTBollParam : FTIndexBaseParam

// 偏差
@property (nonatomic, assign) int deviation;
// 时间周期
@property (nonatomic, assign) int period;


@end

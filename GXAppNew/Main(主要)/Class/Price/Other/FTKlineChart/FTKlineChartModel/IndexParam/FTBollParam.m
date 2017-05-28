//
//  FTBollParam.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/22.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "FTBollParam.h"

@implementation FTBollParam

- (NSString *)displayName {
    return  [NSString stringWithFormat:@"%@(%d,%d)",self.indexName,self.period,self.deviation];
}

- (NSString *)indexName {
    return @"BOLL";
}


@end

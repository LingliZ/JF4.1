//
//  PriceSetIndexModel.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/21.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceSetIndexModel.h"

@implementation PriceSetIndexModel

- (NSString *)rightTitle {
    if (_startIndex && _endIndex) {
        return [NSString stringWithFormat:@"注:参数范围%ld~%ld",_startIndex,_endIndex];
    }
    return @"";
}

@end

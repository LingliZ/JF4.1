//
//  FTLineData.m
//  ChartDemo
//
//  Created by futang yang on 2016/10/24.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "FTLineData.h"

@implementation FTLineData



@synthesize value = _value;
@synthesize date = _date;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithValue:(float)value date:(NSString *)date {
    self = [self init];
    
    if (self) {
        self.value = value;
        self.date = date;
    }
    return self;
}


@end

//
//  GXPriceRemindParam.m
//  GXApp
//
//  Created by futang yang on 16/7/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXPriceRemindParam.h"

@implementation GXPriceRemindParam

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"upperOn",@"lowerOn"];
}


- (NSString *)upperBound {
    if (self.upperOn && [_upperBound integerValue] > 0) {
        return _upperBound;
    }
    return nil;
}


- (NSString *)lowerBound {
    if (self.lowerOn && [_lowerBound integerValue] > 0) {
        return _lowerBound;
    }
    return nil;
}






@end

//
//  GXPriceRemindModel.m
//  GXApp
//
//  Created by futang yang on 16/7/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXPriceRemindModel.h"

@implementation GXPriceRemindModel

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"upperOn",@"lowerOn"];
}

//- (NSString *)upperBoundValue {
//    if (self.upperOn) {
//        return _upperBoundValue;
//    }
//    return nil;
//}
//
//
//- (NSString *)lowerBound {
//    if (self.lowerOn) {
//        return _lowerBound;
//    }
//    return nil;
//}
@end

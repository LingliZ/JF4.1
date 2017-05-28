//
//  GXAirAdModel.m
//  GXApp
//
//  Created by 王振 on 16/8/20.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXAirAdModel.h"

@implementation GXAirAdModel
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}



-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

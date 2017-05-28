//
//  PricePlatformModel.m
//  GXApp
//
//  Created by yangfutang on 16/5/19.
//  Copyright © 2016年 yangfutang. All rights reserved.


#import "PricePlatformModel.h"
#import "PriceProductModel.h"
#import "MJExtension.h"



@implementation PricePlatformModel


// 归档
MJExtensionCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"tradeInfoList":[PriceProductModel class]};
}

-(NSString *)exname_custom
{
    if([[_excode lowercaseString]isEqualToString:@"qilu"])
    {
        return @"齐鲁商品交易中心";
    }else if([[_excode lowercaseString]isEqualToString:@"tjpmev3"])
    {
        return @"天津贵金属交易所";
    }else if([[_excode lowercaseString]isEqualToString:@"shqh"])
    {
        return @"上海期货交易所";
    }else if([[_excode lowercaseString]isEqualToString:@"sge"])
    {
        return @"上海黄金交易所";
    }
    
    return _exname;
}



@end

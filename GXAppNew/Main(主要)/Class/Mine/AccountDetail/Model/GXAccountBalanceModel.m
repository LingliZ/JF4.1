//
//  GXAccountBalanceModel.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAccountBalanceModel.h"

@implementation GXAccountBalanceModel
-(NSString *)equities
{
    return [self setfloat:_equities];
}
-(NSString *)holdPl
{
    return [self setfloat:_holdPl];
}
-(NSString *)riskRate_lb
{
    if([_riskRate floatValue]>=1.2)
    {
        return @"安全";
    }
    return [NSString stringWithFormat:@"%.2f%%",[_riskRate floatValue]*100];
}



-(NSString *)setfloat:(NSString *)str
{
    return [NSString stringWithFormat:@"%.2f",[str floatValue]];
}
@end

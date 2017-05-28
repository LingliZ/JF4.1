//
//  GXTimeDisposeTool.m
//  GXAppNew
//
//  Created by maliang on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXTimeDisposeTool.h"

@implementation GXTimeDisposeTool

+ (NSString *)compareNowTime:(NSDate *)compareDate
{
    
    
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"不足1小时"];
    }
    else if ((temp = timeInterval / 60) < 60) {
        result = [NSString stringWithFormat:@"不足1小时"];
    }
    else if ((temp = temp / 60) <= 24){
        result = [NSString stringWithFormat:@"%ld小时",temp];
    }
    // 大于24小时并且小于一个月的
    else if(temp > 24 && temp < 365 * 24){
        long day = temp/24;
        long hours = temp - day * 24;
        result = [NSString stringWithFormat:@"%ld天%ld小时",day,hours];
    }
    return  result;
}

+ (NSString *)compareNowTime:(NSDate *)compareDate startDate:(NSDate *)startDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceDate:startDate];
    
    long temp = 0;
    NSString *result;
    
    
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"不足1小时"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"不足1小时"];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时",temp];
    }
    // 大于24小时并且小于一个月的
    else if(temp > 24 && temp < 365 * 24){
        long day = temp/24;
        long hours = temp - day * 24;
        result = [NSString stringWithFormat:@"%ld天%ld小时",day,hours];
    }
    return result;
}

@end

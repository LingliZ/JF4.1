//
//  GXLiveTimeTool.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/22.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLiveTimeTool.h"
#import "NSDateFormatter+GXDateFormatter.h"

@implementation GXLiveTimeTool

+ (NSString *)getTimeString: (NSString *)timeString{
    NSDateFormatter *dateFor = [NSDateFormatter shareFormatter];
    dateFor.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFor dateFromString:timeString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL isToday = [calendar isDateInToday:date];
    BOOL isYesterday = [calendar isDateInYesterday:date];
    if (isToday) {
        dateFor.dateFormat = @"今天 HH:mm";
    }else if (isYesterday){
        dateFor.dateFormat = @"昨天 HH:mm";
    }else{
        dateFor.dateFormat = @"MM月dd日 HH:mm";
    }
    return [dateFor stringFromDate:date];
}

+ (NSString *)changeTimeString: (NSString *)timeString
{
    NSDateFormatter *formatter = [NSDateFormatter shareFormatter];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:timeString];
    formatter.dateFormat = @"今天 HH:mm";
    return [formatter stringFromDate:date];
}

@end

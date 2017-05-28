//
//  GXGetCurrentWeekDay.m
//  GXApp
//
//  Created by zhudong on 16/8/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXGetCurrentWeekDay.h"
#import "NSDateFormatter+GXDateFormatter.h"

@implementation GXGetCurrentWeekDay
+ (instancetype)shareWeekDay{
    static GXGetCurrentWeekDay *shareWeekDay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareWeekDay = [[self alloc] init];
    });
    return shareWeekDay;
}

- (NSInteger)getCurrentWeek{
    NSCalendar *calendarOne = [NSCalendar currentCalendar];
    NSInteger weekDay = [calendarOne component:NSCalendarUnitWeekday fromDate:[NSDate date]];
    return weekDay;
}

- (NSInteger)getWeek: (NSString *)timStr{
    NSDateFormatter *formatter = [NSDateFormatter shareFormatter];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:timStr];
    NSCalendar *calendarOne = [NSCalendar currentCalendar];
    NSInteger weekDay = [calendarOne component:NSCalendarUnitWeekday fromDate:date];
    NSArray *week = @[@7,@1,@2,@3,@4,@5,@6];
    return [week[(weekDay - 1)] integerValue];
}

@end

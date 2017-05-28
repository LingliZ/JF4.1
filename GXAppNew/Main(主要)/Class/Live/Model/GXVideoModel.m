//
//  GXVideoModel.m
//  GXAppNew
//
//  Created by maliang on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXVideoModel.h"
#import "NSDateFormatter+GXDateFormatter.h"

@implementation GXVideoModel

//保护方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.id = value;
    }
}

- (void)setImageUrlApp:(NSString *)ImageUrlApp{
    _imageUrlApp = ImageUrlApp;
    if (ImageUrlApp.length > 0) {
        self.imageUrl = [NSString stringWithFormat:@"http://image.91test-cloud.bj%@",ImageUrlApp];
    }
}

- (void)setCurrentCourse:(NSDictionary *)currentCourse{
    _currentCourse = currentCourse;
    NSString *sTime = currentCourse[@"stime"];
    NSString *eTime = currentCourse[@"etime"];
    self.timeStr = [NSString stringWithFormat:@"%@-%@", sTime, eTime];
    self.nameStr = currentCourse[@"name"];
    NSDateFormatter *dateF = [NSDateFormatter shareFormatter];
    dateF.dateFormat = @"HH:mm";
    NSDate *sDate = [dateF dateFromString:sTime];
    NSDate *eDate = [dateF dateFromString:eTime];

    NSDate *cDate = [NSDate date];
    dateF.dateFormat = @"HH:mm";
    NSString *dateStr = [dateF stringFromDate:cDate];
    NSDate *realCDate = [dateF dateFromString:dateStr];
    
    NSTimeInterval sRes = [realCDate timeIntervalSinceDate:sDate];
    NSTimeInterval eRes = [realCDate timeIntervalSinceDate:eDate];
    
    if (sRes > 0 && eRes < 0) {
        self.isPlaying = true;
    }else{
        self.isPlaying = false;
    }
}

@end

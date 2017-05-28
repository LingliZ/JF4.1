//
//  GXGetCurrentWeekDay.h
//  GXApp
//
//  Created by zhudong on 16/8/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXGetCurrentWeekDay : NSObject
+ (instancetype)shareWeekDay;
- (NSInteger)getCurrentWeek;
- (NSInteger)getWeek: (NSString *)timeStr;
@end

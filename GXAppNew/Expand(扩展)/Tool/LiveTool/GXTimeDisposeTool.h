//
//  GXTimeDisposeTool.h
//  GXAppNew
//
//  Created by maliang on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXTimeDisposeTool : NSObject

+ (NSString *)compareNowTime:(NSDate *)compareDate;

+ (NSString *)compareNowTime:(NSDate *)compareDate startDate:(NSDate *)startDate;

@end

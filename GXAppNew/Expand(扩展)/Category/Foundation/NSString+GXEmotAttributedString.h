//
//  NSString+GXEmotAttributedString.h
//  GXApp
//
//  Created by zhudong on 16/8/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PushWebVCNotify @"PushWebVCNotify"

@interface NSString (GXEmotAttributedString)
+ (NSAttributedString *)dealContentText:(NSString *)questionContent;
+ (NSAttributedString *)dealContentText:(NSString *)questionContent withView: (UIView *)view;
@end

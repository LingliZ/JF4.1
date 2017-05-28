//
//  FTLineData.h
//  ChartDemo
//
//  Created by futang yang on 2016/10/24.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTLineData : NSObject {
    float _value;
    NSString *_date;
}

/*!
 Value
 値
 值
 */
@property(assign, nonatomic) float value;

/*!
 Date
 日付
 日期
 */
@property(strong, nonatomic) NSString *date;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIColor *color;

/*!
 @abstract Initialize This Object With Value And Date
 オブジェクトを初期化
 初始化当前对象
 
 @param value Value
 始値
 开盘价
 
 @param date Date
 日付
 日期
 
 @result id Initialized Object
 初期化したオブジェクト
 初期化完成对象
 */
- (id)initWithValue:(float)value date:(NSString *)date;

@end

//
//  FTKlineModel.h
//  ChartDemo
//
//  Created by futang yang on 2016/10/18.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>

//"close": 3785.0,
//"dea": 31.5633,
//"dif": 3.7159,
//"high": 3825.0,
//"low": 3780.0,
//"ma10": 3845.2,
//"ma20": 3996.6499,
//"ma30": 4044.5332,
//"ma5": 3779.2,
//"macd": -55.6948,
//"open": 3781.0,
//"time": 1476309600000


@interface FTKlineModel : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *close;
@property (nonatomic, copy) NSString *open;
@property (nonatomic, assign) float high;
@property (nonatomic, assign) float low;



@property (nonatomic, assign) float macd;
@property (nonatomic, assign) float dea;
@property (nonatomic, assign) float dif;


@end

//
//  PriceSetIndexModel.h
//  ChartDemo
//
//  Created by futang yang on 2016/12/21.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceSetIndexModel : NSObject

@property (nonatomic, copy) NSString *indexName;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger endIndex;
@property (nonatomic, assign) NSInteger period;


@end

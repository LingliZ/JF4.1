//
//  PriceSuggestionModel.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/31.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceSuggestionModel : NSObject

@property (nonatomic, strong) NSNumber *currentPage;
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSArray *resultList;
@property (nonatomic, strong) NSNumber *total;


@end

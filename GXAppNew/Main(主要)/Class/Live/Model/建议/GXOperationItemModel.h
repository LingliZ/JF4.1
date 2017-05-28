//
//  GXOperationItemModel.h
//  GXAppNew
//
//  Created by maliang on 2016/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXOperationItemModel : NSObject

@property(nonatomic, strong) NSString * createdTime;
@property(nonatomic, strong) NSString * positions;
@property(nonatomic, strong) NSDecimalNumber * stopPrice;
@property(nonatomic, strong) NSDecimalNumber * stopPriceOriginal;
@property(nonatomic, strong) NSDecimalNumber * targetPrice;
@property(nonatomic, strong) NSDecimalNumber * targetPriceOriginal;
@property(nonatomic, strong) NSNumber * types;
@property(nonatomic, strong) NSString * directionStr;

@property(nonatomic, strong) NSString * leftStr;
@property(nonatomic, strong) NSString * centerStr;
@property(nonatomic, strong) NSString * rightStr;
@property(nonatomic, assign) BOOL isDouble;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

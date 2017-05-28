//
//  GXExchangeModel.m
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXExchangeModel.h"

@implementation GXExchangeModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.id = dict[@"id"];
        self.idNew = dict[@"newId"];
    }
    return self;
}

+ (instancetype)exchangeModel:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

@end

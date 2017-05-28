//
//  GXNoticeModel.m
//  GXAppNew
//
//  Created by maliang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXNoticeModel.h"

@implementation GXNoticeModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    return  [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end

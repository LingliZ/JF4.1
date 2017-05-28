//
//  GXDiscoverModel.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/9.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXDiscoverModel.h"

@implementation GXDiscoverModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)dicoverWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+ (NSArray *)discoverModels{
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GXDiscoverData.plist" ofType:nil]];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:dictArray.count];
    [dictArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GXDiscoverModel *model = [[GXDiscoverModel alloc] initWithDict:obj];
        [arrM addObject:model];
    }];
    return arrM.copy;
}

@end

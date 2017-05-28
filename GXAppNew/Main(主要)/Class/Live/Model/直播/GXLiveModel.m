//
//  GXLiveModel.m
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLiveModel.h"
#import "NSDateFormatter+GXDateFormatter.h"

@implementation GXLiveModel

- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.idNew = dict[@"newId"];
    }
    return self;
}

+ (instancetype)modelWthDict: (NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setLivePics:(NSString *)livePics
{
    _livePics = livePics;
    
    if (livePics.length>0) {
        NSArray *array = [livePics componentsSeparatedByString:@","];
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imageName = [NSString stringWithFormat:@"%@%@", baseImageUrl, obj];
            [arrM addObject:imageName];
        }];
        self.livePicsArray = arrM;
    }
}

@end

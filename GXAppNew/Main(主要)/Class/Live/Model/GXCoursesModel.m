//
//  GXCoursesModel.m
//  GXApp
//
//  Created by zhudong on 16/7/18.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXCoursesModel.h"

@implementation GXCoursesModel
+ (instancetype)courseWithDict:(NSDictionary *)dict{
    return [[GXCoursesModel alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    [self setValuesForKeysWithDictionary:dict];
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
- (void)setHost:(NSString *)host{
    NSArray *names = [host componentsSeparatedByString:@"|"];
    _host = [names firstObject];
}
- (void)setAnalysts:(NSString *)analysts{
    
    NSArray *names = [analysts componentsSeparatedByString:@","];
    NSMutableArray *arrM = [NSMutableArray array];
    [names enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *subName = [obj componentsSeparatedByString:@"|"].firstObject;
        [arrM addObject:subName];
    }];
    if (arrM.count > 0) {
        self.analystsArray = arrM;
    }
    _analysts = [arrM firstObject];
}
@end

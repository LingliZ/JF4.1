//
//  GXAskModel.m
//  GXAppNew
//
//  Created by maliang on 2016/12/14.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAskModel.h"

@implementation GXAskModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)askModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


- (void)setAskPics:(NSString *)askPics
{
    _askPics = askPics;
    NSArray *array = [askPics componentsSeparatedByString:@","];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length !=0 ) {
            NSString *imageName = [NSString stringWithFormat:@"%@%@",baseImageUrl, obj];
            [arrM addObject:imageName];
        }
    }];
    self.askPicsArray = arrM;
    GXLog(@"askPics ==== %@ self.askPicsArray = %@", askPics, arrM);
}
@end

//
//  GXQAndAModel.m
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXQAndAModel.h"

@implementation GXQAndAModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        
        NSDictionary *subDict = dict;
        NSMutableArray *arrM = [NSMutableArray array];
        
        if (self.askerList.count != 0) {
            [self.askerList enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dictM = [[NSMutableDictionary alloc] initWithDictionary:obj];
                dictM[@"answerPics"] = self.answerPics;
                [arrM addObject:dictM];
            }];
        }else{
            [arrM addObject:subDict];
        }
        
        NSMutableArray *modelArrM = [NSMutableArray arrayWithCapacity:arrM.count];
        for (NSDictionary *dictItem in arrM) {
            [modelArrM addObject:[GXAskModel askModelWithDict:dictItem]];
        }
        self.askerListArray = modelArrM;
        self.idNew = dict[@"newId"];
    }
    return self;
}

+ (instancetype)qAndAModel:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)setAnswerPics:(NSString *)answerPics
{
    _answerPics = answerPics;
    NSArray *array = [answerPics componentsSeparatedByString:@","];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:array.count];
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length != 0) {
            NSString *imageName = [NSString stringWithFormat:@"%@%@",baseImageUrl, obj];
            [arrM addObject:imageName];
        }
    }];
    self.answerPicsArray = arrM;
}

@end

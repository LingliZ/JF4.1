//
//  GXQuestion.m
//  GXApp
//
//  Created by zhudong on 2016/11/2.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXQuestion.h"
#import "NSString+GXTimeString.h"

@implementation GXQuestion
- (instancetype)initWithDict:(NSDictionary* )dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.questionNewId = [dict[@"newId"] integerValue];
        self.id = dict[@"id"];
        self.questionTimeStr = [NSString getTimeString:@"HH:mm" sourceTimeStr: self.createdTime];
    }
    return  self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+ (instancetype)questionWithDict: (NSDictionary *) dict{
    GXQuestion *question = [[self alloc] initWithDict:dict];
    return question;
}
@end

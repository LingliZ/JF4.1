//
//  GXMessagesModel.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMessagesModel.h"
#import "NSString+GXTimeString.h"
#define kMargin WidthScale_IOS6(10)
@implementation GXMessagesModel
+ (instancetype)messageModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        [self dealContent];
    }
    return self;
}
- (void)dealContent{

    self.timeStr = [NSString getTimeString:@"yyyy.MM.dd  HH:mm" sourceTimeStr:self.CreatedTime];
}
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


@end

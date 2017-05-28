//
//  GXInformationModel.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/14.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXInformationModel.h"

@implementation GXInformationModel
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end

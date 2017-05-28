//
//  GXInvestListModel.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/15.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXInvestListModel.h"

@implementation GXInvestListModel
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"description"]) {
        self.descrip = value;
    }
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}



@end

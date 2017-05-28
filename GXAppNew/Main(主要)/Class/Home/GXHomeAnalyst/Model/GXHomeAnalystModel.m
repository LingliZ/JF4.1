//
//  GXHomeAnalystModel.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeAnalystModel.h"

@implementation GXHomeAnalystModel


-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end

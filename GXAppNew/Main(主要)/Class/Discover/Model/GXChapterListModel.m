//
//  GXChapterListModel.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/15.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXChapterListModel.h"

@implementation GXChapterListModel

-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"description"]) {
        self.descrip = value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}



@end

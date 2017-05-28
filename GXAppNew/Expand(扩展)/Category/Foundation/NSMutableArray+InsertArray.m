//
//  NSMutableArray+InsertArray.m
//  GXApp
//
//  Created by 王淼 on 16/7/27.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "NSMutableArray+InsertArray.h"

@implementation NSMutableArray (InsertArray)
- (void)insertArray:(NSArray *)newAdditions atIndex:(int)index
{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for(int i = index;i < newAdditions.count+index;i++)
    {
        [indexes addIndex:i];
    }
    [self insertObjects:newAdditions atIndexes:indexes];
}
@end
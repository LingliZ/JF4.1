//
//  NSMutableArray+InsertArray.h
//  GXApp
//  用于数组合并
//  Created by 王淼 on 16/7/27.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (InsertArray)
- (void)insertArray:(NSArray *)newAdditions atIndex:(int)index;
@end

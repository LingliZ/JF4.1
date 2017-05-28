//
//  FTMaParamArray.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/22.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "FTMaParamArray.h"
#import "FTMaParam.h"

@implementation FTMaParamArray

MJCodingImplementation

- (NSString *)displayName {
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    if (_indexArray.count != 0) {
        
        for (NSInteger i = 0; i < _indexArray.count; i++) {
            FTMaParam *parma = _indexArray[i];
            [tempArray addObject:@(parma.period)];
        }
        
        NSString *str1 = [tempArray componentsJoinedByString:@","];
        
        return [self.indexName stringByAppendingString:[NSString stringWithFormat:@"(%@)",str1]];
    }
    
    return @"";
}


- (NSString *)indexName {
    return @"MA";
}


@end

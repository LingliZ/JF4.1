//
//  GXPriceDetailTool.m
//  GXApp
//
//  Created by futang yang on 16/7/26.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXPriceDetailTool.h"
//#import "PricePopularModel.h"
//#import "PricePopularInfoModel.h"
#import "GXFileTool.h"
@implementation GXPriceDetailTool

+ (void)choosePersonSelectPrice:(BOOL)isSelect Key:(NSString *)code {
    
    NSString *PersonSelectBtnStatusKey = [NSString stringWithFormat:@"PersonSelectBtnStatus%@",code];
    [GXUserdefult setBool:isSelect forKey:PersonSelectBtnStatusKey];
    [GXUserdefult synchronize];
    
    if (isSelect == YES) {
        NSArray *array = [GXUserdefult objectForKey:PersonSelectCodesKey];
        if (array.count == 0) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            [mutableArray addObject:code];
            [GXUserdefult setObject:mutableArray.mutableCopy forKey:PersonSelectCodesKey];
            [GXUserdefult synchronize];
            return;
        }
        
        NSMutableArray *mutableArray = array.mutableCopy;
        [mutableArray addObject:code];
        [GXUserdefult setObject:mutableArray.mutableCopy forKey:PersonSelectCodesKey];
        [GXUserdefult synchronize];

        
    } else if (isSelect == NO) {
        
        NSArray *array = [GXUserdefult objectForKey:PersonSelectCodesKey];
        if (array.count != 0) {
            NSMutableArray *mutableArray = array.mutableCopy;
            [mutableArray removeObject:code];
            [GXUserdefult setObject:mutableArray.mutableCopy forKey:PersonSelectCodesKey];
            [GXUserdefult synchronize];
        }
    }
    
}

+ (BOOL)getPersonSelectBtnIsSelectedWithCode:(NSString *)code {
    
    NSString *PersonSelectBtnStatusKey = [NSString stringWithFormat:@"PersonSelectBtnStatus%@",code];
    return [GXUserdefult boolForKey:PersonSelectBtnStatusKey];
}

+ (BOOL)isKeepAtLeastTwoPersonOptionalsWithSenderSelect:(BOOL)select {
    
    NSArray *array = [GXUserdefult objectForKey:PersonSelectCodesKey];
    NSInteger count = array.count;
    
    // 已经是选中状态
    if (select == YES) {
        if (count <= 2) {
            return NO;
        }
        
        if (count > 2) {
            return YES;
        }
    }

    if (select == NO) {
        
        if (count <= 2) {
            return YES;
        }
        
        if (count > 2) {
            return YES;
        }
    }
    
    return YES;
}

+ (void)PersonSelectAddCode:(NSString *)code {
    
    NSArray *personSelectArray = [GXUserdefult objectForKey:PersonSelectCodesKey];
    NSMutableArray *personTemArray = personSelectArray.mutableCopy;
    [personTemArray addObject:code];
    [GXUserdefult setObject:personTemArray.mutableCopy forKey:PersonSelectCodesKey];
    [GXUserdefult synchronize];
}

+ (NSArray *)retrunPopularSelectList {
    
    NSMutableArray *popularSlectListArray = [GXFileTool readObjectByFileName:GXPopularSelectControllerHotModlesfilePath];
    NSMutableArray *codeArray = [NSMutableArray array];
//    for (PricePopularModel *popularModel in popularSlectListArray) {
//        for (NSInteger i = 0; i < popularModel.tradeInfoList.count; i++) {
//            PricePopularInfoModel *infoModel = popularModel.tradeInfoList[i];
//            [codeArray addObject:infoModel.code];
//        }
//    }
    
    return codeArray;
}


@end

//
//  GXPriceRemindModel.h
//  GXApp
//
//  Created by futang yang on 16/7/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXPriceRemindModel : NSObject

@property (nonatomic, copy) NSString *upperBound;
@property (nonatomic, copy) NSString *lowerBound;
@property (nonatomic, assign) BOOL bySms;


@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL upperOn;
@property (nonatomic, assign) BOOL lowerOn;

@end

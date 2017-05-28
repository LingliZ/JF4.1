//
//  TMBSV3TradingManager.h
//  TMBSV3Trading
//
//  Created by wupeng on 16/5/19.
//  Copyright © 2016年 吴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBSV3TradingManager : NSObject
+(instancetype)shareInstance;
-(void)pushToTradingModule:(id)viewController;
@end

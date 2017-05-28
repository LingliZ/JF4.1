//
//  GXAccountTradeSymbol.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXAccountTradeSymbol : NSObject
@property(nonatomic,copy)NSString *symbolNo;
@property(nonatomic,copy)NSString *localname;
@property(nonatomic,copy)NSString *symbolName;
@property(nonatomic,assign)float factor;
@end

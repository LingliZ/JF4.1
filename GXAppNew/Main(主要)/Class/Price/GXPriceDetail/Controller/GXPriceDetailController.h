//
//  GXPriceDetailController.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceMarketModel.h"
@protocol GXPriceDetailControllerDelegate <NSObject>

-(void)priceDetail_addCodeDone;

@end

@interface GXPriceDetailController : UIViewController

@property (nonatomic, strong) PriceMarketModel *marketModel;
@property(nonatomic,assign)id<GXPriceDetailControllerDelegate>delegate;

@end

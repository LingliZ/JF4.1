//
//  PriceLandscapeController.h
//  GXAppNew
//
//  Created by futang yang on 2017/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXBaseViewController.h"
#import "PriceMarketModel.h"

#define TimeInterval 0.5


@protocol PriceLandscapeControllerDelegate <NSObject>

- (void)LandPriceletReDrawPriceKlineChart;
- (void)LandPriceletReDrawPriceIndexChart;
- (void)LandPriceletMakeChoseKlineTimeChart;

@end


@interface PriceLandscapeController : GXBaseViewController

@property (nonatomic, strong) PriceMarketModel *marketModel;

@property (nonatomic, assign) id<PriceLandscapeControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isFull;


@end

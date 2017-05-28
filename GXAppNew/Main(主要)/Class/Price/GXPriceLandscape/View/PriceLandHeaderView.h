//
//  PriceLandHeaderView.h
//  GXAppNew
//
//  Created by futang yang on 2017/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PriceLandHeaderView, PriceMarketModel;

@protocol PriceLandHeaderViewDelegate <NSObject>

@optional
- (void)PriceLandHeaderViewBack:(PriceLandHeaderView *)headerView;

@end


@interface PriceLandHeaderView : UIView

@property (nonatomic, weak) id <PriceLandHeaderViewDelegate> delegate;
@property (nonatomic, strong)PriceMarketModel *model;


@end

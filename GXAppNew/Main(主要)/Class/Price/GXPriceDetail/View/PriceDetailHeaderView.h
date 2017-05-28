//
//  PriceDetailHeaderView.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceMarketModel;

@interface PriceDetailHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame code:(PriceMarketModel *)model;

- (void)setPriceDetailHeaderView:(PriceMarketModel *)model;

@end

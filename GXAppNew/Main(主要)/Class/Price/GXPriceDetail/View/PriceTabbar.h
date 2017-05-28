//
//  PriceTabbar.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceMarketModel.h"
@class PriceTabbar;

@protocol PriceTabbarDelegate <NSObject>

@optional
- (void)PriceTabbar:(PriceTabbar *)priceTabar ClickOnSelectButton:(UIButton *)SelectButton isSelected:(BOOL)isSelected;
- (void)PriceTabbarClickOnTrade:(PriceTabbar *)priceTabar;
- (void)PriceTabbarClickOnCodeRule:(PriceTabbar *)priceTabar;
- (void)PriceTabbarClickOnCodeRemind:(PriceTabbar *)priceTabar;

@end


@interface PriceTabbar : UIView

@property (nonatomic, assign) id<PriceTabbarDelegate>delegate;

- (void)cofigTabbar:(PriceMarketModel *)model;
- (void)setSelectBtnTitle:(PriceMarketModel *)model;



@end

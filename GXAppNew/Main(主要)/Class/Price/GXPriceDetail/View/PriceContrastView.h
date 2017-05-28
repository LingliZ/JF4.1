//
//  PriceContrastView.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceContrastView;
@protocol PriceContrastViewDelegate <NSObject>

- (void)priceConstrastClickOnSupplementBtn:(PriceContrastView *)view;

@end


@interface PriceContrastView : UIView


@property (nonatomic, assign) id <PriceContrastViewDelegate>delegate;

- (void)setPriceLong:(float)valueLong shortValue:(float)shortValue;

@end

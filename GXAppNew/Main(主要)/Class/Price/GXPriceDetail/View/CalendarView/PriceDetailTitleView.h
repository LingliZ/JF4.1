//
//  PriceDetailTitleView.h
//  GXAppNew
//
//  Created by futang yang on 2017/1/18.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceMarketModel.h"


@interface PriceDetailTitleView : UIView

@property (nonatomic, strong) PriceMarketModel *model;

- (void)setTitleWithModel:(PriceMarketModel *)model;

@end

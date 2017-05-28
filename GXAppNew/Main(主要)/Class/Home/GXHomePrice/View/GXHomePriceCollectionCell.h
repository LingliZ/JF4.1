//
//  GXHomePriceCollectionCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GXHomePriceModel.h"
#import "PriceMarketModel.h"
@interface GXHomePriceCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top1Line1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top1Line2;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *increaseLabel;

@property (nonatomic,strong)PriceMarketModel *model;

@end

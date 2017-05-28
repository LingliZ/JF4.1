//
//  PriceSuggestionCollectionCell.h
//  GXAppNew
//
//  Created by futang yang on 2017/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXSuggestionModel.h"


@interface PriceSuggestionCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *directL;
@property (weak, nonatomic) IBOutlet UILabel *varietyL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *operateL;
@property (weak, nonatomic) IBOutlet UILabel *oTimeL;
@property (weak, nonatomic) IBOutlet UILabel *createNum;
@property (weak, nonatomic) IBOutlet UILabel *fuYingNum;
@property (weak, nonatomic) IBOutlet UILabel *targetNum;
@property (weak, nonatomic) IBOutlet UILabel *stopNum;
@property (weak, nonatomic) IBOutlet UIImageView *leftIconV;
@property (weak, nonatomic) IBOutlet UIImageView *rightIconV;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;


@property(nonatomic, strong) GXSuggestionModel *suggestModel;

@end

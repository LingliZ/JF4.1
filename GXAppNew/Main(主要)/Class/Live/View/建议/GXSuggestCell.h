//
//  GXSuggestCell.h
//  GXAppNew
//
//  Created by maliang on 2016/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXSuggestionModel.h"

@protocol GXSuggestCellDelegate <NSObject>

- (void)turnToSuggestDetailVc:(GXSuggestionModel *)model;

@end

@interface GXSuggestCell : UITableViewCell
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

@property(nonatomic, strong) GXSuggestionModel *suggestModel;

@property(nonatomic, weak) id<GXSuggestCellDelegate>delegate;

@end

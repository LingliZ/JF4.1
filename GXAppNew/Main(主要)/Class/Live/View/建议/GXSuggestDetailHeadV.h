//
//  GXSuggestDetailHeadV.h
//  GXAppNew
//
//  Created by maliang on 2016/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXSuggestionModel.h"

@interface GXSuggestDetailHeadV : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *directeL;
@property (weak, nonatomic) IBOutlet UILabel *varietyL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *operateL;
@property (weak, nonatomic) IBOutlet UILabel *oTimeL;
@property (weak, nonatomic) IBOutlet UILabel *createNum;
@property (weak, nonatomic) IBOutlet UILabel *fuYingNum;
@property (weak, nonatomic) IBOutlet UILabel *targetNum;
@property (weak, nonatomic) IBOutlet UILabel *stopNum;

@property(nonatomic, strong) GXSuggestionModel *suggestModel;


@end

//
//  GXExchangeCell.h
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXExchangeModel.h"
#import <YYText/YYText.h>

@interface GXExchangeCell : UITableViewCell

@property(nonatomic, strong) GXExchangeModel *model;

@property (nonatomic, strong)YYLabel *nameLable;

@end

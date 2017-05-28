//
//  GXPriceListTableViewCell.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/14.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXPriceListTableView,PriceMarketModel,GXPriceListScrollView;
@interface GXPriceListTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(GXPriceListTableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) PriceMarketModel *marketModel;

@property (nonatomic,strong) GXPriceListTableView *gxtableView;
@property (nonatomic,assign) NSInteger indexRow;
@property (nonatomic,strong) GXPriceListScrollView *rightTableScoll;

@end

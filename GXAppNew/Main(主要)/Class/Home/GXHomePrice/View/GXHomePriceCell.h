//
//  GXHomePriceCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GXHomePriceModel.h"
#import "PriceMarketModel.h"
@interface GXHomePriceCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *homePriceCollectionView;
    NSMutableArray *priceArray;
}
@property (nonatomic,strong)PriceMarketModel *model;

@property (nonatomic, weak) NSTimer *timer; // 定时器
@property (nonatomic, assign) BOOL isRefesh; // 是否已经开始请求了
@property (nonatomic, strong) NSMutableArray *priceListArray; // 行情一级数据
@property (nonatomic,copy)void(^didPriceDetailCellBlock)(NSInteger index);
@property (nonatomic,copy)void(^didAddCellBlock)(NSInteger index);

//背景View
@property (nonatomic,strong)UIView *backGroundView;
- (void) initData;
//刷新主页行情刷新
-(void)homePriceReloadData;

- (void)stop;


@end

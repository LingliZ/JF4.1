//
//  GXPriceListTableView.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/13.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXPriceListTableView : UITableView

@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)NSMutableArray *leftTitAr;
@property(nonatomic,strong)NSMutableArray *rightTitAr;

@property (nonatomic,assign) CGPoint titViewScorllp;//存储标题scroll的滚动点


-(void)addLeftTitle:(NSString *)tit width:(NSString * )titWidth;
-(void)addRightTitleAndTitleWidth:(NSString *)obj,...;
@end

//
//  PriceSetIndexParamBaseController.h
//  ChartDemo
//
//  Created by futang yang on 2016/12/23.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceSetIndexParamBaseController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *defaultBtn;

- (void)postRedrawKline:(KLineChartTopType)type;
- (void)postRedrawIndex:(KLineChartBottomType)type;
- (void)saveAction:(UIButton *)btn;

@end

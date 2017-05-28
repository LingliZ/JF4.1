//
//  PriceSetMacdController.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/24.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceSetMacdController.h"
#import "FTIndexParamHeader.h"
#import "PriceSetSectionModel.h"
#import "PriceSetIndexModel.h"
#import "PriceIndexTool.h"
#import "PriceSetIndexCell.h"


@interface PriceSetMacdController ()

@property (nonatomic, strong) FTMacdParam *macdParam;

@end

@implementation PriceSetMacdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.macdParam = [PriceIndexTool GetMacdParam];
    [self configDataWith:self.macdParam];
}

- (void)configDataWith:(FTMacdParam *)macParam {
    
    PriceSetIndexModel *m1 = [[PriceSetIndexModel alloc] init];
    m1.leftTitle = @"短周期";
    m1.period = macParam.shortPeriod;
    m1.startIndex = 5;
    m1.endIndex = 60;
    
    PriceSetIndexModel *m2 = [[PriceSetIndexModel alloc] init];
    m2.leftTitle = @"长周期";
    m2.period = macParam.longPeriod;
    m2.startIndex = 10;
    m2.endIndex = 100;
    
    
    PriceSetSectionModel *section1 = [[PriceSetSectionModel alloc] init];
    section1.headTitle = @"DIFF收盘价短期与长期平滑移动平均差，默认值12、26";
    section1.modelsArray = @[m1,m2];
    
    
    
    PriceSetIndexModel *m3 = [[PriceSetIndexModel alloc] init];
    m3.leftTitle = @"MACD周期";
    m3.period = macParam.macdPeriod;
    m3.startIndex = 2;
    m3.endIndex = 60;
    
    PriceSetSectionModel *section2 = [[PriceSetSectionModel alloc] init];
    section2.headTitle = @"DEA：DIFF的M日平滑移动平均值，默认值9";
    section2.modelsArray = @[m3];
    
    
    self.dataArray = @[section1, section2];
}



- (void)inputChangeCell:(PriceSetIndexCell *)cell textfield:(UITextField *)textfield indexPath:(NSIndexPath *)indexPath {
    
    int number = [textfield.text intValue];
    
    if (number <= cell.model.startIndex) {
        number = (int)cell.model.startIndex;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.macdParam.shortPeriod = number;
        } else if (indexPath.row == 1) {
            self.macdParam.longPeriod = number;
        }
    } else {
        self.macdParam.macdPeriod = number;
    }
    
}


- (void)saveAction:(UIButton *)btn {
    
    [PriceIndexTool SaveMACDparam:self.macdParam];
    [self postRedrawIndex:MACD];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)defaultBtn:(UIButton *)btn {
    
    [PriceIndexTool creatDefaultMacdParam];
    self.macdParam = [PriceIndexTool GetMacdParam];
    [self configDataWith:self.macdParam];
    [self.tableView reloadData];
    [PriceIndexTool SaveMACDparam:self.macdParam];
}





@end

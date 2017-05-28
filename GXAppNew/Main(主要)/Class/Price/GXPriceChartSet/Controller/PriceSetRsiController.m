//
//  PriceSetRsiController.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/24.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceSetRsiController.h"
#import "PriceSetSectionModel.h"
#import "PriceSetIndexModel.h"
#import "FTRsiParam.h"
#import "PriceIndexTool.h"
#import "PriceSetIndexCell.h"



@interface PriceSetRsiController ()

@property (nonatomic, strong) FTRsiParam *rsiParam;

@end

@implementation PriceSetRsiController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.rsiParam = [PriceIndexTool GetRsiParam];
    [self configDataWith:self.rsiParam];

    
}


- (void)configDataWith:(FTRsiParam *)rsiParam {
    
    NSArray *periodArray = @[@(rsiParam.period1),@(rsiParam.period2),@(rsiParam.period3)];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 3; i++) {
        PriceSetIndexModel *model = [[PriceSetIndexModel alloc] init];
        model.leftTitle = [NSString stringWithFormat:@"时间周期%ld",i+1];
        model.period = [periodArray[i] intValue];
        model.startIndex = 2;
        model.endIndex = 100;
        [tempArray addObject:model];
    }
    
    PriceSetSectionModel *section1 = [[PriceSetSectionModel alloc] init];
    section1.headTitle = @"RSI指标默认值6、12、24";
    section1.modelsArray = tempArray;
    
    
    self.dataArray = @[section1];
}


- (void)inputChangeCell:(PriceSetIndexCell *)cell textfield:(UITextField *)textfield indexPath:(NSIndexPath *)indexPath {
    
    int number = [textfield.text intValue];
    
    if (number <= cell.model.startIndex) {
        number = (int)cell.model.startIndex;
    }
    
    if (indexPath.row == 0) {
        self.rsiParam.period1 = number;
    } else if (indexPath.row == 1) {
        self.rsiParam.period2 = number;
    } else {
        self.rsiParam.period3 = number;
    }
    
    
}


- (void)saveAction:(UIButton *)btn {
    
    [PriceIndexTool SaveRSIParam:self.rsiParam];
    [self postRedrawIndex:RSI];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)defaultBtn:(UIButton *)btn {
    
    [PriceIndexTool creatDefaultRsiParam];
    self.rsiParam = [PriceIndexTool GetRsiParam];
    [self configDataWith:self.rsiParam];
    [self.tableView reloadData];
   [PriceIndexTool SaveRSIParam:self.rsiParam];
}




@end

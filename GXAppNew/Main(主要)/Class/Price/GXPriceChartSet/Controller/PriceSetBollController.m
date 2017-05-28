//
//  PriceSetBollController.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/23.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceSetBollController.h"
#import "FTBollParam.h"
#import "PriceIndexTool.h"
#import "PriceSetIndexModel.h"
#import "PriceSetSectionModel.h"
#import "PriceSetIndexCell.h"



@interface PriceSetBollController ()

@property (nonatomic, strong) FTBollParam *bollParam;

@end

@implementation PriceSetBollController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.bollParam = [PriceIndexTool GetBollParam];
    [self configDataWith:self.bollParam];
}

- (void)configDataWith:(FTBollParam *)bollParam {
    
    PriceSetIndexModel *m1 = [[PriceSetIndexModel alloc] init];
    m1.indexName = @"BOLL";
    m1.leftTitle = @"时间周期";
    m1.rightTitle = [NSString stringWithFormat:@"注：参数范围2~100"];
    m1.startIndex = 2;
    m1.endIndex = 100;
    m1.period = bollParam.period;
    
    
    PriceSetIndexModel *m2 = [[PriceSetIndexModel alloc] init];
    m2.indexName = @"BOLL";
    m2.leftTitle = @"偏差";
    m2.rightTitle = [NSString stringWithFormat:@"注：参数范围1~10"];
    m2.startIndex = 1;
    m2.endIndex = 10;
    m2.period = bollParam.deviation;
    
    NSArray *tempArray = @[m1,m2];
    
    PriceSetSectionModel *sectionModel = [[PriceSetSectionModel alloc] init];
    
    sectionModel.headTitle = @"BOLL默认指标20,2";
    sectionModel.modelsArray = tempArray;
    self.dataArray = @[sectionModel];
}

- (void)inputChangeCell:(PriceSetIndexCell *)cell textfield:(UITextField *)textfield indexPath:(NSIndexPath *)indexPath {
    
    int number = [textfield.text intValue];
    
    if (number <= cell.model.startIndex) {
        number = (int)cell.model.startIndex;
    }
    
    if (indexPath.row == 0) {
        self.bollParam.period = number;
    } else if (indexPath.row == 1) {
        self.bollParam.deviation = number;
    }
   
    
}


- (void)saveAction:(UIButton *)btn {
    
    [PriceIndexTool SaveBOLLparam:self.bollParam];
    [self postRedrawKline:BOLL];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)defaultBtn:(UIButton *)btn {
    
    [PriceIndexTool creatDefaultBollParam];
    self.bollParam = [PriceIndexTool GetBollParam];
    [self configDataWith:self.bollParam];
    [self.tableView reloadData];
    [PriceIndexTool SaveBOLLparam:self.bollParam];
}





@end

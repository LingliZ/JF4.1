//
//  PriceSetMAController.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/23.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceSetMAController.h"
#import "FTMaParamArray.h"
#import "PriceSetSectionModel.h"
#import "PriceSetIndexModel.h"
#import "PriceIndexTool.h"
#import "PriceSetIndexCell.h"


@interface PriceSetMAController ()<PriceSetIndexCellDelegate>

@property (nonatomic, strong) FTMaParamArray *maParam;

@end

@implementation PriceSetMAController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maParam = [PriceIndexTool GetMaParamArray];
    
    [self configDataWith:self.maParam];
    
}

- (void)configDataWith:(FTMaParamArray *)maParam {
    
   
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        PriceSetIndexModel *model = [[PriceSetIndexModel alloc] init];
        model.indexName = @"MA";
        model.leftTitle = [NSString stringWithFormat:@"时间周期%ld",i+1];
        model.rightTitle = [NSString stringWithFormat:@"注：参数范围2~100"];
        model.startIndex = 2;
        model.endIndex = 100;
        model.period = [(FTMaParam *)maParam.indexArray[i] period];
        [tempArray addObject:model];
    }
    
    
    
    PriceSetSectionModel *sectionModel = [[PriceSetSectionModel alloc] init];
    
    sectionModel.headTitle = @"MA默认指标5 10 15";
    sectionModel.modelsArray = tempArray;
    self.dataArray = @[sectionModel];
}


- (void)inputChangeCell:(PriceSetIndexCell *)cell textfield:(UITextField *)textfield indexPath:(NSIndexPath *)indexPath {
    

    NSString *str = textfield.text;
    
    if ([str integerValue] <= cell.model.startIndex) {
        str = [NSString stringWithFormat:@"%ld",cell.model.startIndex];
    }
    
    FTMaParam *parma = self.maParam.indexArray[indexPath.row];
    parma.period = [str intValue];

}


- (void)saveAction:(UIButton *)btn {
    
    [super saveAction:btn];
    
    [PriceIndexTool SaveMAparamArray:self.maParam];
    
    [self postRedrawKline:MA];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)defaultBtn:(UIButton *)btn {
    
    [PriceIndexTool creatDefaultMaParamArray];
    self.maParam = [PriceIndexTool GetMaParamArray];
    [self configDataWith:self.maParam];
    [self.tableView reloadData];
    [PriceIndexTool SaveMAparamArray:self.maParam];
}








@end

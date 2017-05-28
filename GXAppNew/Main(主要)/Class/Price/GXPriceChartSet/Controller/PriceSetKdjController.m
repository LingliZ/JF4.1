//
//  PriceSetKdjController.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/24.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceSetKdjController.h"
#import "FTKdjParam.h"
#import "PriceSetIndexModel.h"
#import "PriceSetSectionModel.h"
#import "PriceIndexTool.h"
#import "PriceSetIndexCell.h"


@interface PriceSetKdjController ()

@property (nonatomic, strong) FTKdjParam *kdjParam;

@end

@implementation PriceSetKdjController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.kdjParam = [PriceIndexTool GetKdjParam];
    [self configDataWith:self.kdjParam];

    
}


- (void)configDataWith:(FTKdjParam *)kdjParam {
    
    PriceSetIndexModel *model1 = [[PriceSetIndexModel alloc] init];
    model1.leftTitle = @"K周期";
    model1.period = kdjParam.Kperiod;
    model1.startIndex = 2;
    model1.endIndex = 100;
    
    
    PriceSetIndexModel *model2 = [[PriceSetIndexModel alloc] init];
    model2.leftTitle = @"D周期";
    model2.period = kdjParam.Dperiod;
    model2.startIndex = 2;
    model2.endIndex = 40;
    
    
    PriceSetIndexModel *model3 = [[PriceSetIndexModel alloc] init];
    model3.leftTitle = @"J周期";
    model3.period = kdjParam.Jperiod;
    model3.startIndex = 2;
    model3.endIndex = 40;
    
    
    
    
    PriceSetSectionModel *section1 = [[PriceSetSectionModel alloc] init];
    section1.headTitle = @"KDJ指标默认值9、3、3";
    section1.modelsArray = @[model1,model2,model3];
    
    self.dataArray = @[section1];
}



- (void)inputChangeCell:(PriceSetIndexCell *)cell textfield:(UITextField *)textfield indexPath:(NSIndexPath *)indexPath {
    
    int number = [textfield.text intValue];
    
    if (number <= cell.model.startIndex) {
        number = (int)cell.model.startIndex;
    }
    
    if (indexPath.row == 0) {
        self.kdjParam.Kperiod = number;
    } else if (indexPath.row == 1) {
        self.kdjParam.Dperiod = number;
    } else {
        self.kdjParam.Jperiod = number;
    }
    
    
}


- (void)saveAction:(UIButton *)btn {

    [PriceIndexTool SaveKDJParam:self.kdjParam];
    [self postRedrawIndex:KDJ];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)defaultBtn:(UIButton *)btn {
    
    [PriceIndexTool creatDefaultKdjParam];
    self.kdjParam = [PriceIndexTool GetKdjParam];
    [self configDataWith:self.kdjParam];
    [self.tableView reloadData];
    [PriceIndexTool SaveKDJParam:self.kdjParam];
}



@end

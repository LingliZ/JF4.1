//
//  PriceIndexSetListController.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/21.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceIndexSetListController.h"


#import "PriceSetMAController.h"
#import "PriceSetBollController.h"
#import "PriceSetMacdController.h"
#import "PriceSetKdjController.h"
#import "PriceSetRsiController.h"
#import "PriceSetIndexModel.h"
#import "PriceSetSectionModel.h"



#import "FTMaParam.h"
#import "FTMaParamArray.h"


#import "PriceIndexTool.h"

#import "PriceIndexTableHeader.h"
//#import "WJYAlertView.h"




#define TableViewFooterHeight 145.f




@interface PriceIndexSetListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *indexSetTableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation PriceIndexSetListController




- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.title = @"指标设置";
   
    NSArray *array1 = @[@"MA",@"BOLL"];
    NSArray *array2 = @[@"MACD",@"KDJ",@"RSI",@"ADX",@"ATR"];
    self.dataArray = @[array1,array2];
    
    
    UITableView *indexSetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight) style:UITableViewStylePlain];
    self.indexSetTableView = indexSetTableView;
    
    
    indexSetTableView.delegate = self;
    indexSetTableView.dataSource = self;
    indexSetTableView.sectionHeaderHeight = 45;
   
    
    [self.view addSubview:indexSetTableView];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arrray = self.dataArray[section];
    return arrray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    NSArray *arrray = self.dataArray[indexPath.section];
    cell.textLabel.text = arrray[indexPath.row];
    
    //rgb 18 29 61
    cell.textLabel.textColor = GXRGBColor(18, 29, 61);
    cell.textLabel.font = GXFONT_PingFangSC_Regular(15);

    if ([cell.textLabel.text isEqualToString:@"ADX"] || [cell.textLabel.text isEqualToString:@"ATR"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    PriceIndexTableHeader *header = [[PriceIndexTableHeader alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, 45)];
    if (section == 0) {
        header.title = @"主图指标";
        return header;
    }
    
    if (section == 1) {
        header.title = @"副图指标";
        return header;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return TableViewFooterHeight;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, HeightScale_IOS6(TableViewFooterHeight))];
        footerView.backgroundColor = [UIColor whiteColor];
       // [footerView setBorderWithView:footerView top:YES left:NO bottom:NO right:NO borderColor:[UIColor grayColor] borderWidth:1];
        
        // 创建文字
        UILabel *labe1 = [[UILabel alloc] init];
        [footerView addSubview:labe1];
        [labe1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(footerView.mas_centerX);
            make.centerY.mas_equalTo(footerView.mas_centerY).multipliedBy(0.3);
        }];
        labe1.text = @"以上指标都会运用到所有交易品种的k线中";
        //rgb 161 166 187
        labe1.textColor = GXRGBColor(161, 166, 187);
        
    
        
        labe1.font = GXFONT_PingFangSC_Medium(12);
        labe1.textAlignment = NSTextAlignmentCenter;
        
        
        UILabel *labe2 = [[UILabel alloc] init];
        [footerView addSubview:labe2];
        [labe2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(footerView.mas_centerX);
            make.centerY.mas_equalTo(footerView.mas_centerY).multipliedBy(0.5);
        }];
        labe2.text = @"指标说明及用法仅供参考，由此带来的盈亏由投资者自行承担";
        //rgb 161 166 187
        labe2.textColor = GXRGBColor(161, 166, 187);
        labe2.font = GXFONT_PingFangSC_Medium(12);
        labe2.textAlignment = NSTextAlignmentCenter;
        
        
        
        UIButton *makeDefaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:makeDefaultButton];
        
        [makeDefaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labe2.mas_bottom).offset(24);
            make.centerX.mas_equalTo(footerView.mas_centerX);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(footerView.mas_width).multipliedBy(0.5);
        }];
        
        [makeDefaultButton setTitle:@"全部指标恢复默认" forState:UIControlStateNormal];
        makeDefaultButton.titleLabel.font = GXFONT_PingFangSC_Regular(16);
        //rgb 64 130 244
        makeDefaultButton.backgroundColor = GXRGBColor(64, 130, 244);
        makeDefaultButton.layer.masksToBounds = YES;
        makeDefaultButton.layer.cornerRadius = 6;
        [makeDefaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [makeDefaultButton addTarget:self action:@selector(makeDefaultButtonAction) forControlEvents:UIControlEventTouchUpInside];

        return footerView;
        
    }
    
    return nil;
}


- (void)makeDefaultButtonAction {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"是否将所有指标恢复为默认数值？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GXUserInfoTool configDefaultIndexRecord];
        [GXNotificationCenter postNotificationName:PriceReLoadChartNotificaitonName object:nil];
    }];
    
    [alertC addAction:cancleAction];
    [alertC addAction:sureAction];
    
    [self presentViewController:alertC animated:true completion:nil];
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            PriceSetMAController *setMaVC = [[PriceSetMAController alloc] init];
            [self.navigationController pushViewController:setMaVC animated:YES];
            
        } else if (indexPath.row == 1) {
            PriceSetBollController *setBollVC = [[PriceSetBollController alloc] init];
            [self.navigationController pushViewController:setBollVC animated:YES];
        }
        
    }
    
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            PriceSetMacdController *setMacdVC = [[PriceSetMacdController alloc] init];
            [self.navigationController pushViewController:setMacdVC animated:YES];
        } else if (indexPath.row == 1) {
            PriceSetKdjController *setKDJVC = [[PriceSetKdjController alloc] init];
            [self.navigationController pushViewController:setKDJVC animated:YES];
        } else if (indexPath.row == 2) {
            PriceSetRsiController *setRSIVC = [[PriceSetRsiController alloc] init];
            [self.navigationController pushViewController:setRSIVC animated:YES];
        }
    }

    
}





@end

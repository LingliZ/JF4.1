//
//  PriceSetIndexParamBaseController.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/23.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceSetIndexParamBaseController.h"

#import "PriceSetSectionModel.h"

#import "PriceSetIndexCell.h"
#import "PriceSetIndexModel.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "PriceIndexTableHeader.h"


#define TableView_Height 45

@interface PriceSetIndexParamBaseController ()<UITableViewDelegate, UITableViewDataSource,PriceSetIndexCellDelegate>

@end

@implementation PriceSetIndexParamBaseController

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self renderUI];
}

#pragma mark - render UI
- (void)renderUI {
    [self.view addSubview:self.tableView];
}


#pragma mark - UItableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PriceSetSectionModel *secionModel = self.dataArray[section];
    return secionModel.modelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PriceSetIndexCell *cell = [PriceSetIndexCell cellWithTableView:tableView indexPath:indexPath];
    PriceSetSectionModel *sectionModel = self.dataArray[indexPath.section];
    PriceSetIndexModel *model = sectionModel.modelsArray[indexPath.row];
    [cell setModel:model index:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PriceSetSectionModel *secionModel = self.dataArray[section];
    PriceIndexTableHeader *header = [[PriceIndexTableHeader alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, TableView_Height)];
    header.title = secionModel.headTitle;
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count != section + 1) {
        return 0;
    } else {
        return 115.f;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.dataArray.count != section + 1) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, 115)];
    view.backgroundColor = [UIColor whiteColor];
    
    //rgb 241 243 248
    UIButton *defauleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:defauleBtn];
    defauleBtn.backgroundColor = GXRGBColor(241, 243, 248);
    [defauleBtn setTitle:@"恢复默认" forState:UIControlStateNormal];
    //rgb 161 166 187
    [defauleBtn setTitleColor:GXRGBColor(161, 166, 187) forState:UIControlStateNormal];
    defauleBtn.titleLabel.font = GXFONT_PingFangSC_Regular(15);
    defauleBtn.layer.masksToBounds = YES;
    defauleBtn.layer.cornerRadius = 6;
    
    
    
    [defauleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@48);
        make.centerX.mas_equalTo(view.mas_centerX).multipliedBy(0.5);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    
    [defauleBtn addTarget:self action:@selector(defaultBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn = saveBtn;
    [view addSubview:saveBtn];
    saveBtn.backgroundColor = GXRGBColor(241, 243, 248);
    saveBtn.titleLabel.font = GXFONT_PingFangSC_Regular(15);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:GXRGBColor(161, 166, 187) forState:UIControlStateNormal];
  
    saveBtn.enabled = NO;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 6;

    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@150);
        make.height.mas_equalTo(@48);
        make.centerX.mas_equalTo(view.mas_centerX).multipliedBy(1.5);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}


- (void)SetIndexCellBeginInput:(UITextField *)textfield {
    
    //64 130 244
    self.saveBtn.backgroundColor = GXRGBColor(64, 130, 244);
    [self.saveBtn setTitleColor:GXRGBColor(255, 255, 255) forState:UIControlStateSelected];
    [self.saveBtn setTitleColor:GXRGBColor(255, 255, 255) forState:UIControlStateNormal];
    self.saveBtn.enabled = YES;
}


- (void)saveAction:(UIButton *)btn {
    NSLog(@"点击了保存");
}


- (void)defaultBtn:(UIButton *)btn {
    NSLog(@"点击回复默认");
}


- (void)postRedrawKline:(KLineChartTopType)type {
    [GXNotificationCenter postNotificationName:PriceReDrawPriceKlineChartNotificaitonName object:[NSNumber numberWithInteger:type]];
}

- (void)postRedrawIndex:(KLineChartBottomType)type {
    [GXNotificationCenter postNotificationName:PriceReDrawPriceIndexChartNotificaitonName object:[NSNumber numberWithInteger:type]];
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = TableView_Height;
      
    }
    return _tableView;
}








@end

//
//  GXDiscoverController.m
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXDiscoverController.h"
#import "SDCycleScrollView.h"
#import "UITableView+GXSetFooter.h"
#import "GXDiscoverCell.h"
#import "MJRefresh.h"
#import "GXDiscoverModel.h"
#import "GXDetailBannerController.h"
#import "GXInformationController.h"
#import "GXActivityController.h"
#import "GXInvestController.h"
#import "GXVideoController.h"
#import "GXHomeAdvertistsModel.h"
#import "GXBanAnaRemImpDetailController.h"
@interface GXDiscoverController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *imgUrlArray;
@property (nonatomic,strong) NSMutableArray *clickUrlArray;
@property (nonatomic,strong) NSMutableArray *saveBannerArray;
@property (nonatomic,strong) SDCycleScrollView *cycleScollView;
@property (nonatomic,strong) NSMutableArray *cycleTitleArray;
@end

@implementation GXDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.saveBannerArray = [NSMutableArray new];
    [self addHeaderView];
    [self.tableView setFooter];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor whiteColor];
}

- (void)loadData{
    __weak typeof(self) weakSelf = self;
    [GXHttpTool POSTCache:GXUrl_home parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"success"] integerValue] != 1) {
            return ;
        }
        NSArray *bannersArray = responseObject[@"value"][@"banner"];
        if (bannersArray.count == 0) {
            return;
        }
        [self removeDataArray];
        [bannersArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            GXHomeAdvertistsModel *bannerModel = [GXHomeAdvertistsModel new];
            NSString *clickUrlStr = dict[@"clickurl"];
            NSString *imgUrlStr = dict[@"imgurl"];
            [weakSelf.imgUrlArray addObject:imgUrlStr];
            [weakSelf.clickUrlArray addObject:clickUrlStr];
            [weakSelf.cycleTitleArray addObject:dict[@"name"]];
            [bannerModel setValuesForKeysWithDictionary:dict];
            [self.saveBannerArray addObject:bannerModel];
            
        }];
        [self refreshUI];
    } failure:^(NSError *error) {
        GXLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        
        
        [self showErrorNetMsg:nil withView:self.tableView];

    }];
}
-(void)removeDataArray{
    [self.imgUrlArray removeAllObjects];
    [self.clickUrlArray removeAllObjects];
    [self.cycleTitleArray removeAllObjects];
    [self.saveBannerArray removeAllObjects];
}
- (void)refreshUI{
    self.cycleScollView.imageURLStringsGroup = self.imgUrlArray;
    self.cycleScollView.titlesGroup = self.cycleTitleArray;
}
- (void)addHeaderView{
    SDCycleScrollView *cycleScollV = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenWidth * 0.50666) delegate:self placeholderImage:[UIImage imageNamed:@"cycle_Banner_placeholder_pic"]];
    cycleScollV.currentPageDotImage = [UIImage imageNamed:@"cycle_now"];
    cycleScollV.pageDotImage = [UIImage imageNamed:@"cycle_other"];
    cycleScollV.delegate = self;
    cycleScollV.autoScrollTimeInterval = 4.0;
    cycleScollV.backgroundColor=RGBACOLOR(235, 235, 235, 1);
    self.cycleScollView = cycleScollV;
    cycleScollV.imageURLStringsGroup = self.imgUrlArray;
    cycleScollV.titlesGroup = self.cycleTitleArray;
//    cycleScollV.titlesGroup =
    
    self.tableView.tableHeaderView = cycleScollV;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [MobClick event:@"find_AD"];
    GXBanAnaRemImpDetailController *detailBC = [[GXBanAnaRemImpDetailController alloc] init];
    detailBC.disBannerModel = self.saveBannerArray[index];
    
    [self.navigationController pushViewController:detailBC animated:true];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXDiscoverCell"];
    if (!cell) {
        cell = [[GXDiscoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GXDiscoverCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.discoverModel = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
            [MobClick event:@"news"];
            vc = [[GXInformationController alloc] init];
            [GXUserdefult removeObjectForKey:@"savePage"];
            [GXUserdefult synchronize];

            break;
        case 1:
        {
            [MobClick event:@"activitie"];
            GXActivityController *vc = [[GXActivityController alloc] init];
//            vc.advModel = self.saveBannerArray[indexPath.row];
            vc.recieveArray = self.saveBannerArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
            [MobClick event:@"investment_college"];
            vc = [[GXInvestController alloc] init];
            break;
            
        default:
            [MobClick event:@"wonderful_video"];
            vc = [[GXVideoController alloc] init];
            break;
    }
    [self.navigationController pushViewController:vc animated:true];
}

- (NSMutableArray *)imgUrlArray{
    if (_imgUrlArray == nil) {
        _imgUrlArray = [NSMutableArray array];
    }
    return _imgUrlArray;
}

- (NSMutableArray *)clickUrlArray{
    if (_clickUrlArray == nil) {
        _clickUrlArray = [NSMutableArray array];
    }
    return _clickUrlArray;
}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [GXDiscoverModel discoverModels];
    };
    return _dataArray;
}
-(NSMutableArray *)cycleTitleArray{
    if (!_cycleTitleArray) {
        _cycleTitleArray = [NSMutableArray new];
    }return _cycleTitleArray;
}

@end

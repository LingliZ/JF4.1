//
//  GXCourseView.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXCourseView.h"
#import "GXCourseCell.h"
#import "GXLiveCommonSize.h"
#import "UITableView+GXSetFooter.h"
#import "MBProgressHUD.h"
#import "GXCoursesModel.h"
#import "GXGetCurrentWeekDay.h"
#import "UIView+GXNetError.h"

@interface GXCourseView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) NSArray *weekdays;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *currentCourses;
@end
@implementation GXCourseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}

- (void)loadData{
    self.tableView.backgroundView = nil;
    [GXHttpTool POSTCache:GXUrl_liveCourses parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"success"] intValue] == 0) return ;
        [MBProgressHUD hideHUDForView:self animated:YES];
        NSArray *value = responseObject[@"value"];
        NSMutableArray *weekdays = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            NSMutableArray *array = [NSMutableArray array];
            [weekdays addObject:array];
        }
        __block NSMutableArray *arrM;
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            GXCoursesModel *coursesModel = [GXCoursesModel courseWithDict:dict];
            
            NSInteger weekDay = [[GXGetCurrentWeekDay shareWeekDay] getWeek:coursesModel.date];
            arrM = weekdays[weekDay - 1];
            [arrM addObject:coursesModel];
        }];
        self.weekdays = weekdays;
        
        [self weekdayBtnClick:self.selectedBtn];
        
        [self showEmptyMsg:nil dataSourceCount:value.count];
    } failure:^(NSError *error) {
        GXLog(@"%@",error);
        [self showErrorNetMsg:nil];
    }];
    
}

- (void)setupUI{
    
    UIView * topV = [[UIView alloc] init];
    topV.backgroundColor = GXRGBColor(46, 45, 61);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [topV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topV);
        make.width.height.equalTo(@(TopViewHeight / 2));
        make.right.equalTo(topV).offset(-GXMargin);
    }];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.text = @"节目表";
    [topV addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topV);
        make.centerX.equalTo(topV);
        make.height.equalTo(@(TopViewHeight / 2));
    }];
    
    NSArray *titleArray = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    double btnW = GXScreenWidth / titleArray.count;
    __block NSInteger currentW = [[GXGetCurrentWeekDay shareWeekDay] getCurrentWeek];
    if (currentW == 1) {
        currentW = 6;
    }else{
        currentW = currentW - 2;
    };
    [titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
        [btn setTitleColor:GXRGBColor(92, 99, 130) forState:UIControlStateNormal];
        [btn setTitleColor:GXRGBColor(64, 130, 244) forState:UIControlStateSelected];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setBackgroundColor:GXRGBColor(46, 45, 61)];
        
        [topV addSubview:btn];
        CGFloat leftMargin = idx * btnW;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topV).offset(TopViewHeight / 2);
            make.left.equalTo(topV).offset(leftMargin);
            make.width.equalTo(@(btnW));
            make.bottom.equalTo(topV);
        }];
        
        if (idx == currentW) {
            self.selectedBtn = btn;
        }
        
        btn.tag = idx;
        [btn addTarget:self action:@selector(weekdayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [self weekdayBtnClick:self.selectedBtn];
    
    [self addSubview:topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@TopViewHeight);
    }];
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:tableV];
    tableV.dataSource = self;
    tableV.delegate = self;
    [tableV setFooter];
    self.tableView = tableV;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [self addSubview:tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(topV.mas_bottom);
    }];
    
}

- (void)weekdayBtnClick: (UIButton *)btn{
    self.selectedBtn.selected = false;
    btn.selected = true;
    self.selectedBtn = btn;
    
    [self.tableView reloadData];
}

- (void)showEmptyTip{
    if (self.currentCourses.count == 0) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"暂时没有课程安排";
        label.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        self.tableView.backgroundView = label;
    }else{
        self.tableView.backgroundView = nil;
    }
    
}

- (void)btnClick:(UIButton *)btn{
    if (self.courseDelegate) {
        self.courseDelegate(self);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.currentCourses = self.weekdays[self.selectedBtn.tag];
    [self showEmptyTip];
    return ((NSArray *)self.weekdays[self.selectedBtn.tag]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXCourseCell"];
    if (!cell) {
        cell = [[GXCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GXCourseCell"];
    }
    switch (indexPath.row % 2) {
        case 0:
            cell.contentView.backgroundColor = GXRGBColor(55, 54, 72);
            break;
        default:
            cell.contentView.backgroundColor = GXRGBColor(46, 45, 61);
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *dataArray = self.weekdays[self.selectedBtn.tag];
    cell.courseModel = dataArray[indexPath.row];
    return cell;
}
@end

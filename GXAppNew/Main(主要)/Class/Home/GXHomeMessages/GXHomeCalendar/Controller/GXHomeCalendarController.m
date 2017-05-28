//
//  GXHomeCalendarController.m
//  GXAppNew
//
//  Created by 王振 on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeCalendarController.h"
#import "GXCalendarPageView.h"
#import "GXUIParameter.h"
#import "FCChildBaseViewController.h"
#import "GXFirstViewController.h"
#import "GXCalendarPickerView.h"
//#import "GXAdaptiveHeightTool.h"

@interface GXHomeCalendarController ()<GXCalendarPagerViewDelegate,GXCalendarPickerViewDelegate>

@property (nonatomic,strong)NSMutableArray *dateTitlesArray;
@property (nonatomic,strong)NSDate *customDate;
@property (nonatomic,strong)GXCalendarPageView *ninaPagerView;
@property (nonatomic,strong)NSMutableArray *colorArray;
@property (nonatomic,strong)NSMutableArray *controllerArray;
@property (nonatomic,strong)NSMutableArray *titlesArray;
@property (nonatomic,strong)GXCalendarPickerView *pickView;
@property (nonatomic,assign)NSInteger days;
@property (nonatomic,strong)NSString *weekDay1;
@property (nonatomic,strong)NSMutableArray *netDateArray;
@property (nonatomic,assign)CGFloat clendarLine;

@end

@implementation GXHomeCalendarController

-(void)ninaCurrentPageIndex:(NSString *)currentPage{
    //    NSLog(@"点击的日期是%@",str);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.dateTitlesArray = [NSMutableArray new];
    self.netDateArray = [NSMutableArray new];
    self.controllerArray = [NSMutableArray new];
    self.title = @"财经日历";
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.clendarLine = [@"08.08" boundingRectWithSize:bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
    NSDate *todayDate = [NSDate date];
    NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:todayDate];
    NSInteger weekday = [components weekday];//a就是星期几,1是星期日,2是星期一,后面依次后推
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    NSString *weekStr = weekArray[weekday - 1];
    
    NSInteger upperLimit = 0;
    NSInteger lowerLimit = 0;
    NSInteger defaultPage = 0;
    if ([weekStr containsString:@"一"]){
        upperLimit = 14;
        lowerLimit = -7;
        defaultPage = 7;
    }else if ([weekStr containsString:@"二"]){
        upperLimit = 13;
        lowerLimit = -8;
        defaultPage = 8;
    }else if ([weekStr containsString:@"三"]){
        upperLimit = 12;
        lowerLimit = -9;
        defaultPage = 9;
    }else if ([weekStr containsString:@"四"]){
        upperLimit = 11;
        lowerLimit = -10;
        defaultPage = 10;
    }else if ([weekStr containsString:@"五"]){
        upperLimit = 10;
        lowerLimit = -11;
        defaultPage = 11;
    }else if ([weekStr containsString:@"六"]){
        upperLimit = 9;
        lowerLimit = -12;
        defaultPage = 12;
    }else if ([weekStr containsString:@"日"]){
        upperLimit = 8;
        lowerLimit = -13;
        defaultPage = 13;
    }
    for (NSInteger i = lowerLimit; i < upperLimit; i++) {
        NSString *getDate = [self getnDay:i];
        NSString *getDateStr = [self getnNetworkDate:i];
        [self.netDateArray addObject:getDateStr];
        [self.dateTitlesArray addObject: getDate];
    }
    self.titlesArray = self.dateTitlesArray;
    for (NSInteger i = lowerLimit ; i < upperLimit; i++) {
        GXFirstViewController *financeVC = [GXFirstViewController new];
        [self.controllerArray addObject:financeVC];
        financeVC.type = i;
        NSLog(@"每个控制器的type值是:%ld",financeVC.type);
    }
    self.colorArray = @[GXRGBColor(64, 130, 244),//选中标题颜色
                        GXRGBColor(145, 145, 145),//未被选中标题颜色
                        [UIColor whiteColor],//下划线颜色
                        GXRGBColor(43, 41, 53),//标题栏背景颜色
                        ].mutableCopy;
    self.ninaPagerView = [[GXCalendarPageView alloc]initWithNinaPagerStyle:NinaPagerStyleSlideBlock WithTitles:self.titlesArray WithVCs:self.controllerArray WithColorArrays:self.colorArray WithDefaultIndex:defaultPage WithTitleFontSize:12];

    self.ninaPagerView.titleScale = 1;
    self.ninaPagerView.customBottomLinePer = 35;
    self.ninaPagerView.delegate = self;
    [self.view addSubview:self.ninaPagerView];
    _ninaPagerView.pushEnabled = YES;
}
-(BOOL)deallocVCsIfUnnecessary{
    return true;
}
//获取请求的日期格式
- (NSString *)getnNetworkDate:(NSInteger)n{
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if(n != 0){
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay * n];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyyMMdd"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    return the_date_str;
}
//获取N天的日期
- (NSString *)getnDay:(NSInteger)n{
    //现在时间
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    if (n != 0) {
        //1天的长度
        NSTimeInterval oneDay = 24 * 60 * 60 * 1;
        //从现在往后推的秒数
        theDate = [nowDate initWithTimeIntervalSinceNow:oneDay * n];
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc]init];
    [date_formatter setDateFormat:@"dd"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:theDate];
    NSInteger weekday = [components weekday];//a就是星期几,1是星期日,2是星期一,后面依次后推
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    NSString *weekStr = weekArray[weekday - 1];
    if (n == 0) {
        NSString *todayStr = @"今天";
        NSString *weekDay = [[todayStr stringByAppendingString:@"\n\n\n"]stringByAppendingString:the_date_str];
        return weekDay;
    }else{
        NSString *weekDay = [[weekStr stringByAppendingString:@"\n\n\n"] stringByAppendingString:the_date_str];
        return weekDay;
    }
}
- (void)didClickBackAction:(UIBarButtonItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

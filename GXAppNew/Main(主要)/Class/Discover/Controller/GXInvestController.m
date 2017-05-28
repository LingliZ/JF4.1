//
//  GXInvestController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXInvestController.h"
#import "NinaPagerView.h"
#import "GXInvestDetaiController.h"

@interface GXInvestController ()<NinaPagerViewDelegate>
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *subVcArray;
@property (nonatomic, strong) NSArray *colorsArray;
@end

@implementation GXInvestController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"投资学院";
    [self setupUI];
}
- (void)setupUI{
    self.titlesArray = @[@"基础课", @"基本课", @"技术课"];
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:self.titlesArray.count];
    [self.titlesArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GXInvestDetaiController *investDetailC = [[GXInvestDetaiController alloc] init];
        investDetailC.type = idx;
        [arrM addObject:investDetailC];
    }];
    self.subVcArray = arrM;
    self.colorsArray = @[[UIColor whiteColor],
                         RGBACOLOR(114 , 110, 150, 1),
                         [UIColor whiteColor],
                         RGBACOLOR(45, 47, 59, 1)];
    NinaPagerView *pagerV = [[NinaPagerView alloc] initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:self.titlesArray WithVCs:self.subVcArray WithColorArrays:self.colorsArray WithDefaultIndex:0];
    pagerV.delegate =self;
    [self.view addSubview:pagerV];
    pagerV.titleScale = 1.0;
    pagerV.pushEnabled = true;
}
-(void)ninaCurrentPageIndex:(NSString *)currentPage{
    switch ([currentPage integerValue]) {
        case 0:
            [MobClick event:@"easy"];
            break;
        case 1:
            [MobClick event:@"medium"];
            break;
        default:
            [MobClick event:@"hard"];
            break;
    }
}
-(BOOL)deallocVCsIfUnnecessary
{
    return YES;
}
@end

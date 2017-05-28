//
//  GXLiveDetailViewController.m
//  GXAppNew
//
//  Created by maliang on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLiveDetailViewController.h"
#import "NinaPagerView.h"
#import "GXSuggestionVc.h"
#import "GXExchangeVc.h"
#import "GXQAndAVc.h"
#import "GXLiveVc.h"
#import "GXLiveCommonSize.h"

@interface GXLiveDetailViewController ()<NinaPagerViewDelegate>

@property(nonatomic,strong)NSMutableArray * valueArray;
@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong)NSMutableArray * inTitleArray;

@end

@implementation GXLiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.nameTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    self.nameArray = [NSMutableArray array];
    self.valueArray = [NSMutableArray array];
    self.inTitleArray = [NSMutableArray array];
    [self createUI];
}

- (void)createUI
{
    self.inTitleArray = (NSMutableArray *)@[@"直播",@"问答",@"交流",@"建议"];
    NSMutableArray *classArr = [[NSMutableArray alloc] init];
    //直播
    GXLiveVc *liveVc = [[GXLiveVc alloc] init];
    liveVc.liveRoomID = self.roomID;
    [classArr addObject:liveVc];
    //问答
    GXQAndAVc *qAndAVc = [[GXQAndAVc alloc] init];
    qAndAVc.liveRoomID = self.roomID;
    [classArr addObject:qAndAVc];
    //交流
    GXExchangeVc *exchangeVc = [[GXExchangeVc alloc] init];
    exchangeVc.liveRoomID = self.roomID;
    [classArr addObject:exchangeVc];
    //建议
    GXSuggestionVc *suggestVc = [[GXSuggestionVc alloc] initWithBundleRoom:self.detailModel.isBindRoom];
    suggestVc.liveRoomID = self.roomID;
    suggestVc.isBindRoom = _detailModel.isBindRoom;
    [classArr addObject:suggestVc];
    
    NSArray * colorArr = @[[UIColor whiteColor],
                           GXRGBColor(161, 166, 186),
                           [UIColor whiteColor],
                           GXRGBColor(45, 47, 59)
                           ];
    NinaPagerView *pagerV = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:self.inTitleArray WithVCs:classArr WithColorArrays:colorArr WithDefaultIndex:1];
    pagerV.titleScale = 1;
    pagerV.delegate = self;
    [self.view addSubview:pagerV];
    pagerV.pushEnabled = YES;
}

-(BOOL)deallocVCsIfUnnecessary {
    return YES;
}

- (void)ninaCurrentPageIndex:(NSString *)currentPage{
    
    switch ([currentPage intValue]) {
        case 0:
            [MobClick event:@"counselor_live"];
            break;
        case 1:
            [MobClick event:@"counselor_answer"];
            break;
        case 2:
            [MobClick event:@"user_interaction"];
            break;
        case 3:
            [MobClick event:@"counselor_jsjy"];
            break;
            
        default:
            break;
    }
    
    NSDictionary *dict = @{@"page":currentPage};
    [[NSNotificationCenter defaultCenter] postNotificationName:CurrentPageNotify object:dict];
}

@end

//
//  GXInformationController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/9.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXInformationController.h"
#import "GXDetailInformationController.h"
#import "NinaPagerView.h"

@interface GXInformationController ()<NinaPagerViewDelegate>
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *subVcArray;
@property (nonatomic, strong) NSArray *colorsArray;
//保存列表名字数据
@property (nonatomic,strong)NSMutableArray *valueArray;
//保存列表ID数组
@property (nonatomic,retain)NSMutableArray *nameArray;

@property (nonatomic,strong)NSMutableArray *InTitleArray;

//@property (nonatomic,strong)ChildBaseViewController *childBaseVC;

//保存页数的值
@property (nonatomic,assign)NSInteger index;
@end

@implementation GXInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯";
    self.nameArray = [NSMutableArray new];
    self.valueArray = [NSMutableArray new];
    self.InTitleArray = [NSMutableArray new];
    [self loadListDataFromServer];
    //[self setupUI];
}
-(void)loadListDataFromServer{
    [self removeArrayObjects];
    [GXHttpTool POSTCache:GXUrl_articleTypeList parameters:nil success:^(id responseObject) {
        NSMutableArray *InClassArray=[[NSMutableArray alloc] init];
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            for (NSDictionary *valueDict in responseObject[@"value"]) {
                [self.nameArray addObject:valueDict[@"name"]];
                [self.valueArray addObject:valueDict[@"value"]];
                GXDetailInformationController *comment=[[GXDetailInformationController alloc] init];
                comment.type=valueDict[@"name"];
                [InClassArray addObject:comment];
            }
            self.InTitleArray = self.valueArray;
            NSArray *InColorArray = @[
                                      [UIColor whiteColor],
                                      RGBACOLOR(114 , 110, 150, 1),
                                      [UIColor whiteColor],
                                      RGBACOLOR(45, 47, 59, 1)
                                      ];
            NSString *pageCount = [GXUserdefult objectForKey:@"savePage"];
            if (pageCount == nil) {
                self.index = 0;
            }else{
                self.index = [self.nameArray indexOfObject:pageCount];
            }
            NinaPagerView *inPagerView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:self.InTitleArray WithVCs:InClassArray WithColorArrays:InColorArray WithDefaultIndex:self.index];
            inPagerView.titleScale = 1;
            inPagerView.delegate = self;
            [self.view addSubview:inPagerView];
            inPagerView.pushEnabled = YES;
        }
    } failure:^(NSError *error) {
        if (self.valueArray.count == 0) {
//            [self showErrorNetMsg:nil Handler:^{
//                [self viewWillAppear:YES];
//            }];
        }
    }];
}
-(void)ninaCurrentPageIndex:(NSString *)currentPage{
    switch ([currentPage integerValue]) {
        case 0:
            [MobClick event:@"gxpl"];
            break;
        case 1:
            [MobClick event:@"fxyj"];
            break;
        case 2:
            [MobClick event:@"gjcj"];
            break;
        case 3:
            [MobClick event:@"jggd"];
            break;
        case 4:
            [MobClick event:@"scdt"];
            break;

        default:
            break;
    }
}
-(void)removeArrayObjects{
    [self.nameArray removeAllObjects];
    [self.valueArray removeAllObjects];
}

-(BOOL)deallocVCsIfUnnecessary{
    return YES;
}
- (void)setupUI{
    self.titlesArray = @[@"国鑫评论", @"分析研究", @"国际财经", @"机构观点", @"市场动态", @"市场动态"];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:self.titlesArray.count];
    [self.titlesArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GXDetailInformationController *detailVc = [[GXDetailInformationController alloc] init];
        detailVc.type = obj;
        [arrM addObject:detailVc];
    }];
    self.subVcArray = arrM;
    self.colorsArray = @[[UIColor blueColor], [UIColor blackColor], [UIColor blackColor], [UIColor greenColor]];
    NinaPagerView *ninaPagerV = [[NinaPagerView alloc] initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:self.titlesArray WithVCs:self.subVcArray WithColorArrays:self.colorsArray WithDefaultIndex:0];
//    ninaPagerV.titleScale = 1.5;
    [self.view addSubview:ninaPagerV];
    ninaPagerV.pushEnabled = true;
}

@end

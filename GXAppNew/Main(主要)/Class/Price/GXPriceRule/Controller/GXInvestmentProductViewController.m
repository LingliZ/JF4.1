//
//  GXInvestmentProductViewController.m
//  GXApp
//
//  Created by WangLinfang on 16/7/1.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXInvestmentProductViewController.h"
#import "SINavigationMenuView.h"
#import "GXTradeDetailModel.h"
#import "GXTradeDetailItemModel.h"
#import "NinaPagerView.h"
#import "UIParameter.h"
#import "GXProductBaseController.h"
@interface GXInvestmentProductViewController ()<SINavigationMenuDelegate,NinaPagerViewDelegate>
{

    SINavigationMenuView *menu;
    NSMutableDictionary* produceDict;

}
@property (nonatomic,strong)NinaPagerView *ninaPageView;
@property (nonatomic,strong)NSMutableArray *titlesArray;
@property (nonatomic,strong)NSMutableArray *controllerVCArray;
@property (nonatomic,strong)NSMutableArray *colorArray;
@property (nonatomic,strong)NSMutableArray *urlArray;
@end

@implementation GXInvestmentProductViewController
-(void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [menu onHideMenu];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    //标题名字数组
    self.titlesArray = [NSMutableArray new];
    //控制器数组
    self.controllerVCArray = [NSMutableArray new];
    //url数组
    self.urlArray = [NSMutableArray new];
    //颜色数组
    self.colorArray = @[
                        [UIColor orangeColor],
                        [UIColor grayColor],
                        [UIColor orangeColor],
                        [UIColor whiteColor],
                        ].mutableCopy;
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    [self createUI];
//    [MobClick event:@"trading_detail"];
}
-(void)createUI
{
   

    //self.navigationItem.title=@"投资产品";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld",(long)indexPath.row];
    
    return cell;
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    
    switch (index) {
        case 0:
//              [MobClick event:@"qlsp_detail"];
            break;
        case 1:
//              [MobClick event:@"jgs_gp_detail"];
            break;
        case 2:
//              [MobClick event:@"jgs_jq_detail"];
            break;
        case 3:
//              [MobClick event:@"jgs_yq_detail"];
            break;

   
        default:
            break;
    }
    menu.menuButton.title.text=[menu.items objectAtIndex:self.index];
    [self initView];
  
}

-(void) initView{

   GXTradeDetailModel* tradeDetailModel =[produceDict objectForKey:menu.menuButton.title.text];

    NSArray* array=[GXTradeDetailItemModel mj_objectArrayWithKeyValuesArray:tradeDetailModel.tradeDetailItemArrayList];
    
    self.ninaPageView = nil;
    [self.titlesArray removeAllObjects];
    [self.controllerVCArray removeAllObjects];
    [self.urlArray removeAllObjects];
    for (GXTradeDetailItemModel* detailItem in array) {
        NSLog(@"%@",detailItem.name);
        //标题名字,url存到数组
        [self.titlesArray addObject:detailItem.name];
        [self.urlArray addObject:detailItem.url];
    }
    //循环创建控制器并添加到数组里
    for (int i = 0; i < self.titlesArray.count; i++) {
        GXProductBaseController *productVC = [GXProductBaseController new];
        [self.controllerVCArray addObject:productVC];
        productVC.type = i;
        productVC.postUrlArray = self.urlArray;
    }
    //初始化
    self.ninaPageView = [[NinaPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:self.titlesArray WithVCs:self.controllerVCArray WithColorArrays:self.colorArray WithDefaultIndex:0];
    //self.ninaPageView.titleScale = 1.15;//调节字体大小(1.15是默认)
//    self.ninaPageView.delegate = self;
    self.ninaPageView.titleScale = 1;
     self.ninaPageView.customBottomLinePer = WidthScale_IOS6(60);
    [self.view addSubview:self.ninaPageView];
    self.ninaPageView.pushEnabled = YES;

}
//内从管理方法
-(BOOL)deallocVCsIfUnnecessary{
    return YES;
}



-(void) loadData{
    
    [GXHttpTool POSTCache:GXUrl_tradeDetail parameters:nil  success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
          
           
            NSArray* array = [GXTradeDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
           
            NSMutableArray* titleArray=[[NSMutableArray alloc] init];
            produceDict=[[NSMutableDictionary alloc] init];
            for (GXTradeDetailModel* tradeDetail in array) {
                [titleArray addObject:tradeDetail.name];
                [produceDict setObject:tradeDetail forKey:tradeDetail.name];
            }
            
             //CGRect frame = CGRectMake(WidthScale_IOS6(-52), 0.0, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
            CGRect frame = CGRectMake(WidthScale_IOS6(-40),0, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
            
            menu = [[SINavigationMenuView alloc] initWithFrame:frame title:[titleArray objectAtIndex:self.index]];
//            [menu displayMenuInView:self.navigationController.view];
            
            menu.items =titleArray;
//            menu.delegate = self;
            self.navigationItem.titleView = menu;
            [self initView];
            
        }else{
//            [self showComomError:responseObject];
        }
        
        
    } failure:^(NSError *error) {
        if (menu.items.count == 0) {
//            [self showErrorNetMsg:nil Handler:^{
//                [self loadData];
//            }];
        }

        
    }];
    
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

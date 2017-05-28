//
//  GXPriceListEditViewController.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/18.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceListEditViewController.h"
#import "PriceMarketModel.h"
#import "GXPriceListEditTableViewCell.h"
#import "GXPriceListScrollView.h"

@interface Item_edit: NSObject

@property (strong, nonatomic) PriceMarketModel *priceModel;

@property (assign, nonatomic) BOOL isChecked;

@end

@implementation Item_edit


@end

@interface GXPriceListEditViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *listmenu;
    NSURLSessionDataTask *dataTask;//请求任务;
  
    NSMutableArray *willdeleteAr;
    NSMutableArray *dataAr;
    
    UIView *headview;
    
    UIButton *allSelectButton;
    UIButton *deleButton;
}

@end

@implementation GXPriceListEditViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"编辑自选";
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64-45) style:UITableViewStylePlain];
    listmenu.dataSource=self;
    listmenu.delegate=self;
    listmenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    listmenu.backgroundColor=priceEditList_color_cellBackg;
    [listmenu setEditing:YES];
    listmenu.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:listmenu];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    header.stateLabel.textColor=priceList_color_tableViewFootViewText;
    header.lastUpdatedTimeLabel.textColor=priceList_color_tableViewFootViewText;
    header.loadingView.color=priceList_color_tableViewFootViewText;
    listmenu.mj_header=header;
    listmenu.mj_header.automaticallyChangeAlpha = YES;
    [listmenu.mj_header beginRefreshing];
    
    
    UIBarButtonItem *BarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:0 target:self action:@selector(doneButton)];
    [BarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBACOLOR(68, 133, 241, 1),NSFontAttributeName:GXFONT_PingFangSC_Regular(14)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=BarButtonItem;
    
    

    dataAr=[[NSMutableArray alloc]init];
    
    
    allSelectButton=[[UIButton alloc]initWithFrame:CGRectMake(0, listmenu.frame.origin.y+listmenu.frame.size.height, GXScreenWidth/2.0, 45)];
    allSelectButton.backgroundColor=priceEditList_color_BoomButtonALLSelectBackg;
    [allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectButton setTitleColor:priceEditList_color_BoomButtonTitle forState:UIControlStateNormal];
    allSelectButton.titleLabel.font=GXFONT_PingFangSC_Regular(15);
    [allSelectButton addTarget:self action:@selector(allSelectButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allSelectButton];
    
    deleButton=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, listmenu.frame.origin.y+listmenu.frame.size.height, GXScreenWidth/2.0, 45)];
    deleButton.backgroundColor=priceEditList_color_BoomButtonDeleBackg;
    [deleButton setTitle:@"删除自选" forState:UIControlStateNormal];
    [deleButton setTitleColor:priceEditList_color_BoomButtonTitle forState:UIControlStateNormal];
    deleButton.titleLabel.font=GXFONT_PingFangSC_Regular(15);
    [deleButton addTarget:self action:@selector(deleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleButton];
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    if(dataTask)
    {
        [dataTask cancel];
        dataTask=nil;
    }
}


-(void)doneButton
{
    GXLog(@"完成");
    
    NSMutableArray *codear=[[NSMutableArray alloc]init];
    for (Item_edit *item in dataAr) {
        PriceMarketModel *model=item.priceModel;

        GXLog(@"%@",model.name);
        [codear addObject:model.code];
    }
    
    [GXUserdefult setObject:codear forKey:PersonSelectCodesKey];
    [GXUserdefult synchronize];

    [self.view showLoadingWithTitle:@"正在保存"];
    
    [GXHttpTool POST:GXUrl_setPrice parameters:@{@"productCodes":[codear componentsJoinedByString:@","]}  success:^(id responseObject) {
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
        }else
        {
            
        }
        
        [self.view removeTipView];
        
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            [delegate editCodeDone] ;
        }];

        
        
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
    
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
        
             [delegate editCodeDone];
        
        }];
        
       
    }];
    
    codear=nil;
}

-(void)allSelectButtonClick
{
    [willdeleteAr removeAllObjects];
    for (Item_edit *item in dataAr) {
        if(allSelectButton.selected)
        {
            item.isChecked =NO;
        }else
        {
            item.isChecked =YES;
            [willdeleteAr addObject:item];
        }
    }
    
    [listmenu reloadData];
    [self setDeleButtonState];
}

-(void)deleButtonClick
{
    for (Item_edit *item in willdeleteAr) {
        [dataAr removeObject:item];
    }
    [willdeleteAr removeAllObjects];
    
    [listmenu reloadData];
    [self setDeleButtonState];
    
    
}

-(void)setDeleButtonState
{
    if([willdeleteAr count]==0)
    {
        [allSelectButton setSelected:NO];
        [allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
        
        [deleButton setEnabled:NO];
        [deleButton setTitle:@"删除自选" forState:UIControlStateNormal];
    }else
    {
        if([willdeleteAr count]==[dataAr count])
        {
            [allSelectButton setSelected:YES];
            [allSelectButton setTitle:@"取消" forState:UIControlStateNormal];
        }

        [deleButton setEnabled:YES];
        [deleButton setTitle:[NSString stringWithFormat:@"删除自选(%ld)",[willdeleteAr count]] forState:UIControlStateNormal];
    }
}

#pragma mark - privateMethod
-(void)headerRefreshing
{
    if(dataTask)
    {
        [dataTask cancel];
        dataTask=nil;
    }
    
    [self loadPriceData];
}

-(void)loadPriceData
{
    if(dataTask)
    {
        return;
    }
    NSArray *array = [GXUserdefult objectForKey:PersonSelectCodesKey];
    
    dataTask= [GXHttpTool POST:GXUrl_quotation parameters:@{@"code":[array componentsJoinedByString:@","]} success:^(id responseObject) {
        [self dataTaskSuccess:responseObject];
    } failure:^(NSError *error) {if(error.code!=-999){
        [self dataTaskError];
    }
    }];
    
}
-(void)dataTaskError
{
    dataTask=nil;
    
    if([listmenu.mj_header isRefreshing])
        [listmenu.mj_header endRefreshing];
    
}

-(void)dataTaskSuccess:(id)responseObject
{
    if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
    {
        NSArray *ar=[PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
       
        [dataAr removeAllObjects];
        
        for (PriceMarketModel *model in ar) {
            
            Item_edit *item = [[Item_edit alloc] init];
            item.priceModel = model;
            item.isChecked = NO;
            [dataAr addObject:item];
        }
        
        
        willdeleteAr=[[NSMutableArray alloc] init];
        
        //使点击初始化为no
        for (Item_edit *dd in dataAr) {
            dd.isChecked=NO;
        }

        
        [listmenu reloadData];
    }
    
    dataTask=nil;
    
    if([listmenu.mj_header isRefreshing])
        [listmenu.mj_header endRefreshing];
}

#pragma mark - TableView

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
//移动cell时的操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    if (sourceIndexPath != destinationIndexPath) {
        id object = [dataAr objectAtIndex:sourceIndexPath.row];
        
        [dataAr removeObjectAtIndex:sourceIndexPath.row];
        
        
        if (destinationIndexPath.row > [dataAr count]) {
            [dataAr addObject:object];
        }
        else {
            [dataAr insertObject:object atIndex:destinationIndexPath.row];
        }
    }
    
    [listmenu reloadData];

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataAr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"edit";
    GXPriceListEditTableViewCell *cell = (GXPriceListEditTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GXPriceListEditTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.delegate=(id)self;
    }
    
    Item_edit* item = [dataAr objectAtIndex:indexPath.row];
    PriceMarketModel *model=item.priceModel;
    
    cell.codename.text=model.name;
    cell.exname.text=model.exname;
   // cell.exname.hidden=model.isHiddenPme;

    [cell setChecked:item.isChecked];
    
    
    cell.topButton.tag=indexPath.row +10000;
    cell.deleButton.tag=indexPath.row +20000;
    cell.rootScr.tag=indexPath.row +30000;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(!headview)
    {
        int width1=38;
        int width2=40;
        
        headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 40)];
        headview.backgroundColor=priceEditList_color_cellTitleBackg;
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(width1+15, 0, 100, headview.frame.size.height)];
        name.text=@"交易品种";
        name.textColor=priceEditList_color_cellTitleText;
        name.font=GXFONT_PingFangSC_Regular(15);
        [headview addSubview:name];
        
        UILabel *top=[[UILabel alloc]initWithFrame:CGRectMake(width1+(headview.frame.size.width-width1-width2)*0.75-25, 0, 50, headview.frame.size.height)];
        top.text=@"置顶";
        top.textColor=priceEditList_color_cellTitleText;
        top.font=GXFONT_PingFangSC_Regular(15);
        top.textAlignment=NSTextAlignmentCenter;
        [headview addSubview:top];
        
        UILabel *drag=[[UILabel alloc]initWithFrame:CGRectMake(headview.frame.size.width-55, 0, 55, headview.frame.size.height)];
        drag.text=@"拖动";
        drag.textColor=priceEditList_color_cellTitleText;
        drag.font=GXFONT_PingFangSC_Regular(15);
        drag.textAlignment=NSTextAlignmentCenter;
        [headview addSubview:drag];
    }
    return headview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - cell delegate
-(void)tapRootScr:(id)sender
{
    UIScrollView *scr=sender;
    GXLog(@"%d",scr.tag);
    
    Item_edit* item = [dataAr objectAtIndex:scr.tag-30000];
    
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:scr.tag-30000 inSection:0];
    
    GXPriceListEditTableViewCell *cell = (GXPriceListEditTableViewCell*) [listmenu cellForRowAtIndexPath:index];
    item.isChecked = !item.isChecked;
    [cell setChecked:item.isChecked];
    
    
    //选中的将要删除的
    if([willdeleteAr containsObject:item])
    {
        [willdeleteAr removeObject:item];
    }else
    {
        [willdeleteAr addObject:item];
    }
    
    [self setDeleButtonState];
}

-(void)tapDeleButton:(id)sender
{
    UIButton *bb=sender;
    
    NSInteger a=bb.tag-20000;
    
    Item_edit* item = [dataAr objectAtIndex:a];
    
    if([willdeleteAr containsObject:item])
    {
        [willdeleteAr removeObject:item];
    }
    
    [dataAr removeObject:item];
    
    [listmenu reloadData];
    
    [self setDeleButtonState];
}

-(void)tapTopButton:(id)sender
{
    [listmenu reloadData];
    
    UIButton *bb=sender;
    
    NSInteger a=bb.tag-10000;
    
    id data=[dataAr objectAtIndex:a];
    
    [dataAr removeObjectAtIndex:a];
    
    [dataAr insertObject:data atIndex:0];
    
    
    NSIndexPath *i1=[NSIndexPath indexPathForRow:a inSection:0];
    NSIndexPath *i2=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [listmenu moveRowAtIndexPath:i1 toIndexPath:i2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

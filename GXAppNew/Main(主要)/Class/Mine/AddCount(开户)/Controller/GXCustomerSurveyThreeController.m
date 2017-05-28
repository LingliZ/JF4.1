//
//  GXCustomerSurveyThreeController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXCustomerSurveyThreeController.h"

@interface GXCustomerSurveyThreeController ()

@end
@implementation GXCustomerSurveyThreeController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isForAddAccount=YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"客户调查";
    [self.view addSubview:self.tableView_bottom];
    [self.tableView_bottom mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.label_instruct.mas_bottom).offset(24);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    self.arr_investTypes=[[NSMutableArray alloc]init];
    self.arr_investYears=[[NSMutableArray alloc]init];
    [self getInvestList];
}
-(GXMineBaseTableView*)tableView_bottom
{
    if(_tableView_bottom==nil)
    {
        _tableView_bottom=[[GXMineBaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView_bottom.separatorColor=[UIColor clearColor];
        _tableView_bottom.tableFooterView=self.view_footerView;
        _tableView_bottom.delegate=self;
        _tableView_bottom.dataSource=self;
    }
    return _tableView_bottom;
}
-(GXMineBaseView*)view_footerView
{
    if(_view_footerView==nil)
    {
        _view_footerView=[[GXMineBaseView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 66)];
        [_view_footerView addSubview:self.btn_next];
    }
    return _view_footerView;
}
-(GXMineInvestTypesView*)view_investTypes
{
    if(_view_investTypes==nil)
    {
        _view_investTypes=[[[NSBundle mainBundle]loadNibNamed:@"GXMineInvestTypesView" owner:self options:nil]lastObject];
        _view_investTypes.deleagte=self;
    }
    [_view_investTypes setModelsWithModelsArray:self.arr_investTypes];
    return _view_investTypes;
}
-(UIButton*)btn_next
{
    if(_btn_next==nil)
    {
        _btn_next=[UIButton buttonWithType:UIButtonTypeSystem];
        _btn_next.frame=CGRectMake(15, 0, GXScreenWidth-30, 46);
        [_btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
        [_btn_next setBackgroundColor:[UIColor getColor:@"4184F4"]];
        [UIView setBorForView:_btn_next withWidth:0 andColor:nil andCorner:5];
        [_btn_next setTitle:@"下一步" forState:UIControlStateNormal];
        [_btn_next addTarget:self action:@selector(btnClick_next) forControlEvents:UIControlEventTouchUpInside];
        _btn_next.titleLabel.font=[UIFont systemFontOfSize:16];
        [_btn_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _btn_next;
}
#pragma mark--UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return self.arr_investYears.count;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        GXMineInvestYearsModel*model_years=self.arr_investYears[indexPath.row];
        static NSString*cellName=@"cell";
        GXMineInvestExpirement*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if(cell==nil)
        {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"GXMineInvestExpirement" owner:self options:nil]lastObject];
        }
        cell.delegate=self;
        cell.indexPath=indexPath;
        [cell setModel:model_years];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        return self.view_investTypes;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        if(self.arr_investTypes.count==0)
        {
            return 0;
        }
        return 153;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark--GXInvestExpirementCellDelegate
-(void)selectInvestYearsWithTag:(NSInteger)tag andIndexPath:(NSIndexPath *)indexPath
{
    GXMineInvestYearsModel*model=self.arr_investYears[indexPath.row];
    model.selectedBtn=tag;
    [self.arr_investYears replaceObjectAtIndex:indexPath.row withObject:model];
}
#pragma mark--GXInvestTypesViewDelegte
-(void)selectInvestTypeWithValue:(BOOL)value andTag:(NSInteger)tag
{
    GXMineInvestTypeModel*model=self.arr_investTypes[tag];
    model.isSelect=value;
    [self.arr_investTypes replaceObjectAtIndex:tag withObject:model];
}
/*
 

 */
#pragma mark--获取投资经验相关数据
-(void)getInvestList
{
    [GXHttpTool POSTCache:GXUrl_getInvestList parameters:nil success:^(id responseObject) {
        NSString*success=[NSString stringWithFormat:@"%@",responseObject[@"success"]];
        if(success.intValue==1)
        {
            self.arr_investYears=[GXMineInvestYearsModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"][@"investYearList"]];
            self.arr_investTypes=[GXMineInvestTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"][@"investPreferenceList"]];
            [self.tableView_bottom reloadData];
            /*
            NSDictionary*valueDict=responseObject[@"value"];
            arrForInvestYearType=valueDict[@"investYearList"];
            arrForInvestPreference=[[NSMutableArray alloc]init];
            [arrForInvestPreference addObjectsFromArray:valueDict[@"investPreferenceList"]];
            [self addItemsForInvestExpirement];
            [self addItemsForInvestPreference];
             */
        }
        
    } failure:^(NSError *error) {
        
        //[self getInvestList];
    }];
}
#pragma mark--下一步
-(void)btnClick_next
{
    [self saveDataForInvestExpirement];
}
-(void)saveDataForInvestExpirement
{
    NSMutableDictionary*commitDic=[[NSMutableDictionary alloc]initWithDictionary:[GXUserdefult objectForKey:AddCountParams]];
    /*
     投资年限
     */
    NSInteger investYears=0;
    for(GXMineInvestYearsModel*model in self.arr_investYears)
    {
        if(model.selectedBtn!=0)
        {
            commitDic[model.name]=@"1";
        }
        else
        {
            commitDic[model.name]=@"0";
        }
        commitDic[model.year]=[NSString stringWithFormat:@"%ld",model.selectedBtn];
        investYears+=model.selectedBtn;
    }
    if(investYears<5)
    {
        [self.view showFailWithTitle:@"投资累计经验必须大于5年"];
        return;
    }
    /*
     投资偏好
     */
    NSInteger investTypes=0;
    for(GXMineInvestTypeModel*model in self.arr_investTypes)
    {
        if(model.isSelect)
        {
            commitDic[model.name]=@"1";
            investTypes+=1;
        }
        else
        {
            commitDic[model.name]=@"0";
        }
    }
    if(investTypes==0)
    {
        [self.view showFailWithTitle:@"请选择至少一种投资目的"];
        return;
    }
    [GXUserdefult setObject:commitDic forKey:AddCountParams];
    GXAddCountSelectBankController*selectVC=[[GXAddCountSelectBankController alloc]init];
    [self.navigationController pushViewController:selectVC animated:YES];

}
@end

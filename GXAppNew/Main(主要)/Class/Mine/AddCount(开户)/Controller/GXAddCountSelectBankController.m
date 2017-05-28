//
//  GXAddCountSelectBankController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAddCountSelectBankController.h"

@interface GXAddCountSelectBankController ()

@end

@implementation GXAddCountSelectBankController
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
    [self createUI];
    [self loadDataForBankList];
}
-(void)createUI
{
    self.title=@"选择银行";
    [self.view addSubview:self.tableView_bottom];
}
-(GXMineBaseTableView*)tableView_bottom
{
    if(_tableView_bottom==nil)
    {
        _tableView_bottom=[[GXMineBaseTableView alloc]initWithFrame:CGRectMake(0, 62+33, GXScreenWidth, GXScreenHeight-62-33) style:UITableViewStylePlain];
        _tableView_bottom.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        _tableView_bottom.separatorColor=[UIColor clearColor];
        _tableView_bottom.delegate=self;
        _tableView_bottom.dataSource=self;
    }
    return _tableView_bottom;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellName=@"cell";
    GXMineBankCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GXMineBankCell" owner:self options:nil]lastObject];
    }
    GXMineBankModel*model=self.dataSource[indexPath.row];
    [cell setModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GXMineBankModel*model=self.dataSource[indexPath.row];
    NSMutableDictionary*commiteparamsDic=[[NSMutableDictionary alloc]initWithDictionary:[GXUserdefult objectForKey:AddCountParams]];
    commiteparamsDic[@"bankId"]=model.value;
    [GXUserdefult setObject:commiteparamsDic forKey:AddCountParams];
    GXVertyBankCardController*vertyBankVC=[[GXVertyBankCardController alloc]init];
    vertyBankVC.model=model;
    [self.navigationController pushViewController:vertyBankVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*footView=[[UIView alloc]init];
    UILabel*titleLabel=[[UILabel alloc]init];
    titleLabel.text=@"如果您没有以上银行的借记卡，可以联系客服进行线下开户";
    titleLabel.textColor=[UIColor lightGrayColor];
    titleLabel.font=[UIFont systemFontOfSize:12];
    NSMutableAttributedString*attributrStr=[[NSMutableAttributedString alloc]initWithString:titleLabel.text];
    [attributrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(16, 4)];
    titleLabel.numberOfLines=0;
    titleLabel.attributedText=attributrStr;
    [footView addSubview:titleLabel];
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@19);
        make.right.mas_equalTo(@(-19));
        make.centerY.mas_equalTo(@0);
    }];
    UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(turnToOnlineService) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    return footView;
}
-(void)turnToOnlineService
{
    ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
    [self.navigationController pushViewController:onlineVC animated:YES];
}

-(void)loadDataForBankList
{
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
    {
        //齐鲁
        [params setObject:@"qiluce" forKey:@"type"];
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForTianjin])
    {
        //天津
        [params setObject:@"tjpme" forKey:@"type"];
    }
    [GXHttpTool POSTCache:GXUrl_getBankList parameters:params success:^(id responseObject) {
        GXLog(@"银行获取列表为：%@",responseObject);
        NSString*success=[NSString stringWithFormat:@"%@",responseObject[@"success"]];
        if(success.intValue==1)
        {
            self.dataSource=[[NSArray alloc]init];
            self.dataSource=[GXMineBankModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            [self.tableView_bottom reloadData];
        }
        
    } failure:^(NSError *error) {
        
        [self loadDataForBankList];
    }];

}


@end

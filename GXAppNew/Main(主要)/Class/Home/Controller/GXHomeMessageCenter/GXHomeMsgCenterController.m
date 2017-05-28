//
//  GXHomeMsgCenterController.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/13.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeMsgCenterController.h"
#import "GXInstantAdviceListController.h"
#import "GXConsultantReplyViewController.h"
#import "GXMessagesController.h"
#import "GXPriceWarningController.h"
#import "GXHomeMsgCenterCell.h"

@interface GXHomeMsgCenterController ()

@property (nonatomic,strong)NSMutableArray *dateSourceArray;
@property (nonatomic,strong)NSMutableArray *imagesSourceArray;
@property (nonatomic,strong)NSArray *messagesArray;
@property (nonatomic,strong)GXHomeMsgCenterCell *cell;
@property (nonatomic,assign)NSInteger suggestCount;
@property (nonatomic,assign)NSInteger replayCount;
@property (nonatomic,assign)NSInteger priceWarnCount;
@property (nonatomic,assign)NSInteger gxMsgCount;

@property (nonatomic,strong)NSString *suggestLocalStr;
@property (nonatomic,strong)NSString *replayLocalStr;
@property (nonatomic,strong)NSString *gxMsgLocalStr;
@property (nonatomic,strong)NSString *priceWarnLocalStr;

@end

@implementation GXHomeMsgCenterController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _suggestCount = [GXUserInfoTool getSuggestNum];
    _replayCount = [GXUserInfoTool getReplyNum];
    _priceWarnCount = [GXUserInfoTool getAlarmNum];
    _gxMsgCount = [GXUserInfoTool getGXMessageNum];
    [self loadData];
}
-(void)loadData{
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    [self getNewMessages];
    self.dateSourceArray = [NSMutableArray arrayWithObjects:@"即时建议",@"顾问回复",@"国鑫消息",@"报价提醒", nil];
    self.imagesSourceArray = [NSMutableArray arrayWithObjects:@"msg_realtime_pic",@"msg_guwenreplay_pic",@"msg_gxmsg_pic",@"msg_warnprice_pic", nil];
    self.messagesArray = @[self.suggestLocalStr,self.replayLocalStr,self.gxMsgLocalStr,self.priceWarnLocalStr];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = GXHomeBackGroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"GXHomeMsgCenterCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXHomeMsgCenterCell"];
}
-(void)getNewMessages{
    NSString *suggestStr = [GXUserdefult objectForKey:suggestLocalMsg];
    if (![suggestStr isEqualToString:self.suggestLocalStr] && suggestStr != nil) {
        self.suggestLocalStr = suggestStr;
        [GXUserdefult setObject:self.suggestLocalStr forKey:@"suggestLocalStr"];
        [GXUserdefult synchronize];
    }else{
        self.suggestLocalStr = @"您没有未读的即时建议";
    }
    NSString *replaytStr = [GXUserdefult objectForKey:replyLocalMsg];
    if (![replaytStr isEqualToString:self.replayLocalStr] && replaytStr != nil) {
        self.replayLocalStr = replaytStr;
        [GXUserdefult setObject:self.replayLocalStr forKey:@"replayLocalStr"];
        [GXUserdefult synchronize];
    }else{
        self.replayLocalStr = @"您没有未读的顾问回复";
    }
    NSString *gxMsgStr = [GXUserdefult objectForKey:GXMessageLocalMsg];
    if (![gxMsgStr isEqualToString:self.gxMsgLocalStr] && gxMsgStr != nil) {
        self.gxMsgLocalStr = gxMsgStr;
        [GXUserdefult setObject:self.gxMsgLocalStr forKey:@"gxMsgLocalStr"];
    }else{
        self.gxMsgLocalStr = @"您没有未读的国鑫消息";
    }
    NSString *priceStr = [GXUserdefult objectForKey:priceAlarmLocalMsg];
    if (![priceStr isEqualToString:self.priceWarnLocalStr] && priceStr != nil) {
        self.priceWarnLocalStr = priceStr;
    }else{
        self.priceWarnLocalStr = @"您没有未读的报价提醒";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dateSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [tableView dequeueReusableCellWithIdentifier:@"GXHomeMsgCenterCell" forIndexPath:indexPath];
    self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cell.imgView.image = [UIImage imageNamed:self.imagesSourceArray[indexPath.row]];
    self.cell.titleLabel.text = self.dateSourceArray[indexPath.row];
    self.cell.warnLabel.tag = indexPath.row;
    self.cell.desLabel.text = self.messagesArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (self.suggestCount == 0) {
                self.cell.warnLabel.hidden = YES;
            }else{
                self.cell.warnLabel.hidden = NO;
                self.cell.warnLabel.text = [NSString stringWithFormat:@"%ld",self.suggestCount];
            }
        }
            break;
        case 1:
        {
            if (self.replayCount == 0) {
                self.cell.warnLabel.hidden = YES;
            }else{
                self.cell.warnLabel.hidden = NO;
                self.cell.warnLabel.text = [NSString stringWithFormat:@"%ld",self.replayCount];
            }
        }
            break;
        case 2:
        {
            if (self.gxMsgCount == 0) {
                self.cell.warnLabel.hidden = YES;
            }else{
                self.cell.warnLabel.hidden = NO;
                self.cell.warnLabel.text = [NSString stringWithFormat:@"%ld",self.gxMsgCount];
            }
        }
            break;
        case 3:
        {
            if (self.priceWarnCount == 0) {
                self.cell.warnLabel.hidden = YES;
            }else{
                self.cell.warnLabel.hidden = NO;
                self.cell.warnLabel.text = [NSString stringWithFormat:@"%ld",self.priceWarnCount];
            }
        }
        default:
            break;
    }
    return self.cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {        //即时建议
        [MobClick event:@"jsjy_message"];
        [self.navigationController pushViewController:[[GXInstantAdviceListController alloc]init] animated:YES];
    }else if (indexPath.row == 1){  //顾问回复
        [MobClick event:@"gwhf_message"];
        [self.navigationController pushViewController:[[GXConsultantReplyViewController alloc]init] animated:YES];
    }else if (indexPath.row == 2){  //国鑫消息
        [MobClick event:@"gxxx_message"];
        [self.navigationController pushViewController:[[GXMessagesController alloc]init] animated:YES];
    }else{                          //报价提醒
        [MobClick event:@"bjtx_message"];
        [self.navigationController pushViewController:[[GXPriceWarningController alloc]init] animated:YES];
    }
}
@end

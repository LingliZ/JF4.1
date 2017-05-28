//
//  GXsxbrmeSignSuccessViewController.m
//  GXAppNew
//
//  Created by shenqilong on 17/2/11.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXsxbrmeSignSuccessViewController.h"
#import "AccountDetailConst.h"
#import "ChatViewController.h"

@interface GXsxbrmeSignSuccessViewController ()

@end

@implementation GXsxbrmeSignSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"提交激活";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIImageView *imv=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 85, 85)];
    imv.image=[UIImage imageNamed:@"mine_addShanxiSucessMark"];
    [self.view addSubview:imv];
    
    imv.center=CGPointMake(GXScreenWidth/2.0, 80);

    
    UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(0, imv.frame.origin.y+imv.frame.size.height+10, GXScreenWidth, 30)];
    lb.textColor=[UIColor blackColor];
    lb.font=GXFONT_PingFangSC_Regular(20);
    lb.textAlignment=NSTextAlignmentCenter;
    lb.adjustsFontSizeToFitWidth=YES;
    [self.view addSubview:lb];
    
    lb.text=[NSString stringWithFormat:@"您的交易帐号：%@",self.value[@"account"]];

    
    
    UILabel *lb2=[[UILabel alloc]initWithFrame:CGRectMake(50, lb.frame.origin.y+lb.frame.size.height+20, GXScreenWidth-100, 50)];
    lb2.textColor=[UIColor blackColor];
    lb2.font=GXFONT_PingFangSC_Regular(16);
    lb2.textAlignment=NSTextAlignmentCenter;
    lb2.adjustsFontSizeToFitWidth=YES;
    lb2.text=@"恭喜您完成网上签约！稍后您的客户经理会联系您办理后续激活流程。";
    lb2.numberOfLines=0;
    lb2.lineBreakMode=NSLineBreakByWordWrapping;
    [self.view addSubview:lb2];
    
    
    UIButton *signButton=[[UIButton alloc]initWithFrame:CGRectMake(77, lb2.frame.origin.y+lb2.frame.size.height+20, GXScreenWidth-77*2, 46)];
    [signButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signButton.titleLabel.font=GXFONT_PingFangSC_Regular(16);
    [signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    signButton.layer.masksToBounds=YES;
    signButton.layer.cornerRadius=6;
    signButton.backgroundColor=RGBACOLOR(83, 142, 235, 1);
    signButton.enabled=YES;
    
    [self.view addSubview:signButton];
    

    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:GXAccountDetail_serviceImageName] style:0 target:self action:@selector(rightBtn)];
    
    self.navigationItem.rightBarButtonItem=right;

    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.vc removeFromParentViewController];
    [self.vc2 removeFromParentViewController];

}

-(void)rightBtn
{
    //在线客服
    ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
    [self.navigationController pushViewController:onlineVC animated:YES];
}

-(void)signButtonClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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

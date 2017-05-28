//
//  GXCustomerSurveyOneController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXCustomerSurveyOneController.h"

@interface GXCustomerSurveyOneController ()

@end

@implementation GXCustomerSurveyOneController
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
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForShanxi])
    {
        self.label_mark_step4.text=@"完成开户";
    }
}
- (IBAction)btnClick_beginSurvey:(UIButton *)sender {
    GXCustomerSurveyTwoController*surveyVC=[[GXCustomerSurveyTwoController alloc]init];
    [self.navigationController pushViewController:surveyVC animated:YES
     ];
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

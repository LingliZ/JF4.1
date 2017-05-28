//
//  GXFeedBackController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXFeedBackController.h"

@interface GXFeedBackController ()

@end

@implementation GXFeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editClick) name:UITextViewTextDidChangeNotification object:nil];
    [self createUI];
}
-(void)createUI
{
    self.title=@"意见反馈";
    [UIView setBorForView:self.btn_commite withWidth:0 andColor:nil andCorner:5];
    self.TV_content.delegate=self;
//    [self.btn_commite setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_commite setBtn_nextControlStateDisabled];
}
-(void)editClick
{
    if(self.TV_content.text.length==0)
    {
        self.btn_commite.enabled=NO;
        self.label_placeholder.hidden=NO;
    }
    else
    {
        self.btn_commite.enabled=YES;
        self.label_placeholder.hidden=YES;
    }
    self.label_numbersOfContent.text=[NSString stringWithFormat:@"%ld/400",self.TV_content.text.length];
}
-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>400)
    {
        textView.text=[textView.text substringToIndex:400];
    }
}
- (IBAction)btnClick_commite:(UIButton *)sender {
    NSDictionary*params=@{
                          @"content":self.TV_content.text,
                          };
    [self.view showLoadingWithTitle:@"正在提交"];
    [GXHttpTool POST:GXUrl_feedBack parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]integerValue])
        {
            [self.view showSuccessWithTitle:@"恭喜你已提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.label_placeholder.hidden=NO;
                self.TV_content.text=@"";
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"提交失败，请检查网络设置"];
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

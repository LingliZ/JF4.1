//
//  GXAlertTestController.m
//  GXAppNew
//
//  Created by 王振 on 2017/1/22.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAlertTestController.h"

@interface GXAlertTestController ()
/** 蒙版 */
@property (nonatomic, strong) UIView *coverView;
/** 弹框 */
@property (nonatomic, strong) UIView *alertView;
/** 点击确定回调的block */
@property (nonatomic, copy) WZBlock block;

@end

@implementation GXAlertTestController


+(instancetype)shareManager{
    static GXAlertTestController *alertController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (alertController == nil) {
            alertController = [[GXAlertTestController alloc]init];
        }
    });
    return alertController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)alertViewWithMessage:(NSString *)messageStr WithTitle:(NSString *)titleStr WithBlock:(WZBlock)block{
    self.block = block;
    //创建蒙版
    UIView * coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.coverView = coverView;
    [self.view addSubview:coverView];
    coverView.backgroundColor = GXRGBColor(235, 235, 235);
    coverView.alpha = 0.2;
    
    //创建提示框view
    UIView * alertView = [[UIView alloc] init];
    alertView.backgroundColor = self.alertBackgroundColor;
    //设置圆角半径
    alertView.layer.cornerRadius = 6.0;
    self.alertView = alertView;
    [self.view addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@WidthScale_IOS6(70));
        make.right.equalTo(@(-WidthScale_IOS6(70)));
        make.height.equalTo(@140);
        make.center.equalTo(coverView);
    }];
    //创建操作提示 label
    UILabel * label = [[UILabel alloc] init];
    [alertView addSubview:label];
    label.text = titleStr;
    label.font = [UIFont systemFontOfSize:19];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@22);
    }];
    //创建message label
    UILabel * lblMessage = [[UILabel alloc] init];
    lblMessage.textColor = self.messageColor;
    [alertView addSubview:lblMessage];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[messageStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    lblMessage.attributedText = attributedString;
//    lblMessage.text = messageStr;
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.numberOfLines = 2; //最多显示两行Message
    [lblMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@50);
    }];
    //创建中间灰色分割线
    UIView * separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor grayColor];
    [alertView addSubview:separateLine];
    [separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@-45);
        make.height.equalTo(@1);
    }];
    UIView * verViewLine = [[UIView alloc]init];
    separateLine.backgroundColor = [UIColor grayColor];
    [alertView addSubview:verViewLine];
    [verViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.top.equalTo(separateLine.mas_bottom).offset(0);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(separateLine);
    }];
    //创建确定 取消按钮
    UIButton * btnCancel = [[UIButton alloc] init];
    [alertView addSubview:btnCancel];
    [btnCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnCancel.titleLabel.font = GXFONT_PingFangSC_Medium(GXFitFontSize20);
    [btnCancel setTitle:@"我知道了" forState:UIControlStateNormal];
    [btnCancel setBackgroundColor:self.btnCancelBackgroundColor];
    btnCancel.tag = 0;
    [btnCancel addTarget:self action:@selector(didClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    //确定按钮
    UIButton * btnConfirm = [[UIButton alloc] init];
    btnConfirm.tag = 1;
    [alertView addSubview:btnConfirm];
    [btnConfirm setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnConfirm setTitle:@"查看详情" forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = GXFONT_PingFangSC_Medium(GXFitFontSize20);
    [btnConfirm setBackgroundColor:self.btnConfirmBackgroundColor];
    [btnConfirm addTarget:self action:@selector(didClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.top.equalTo(separateLine.mas_bottom).offset(0);
        make.right.equalTo(verViewLine.mas_left).offset(0);
    }];
    [btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verViewLine.mas_right).offset(0);
        make.top.equalTo(separateLine.mas_bottom).offset(0);
        make.right.bottom.equalTo(@0);
    }];
}
//btn点击事件
-(void)didClickBtnConfirm:(UIButton *)sender{
    if (sender.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    self.block(1);
    [self dismissViewControllerAnimated:YES completion:nil];
}
//alertView背景颜色
-(UIColor *)alertBackgroundColor{
    
    if (_alertBackgroundColor == nil) {
        _alertBackgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    }
    return _alertBackgroundColor;
}

/** 确定按钮背景色 */
-(UIColor *)btnConfirmBackgroundColor{
    
    if (_btnConfirmBackgroundColor == nil) {
        _btnConfirmBackgroundColor = [UIColor whiteColor];
    }
    return _btnConfirmBackgroundColor;
}

/** 取消按钮背景色 */
-(UIColor *)btnCancelBackgroundColor{
    
    if (_btnCancelBackgroundColor == nil) {
        _btnCancelBackgroundColor = [UIColor whiteColor];
    }
    return _btnCancelBackgroundColor;
}

/** message字体颜色 */
-(UIColor *)messageColor{
    
    if (_messageColor == nil) {
        _messageColor = [UIColor blackColor];
    }
    return _messageColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

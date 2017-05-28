//
//  GXPriceRemindController.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/17.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXPriceRemindController.h"

#import "GXPriceRemindModel.h"
#import "GXPriceRemindParam.h"
#import <IQKeyboardManager/IQKeyboardManager.h>



@interface GXPriceRemindController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *codeNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *upperSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lowerSwtich;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *upperTextInput;
@property (weak, nonatomic) IBOutlet UITextField *lowerTextInput;


@property (nonatomic, strong) GXPriceRemindModel *remindResult;
@property (nonatomic, strong) GXPriceRemindParam *remindParam;


@property (nonatomic, assign) BOOL isHaveDian;

@end

@implementation GXPriceRemindController {
    NSTimer *timer;
    
}

#pragma mark - getter
- (GXPriceRemindParam *)remindParam {
    if (!_remindParam) {
        _remindParam = [[GXPriceRemindParam alloc] init];
    }
    return _remindParam;
}


- (GXPriceRemindModel *)remindResult {
    if (!_remindResult) {
        _remindResult = [[GXPriceRemindModel alloc] init];
    }
    return _remindResult;
}


#pragma mark - lifeCircle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    } else {
        [self loadData2secondsInterval];
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadData2secondsInterval) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"报价提醒";
    
    [self renderUI];
    
    [self loadData];
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    self.remindParam.code = self.marketModel.code;
    self.remindParam.upperBound = self.upperTextInput.text;
    self.remindParam.lowerBound = self.lowerTextInput.text;
    
    self.remindParam.upperOn = self.upperSwitch.on;
    self.remindParam.lowerOn = self.lowerSwtich.on;
    
    self.upperTextInput.tag = 100;
    self.lowerTextInput.tag = 101;
    
    [GXHttpTool POST:GXUrl_QuotationReminderSet parameters:self.remindParam.mj_keyValues success:^(id responseObject) {
        DLog(@"%@",responseObject);
    } failure:^(NSError *error) {
    }];
   
    [IQKeyboardManager sharedManager].enable = NO;
    
}

#pragma mark - render UI
- (void)renderUI {
    
    self.codeNameLabel.text = self.marketModel.name;
    
    self.upperTextInput.delegate = self;
    self.lowerTextInput.delegate = self;
    
    [self.upperTextInput addTarget:self action:@selector(upperChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.lowerTextInput addTarget:self action:@selector(lowerChanged:) forControlEvents:UIControlEventEditingChanged];
}



- (void)upperChanged:(UITextField *)textfield {

    if (textfield.text.length != 0) {
        [self.upperSwitch setOn:YES animated:YES];
    } else {
        [self.upperSwitch setOn:NO animated:YES];
    }
}

- (void)lowerChanged:(UITextField *)textfield {
    
    if (textfield.text.length != 0) {
        [self.lowerSwtich setOn:YES animated:YES];
    } else {
        [self.lowerSwtich setOn:NO animated:YES];
    }
}



#pragma mark - privateMethod
- (void)loadData {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"code"] = self.marketModel.code;
    [GXHttpTool POST:GXUrl_QuotationReminderFetch parameters:param success:^(id responseObject) {
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
            self.remindResult = [GXPriceRemindModel mj_objectWithKeyValues:responseObject[GXValue]];
            self.upperSwitch.on = ([self.remindResult.upperBound integerValue] > 0) ? YES : NO;
            self.upperTextInput.text = self.remindResult.upperBound;
            
            self.lowerSwtich.on = ([self.remindResult.lowerBound integerValue] > 0) ? YES : NO;
            self.lowerTextInput.text = self.remindResult.lowerBound;
            
        } else {
    
        }
        
        
        
    } failure:^(NSError *error) {
        
        GXLog(@"%@",error);
    }];
    
}


- (void)loadData2secondsInterval {
    
    NSString *code = self.marketModel.code;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"code"] = code;
    
    [GXHttpTool POSTCache:GXUrl_quotation parameters:param success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[GXSuccess] integerValue] == 1) {
            
            self.marketModel = [PriceMarketModel mj_objectWithKeyValues:responseObject[GXValue][0]];
            
            self.valueLabel.text = self.marketModel.last;
            self.valueLabel.textColor = self.marketModel.increaseBackColor;
            
            self.rateLabel.text = self.marketModel.increasePercentage;
            self.rateLabel.textColor = self.marketModel.increaseBackColor;
        }
        
    } failure:^(NSError *error) {
    }];
}

#pragma mark - event reponse
- (IBAction)upperSwtichAction:(UISwitch *)sender {
    self.remindParam.upperOn = sender.isOn;
    
    DLog(@"%d",self.remindParam.upperOn);
}

- (IBAction)lowerSwtichAction:(UISwitch *)sender {
    self.remindParam.lowerOn = sender.isOn;
}




#pragma mark - UITextfiled代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        _isHaveDian=NO;
    }
    
    
    if ([string length]>0) {
        
        // 判断总体
        if ([textField.text length] >= 11) {
            GXLog(@"输入过大查询不到");
            return NO;
        }
        
        
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.') {//数据格式正确
            //首字母不能为0和小数点
            if([textField.text length] == 0) {
                
                if(single == '.') {
                    GXLog(@"第一个数字不能为小数点");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            
            if (single=='.') {
                if(!_isHaveDian) { //text中还没有小数点
                    _isHaveDian = YES;
                    return YES;
                } else {
                    GXLog(@"您已经输入过小数点了");
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            } else {
                if (_isHaveDian) { //存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    long tt = range.location - ran.location;
                    if (tt <= 4){
                        return YES;
                    } else {
                        GXLog(@"您最多输入四位小数");
                        return NO;
                    }
                }
                else {
                    
                    if ([textField.text length] >= 6) {
                        GXLog(@"最多整数输入5位");
                        return NO;
                    }
                    
                    return YES;
                }
            }
            
        } else { //输入的数据格式不正确
            GXLog(@"您输入的格式不正确");
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else {
        return YES;
    }
    
}



@end

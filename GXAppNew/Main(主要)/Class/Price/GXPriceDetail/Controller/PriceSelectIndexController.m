//
//  PriceSelectIndexController.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "PriceSelectIndexController.h"
#import "PriceIndexPickView.h"
#import "PriceIndexTool.h"


#define PickView_Height 40.f

@interface PriceSelectIndexController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIWebViewDelegate>

@property (nonatomic, strong) UIPickerView *pcikView;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *describeArray;
@property (nonatomic, assign) KLineChartBottomType bottomType;
@property (nonatomic, strong) UIWebView *webView;



@end

@implementation PriceSelectIndexController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = ThemeBlack_Color;
    self.webView = webView;
    [self.view addSubview:webView];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 200, 0));
    }];
    
    self.nameArray = @[@"MACD",
                       @"KDJ",
                       @"RSI",
                       @"ADX",
                       @"ATR"];
    
    self.describeArray = @[@"平滑移动平均",
                       @"随机指标",
                       @"相对强弱指标",
                       @"平均趋向指标",
                       @"真实波动范围"];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, GXScreenHeight - 300, GXScreenWidth, 300)];
    pickerView.tag = 1000;

    //指定Picker的代理
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:0 inComponent:0 animated:YES];
    [self loadHtml:0];
    
    //是否要显示选中的指示器(默认值是NO)
    pickerView.showsSelectionIndicator = NO;
    
    [self.view addSubview:pickerView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pickerView.mas_centerY);
        make.right.mas_equalTo(pickerView.mas_right).offset(-40);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
    btn.backgroundColor = GXRGBColor(64, 129, 243);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 6;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];


}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"rewrite();"];
}


- (void)btnAction: (UIButton *)sender {

    self.selecBlock(self.bottomType);
    [self.navigationController popViewControllerAnimated:YES];
}





- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.nameArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return PickView_Height;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return GXScreenWidth;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    PriceIndexPickView *indexView = [[PriceIndexPickView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, PickView_Height)];
    indexView.labele1.text = self.nameArray[row];
    indexView.labele2.text = self.describeArray[row];
    return indexView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self loadHtml:row];
    
    switch (row) {
        case 0: {
            self.bottomType = MACD;
            break;
        }
        case 1: {
            self.bottomType = KDJ;
            break;
        }
        case 2: {
            self.bottomType = RSI;
            break;
        }
        case 3: {
            self.bottomType = ADX;
            break;
        }
        case 4: {
            self.bottomType = ATR;
            break;
        }

        default:
            break;
    }
    
}



- (void)loadHtml:(NSInteger)row {

    NSString *path;
    
    switch (row) {
        case 0: {
            path = [[NSBundle mainBundle] pathForResource:@"index-macd" ofType:@"html"];
            break;
        }
        case 1: {
            path = [[NSBundle mainBundle] pathForResource:@"index-kdj" ofType:@"html"];
            break;
        }
        case 2: {
           path = [[NSBundle mainBundle] pathForResource:@"index-rsi" ofType:@"html"];
            break;
        }
        case 3: {
            path = [[NSBundle mainBundle] pathForResource:@"index-adx" ofType:@"html"];
            break;
        }
        case 4: {
            path = [[NSBundle mainBundle] pathForResource:@"index-atr" ofType:@"html"];
            break;
        }
            
        default:
            break;
    }
    
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:baseURL];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}



@end

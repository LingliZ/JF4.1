//
//  GXQuestionView.m
//  GXAppNew
//
//  Created by zhudong on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXQuestionView.h"
#import "GXLiveCommonSize.h"
#import "GXBottomBtn.h"
#import "GXQuestionCell.h"
#import "GXSuggestionView.h"
#import "GXCourseView.h"
#import "GXAskView.h"
#import "GXQuestion.h"
#import "GXSuggestionModel.h"
#import "UIView+GXNetError.h"
#import "PriceMarketModel.h"
#import "GXProductView.h"
#import "GXLoginByVertyViewController.h"
#import "GXUserInfoTool.h"

#define SpeakInterval 120
#define OpenABtnW 40
#define BottomOffset 30
#define AskViewW (GXScreenWidth - 2 * BtnWidth)
#define OffsetX 2


@interface GXQuestionView ()<UITableViewDelegate, UITableViewDataSource>
{
    int count;
    NSInteger selectedIndex;
}
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, weak) GXTextView *textView;
@property (nonatomic, assign) BOOL isEmoji;
@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic, strong) UITableView *questionTabelView;
@property (nonatomic, strong) UIButton *removeBtn;
@property (nonatomic,strong) MASConstraint *widthConst;
@property (nonatomic,strong) MASConstraint *offsetConst;
@property (nonatomic,strong) GXAskView *askView;
@property (nonatomic,strong) GXBottomBtn *suggestionBtn;
@property (nonatomic,strong) GXBottomBtn *courseBtn;
@property (nonatomic,strong) NSMutableArray *questionsArrayM;
@property (atomic,assign) BOOL isRefresh;
@property (nonatomic,assign) long long questionNewId;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *questionId;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSArray *productCodes;
@property (nonatomic,strong) NSTimer *productTimer;
@property (nonatomic,strong) NSTimer *msgTimer;
@property (atomic,assign) BOOL isMsgRefresh;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UILabel *nameL;
@property (nonatomic,strong) UILabel *priceL;
@property (nonatomic,strong) UILabel *dotL;
@property (nonatomic,strong) UILabel *percentL;
@property (atomic,assign) BOOL isTopBarRefresh;
@property (nonatomic,strong) UIView *topBarView;
@property (nonatomic,strong) UIView *topBarSubView;
@property (nonatomic,strong) UILabel *tipLable;
@property (nonatomic,assign) BOOL isShowedTip;
@property (nonatomic,strong) UIButton *openABtn;
@property (nonatomic,strong) NSNumber *startId;
@property (nonatomic,strong) GXSuggestionModel *model;
@property (nonatomic,strong) UILabel *msgLabel;


@end

@implementation GXQuestionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTimer) name:CloseTimerNotify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openTimer) name:OpenTimerNotify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBegin) name:TextViewBeginNotify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEnd) name:TextViewEndNotify object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:GXNotify_LoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAccount) name:GXLoadAccount object:nil];
        self.roomId = [GXUserdefult objectForKey:GXVideoRoomId];
        self.startId = [GXUserdefult objectForKey:GXSuggestionId];
        if (self.startId == nil) {
            self.startId = @0;
        }
        count = SpeakInterval;
        selectedIndex = -1;
        [self setupUI];
        self.isFirst = true;
        [self timer];
        [self productTimer];
        [self msgTimer];
    }
    return self;
}

- (void)loadAccount{
    self.openABtn.hidden = true;
    if (![GXUserInfoTool isLogin]) {
        self.openABtn.hidden = false;
        [self.openABtn setTitle:@"登录" forState:UIControlStateNormal];
    }else if([[GXUserdefult objectForKey:GXIsRealCustom] integerValue] == NO){
        if ([GXUserInfoTool isShowOpenAccount]) {
            self.openABtn.hidden = false;
            [self.openABtn setTitle:@"开户" forState:UIControlStateNormal];
        }else{
            self.openABtn.hidden = true;
        }
    }
}
- (void)loginSuccess{
    if([[GXUserdefult objectForKey:GXIsRealCustom] integerValue] == NO){
        self.openABtn.hidden = false;
        [self.openABtn setTitle:@"开户" forState:UIControlStateNormal];
    }else{
        self.openABtn.hidden = true;
    }
}
- (void)closeTimer{
    [self.timer invalidate];
    self.timer = nil;
    [self.productTimer invalidate];
    self.productTimer = nil;
    [self.msgTimer invalidate];
    self.msgTimer = nil;
}
- (void)openTimer{
    [self timer];
    [self productTimer];
    [self msgTimer];
}

- (void)showTip{
    if (self.questionsArrayM.count == 0) {
        UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, 50)];
        tipL.text = @"暂无最新消息";
        tipL.textColor = GXGrayColor;
        tipL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
        tipL.textAlignment = NSTextAlignmentCenter;
        self.questionTabelView.backgroundView = tipL;
        return ;
    }else{
        self.questionTabelView.backgroundView = nil;
    }
}

- (void)refreshQuestionData{
//    GXLog(@"timer");
    if (self.isRefresh) {
        return;
    }
    self.isRefresh = true;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"roomId"] = self.roomId;
    param[@"count"] = @(20);
    param[@"baseId"] = @(self.questionNewId);
    param[@"isRefresh"] = @(true);
//    GXLog(@"%@",param);
    [GXHttpTool Get:GXUrl_liveSpeakMsg parameters:param success:^(id responseObject) {
//        GXLog(@"%@",responseObject);
        self.isRefresh = false;
        
        if ([responseObject[@"success"] intValue] == 1) {
            [self showTip];
            NSArray *array = responseObject[@"value"];
            if (array.count == 0) {
                return;
            }
            
            NSMutableArray *arrM = [[NSMutableArray alloc] initWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GXQuestion *question = [[GXQuestion alloc] initWithDict:obj];
                [arrM insertObject:question atIndex:0];
            }];
            self.questionNewId = ((GXQuestion *)arrM.lastObject).questionNewId;
            [self.questionsArrayM addObjectsFromArray:arrM];
            
            if (self.questionsArrayM.count > 25) {
                NSRange range = NSMakeRange(0, self.questionsArrayM.count - 25);
                [self.questionsArrayM removeObjectsInRange:range];
            }
            
            [self.questionTabelView reloadData];
            [self showTip];
            @try {
                if (self.questionsArrayM.count > 3){
                    if ([self.questionId integerValue] == [((GXQuestion*)self.questionsArrayM.lastObject).id integerValue]) {
                        return;
                    }
                    self.questionId = ((GXQuestion*)self.questionsArrayM.lastObject).id;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.questionsArrayM.count - 1) inSection:0];
                    [self.questionTabelView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
                }
            } @catch (NSException *exception) {
                GXLog(@"%@", exception);
            } @finally {
                
            }
        }else {
            
            GXLog(@"服务器放回数据错误");
        }
    } failure:^(NSError *error) {
        self.isRefresh = false;
        GXLog(@"网络错误:%@",error);
    }];
}

#pragma mark - refreshTopBarData
- (void)refreshTopBarData{
    if (self.isTopBarRefresh) {
        return;
    }
    self.isTopBarRefresh = true;
    if (self.index >= self.productCodes.count) {
        self.index = 0;
    }
    NSDictionary *param = @{@"code":self.productCodes[self.index]};
    self.index++;
    __weak typeof(self) weakSelf = self;
    [GXHttpTool POST:GXUrl_quotation parameters:param success:^(id responseObject) {
        self.isTopBarRefresh = false;
        if ([responseObject[@"success"] integerValue] == 0) {
            return ;
        }
        typeof(self) strongSelf = weakSelf;
        PriceMarketModel *model = [[PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]] firstObject];
        [strongSelf addTopBarSubView:model];
    } failure:^(NSError *error) {
        GXLog(@"%@", error);
    }];
}

- (void)refreshMsgCount{
    if (self.isMsgRefresh) {
        return;
    }
    self.isMsgRefresh = true;
    NSDictionary *params = @{@"type":@8,@"roomId":self.roomId,@"startId":self.startId,@"count":@20,@"isMore":@0};
    [GXHttpTool POSTCache:GXUrl_liveCall parameters:params success:^(id responseObject) {
        self.isMsgRefresh = false;
        if ([responseObject[@"success"] intValue] == 0) return ;
        NSArray *array = responseObject[@"value"][@"resultList"];
        if (array.count == 0) {
            [self.msgLabel removeFromSuperview];
            return;
        }else{
            [self showMsgCount:array.count];
        }
        NSDictionary *dict = array.firstObject;
        self.model = [[GXSuggestionModel alloc] initWithDict:dict];
    } failure:^(NSError *error) {
        self.isMsgRefresh = false;
        GXLog(@"%@",error);
//        [self showErrorNetMsg:nil];
    }];
}

- (void)showMsgCount: (NSUInteger)count{
    [self.suggestionBtn addSubview:self.msgLabel];
    self.msgLabel.text = [NSString stringWithFormat:@"%zd", count];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.right.equalTo(@WidthScale_IOS6(-25));
        make.width.equalTo(@WidthScale_IOS6(20));
        make.height.equalTo(@WidthScale_IOS6(14));
    }];
}

- (void)setTopBar: (PriceMarketModel *)model{
    self.nameL.text = [NSString stringWithFormat:@"%@(%@)", model.name, model.exname];
    self.priceL.text = [NSString stringWithFormat:@"%@", model.last];
    self.dotL.text = [NSString stringWithFormat:@"%0.2f", [model.last floatValue] - [model.lastclose floatValue]];
    self.percentL.text = model.increasePercentage;
    
    self.priceL.textColor = model.lastColor;
    self.dotL.textColor = model.lastColor;
    self.percentL.textColor = model.lastColor;

}
- (void)sendMsg{
    
    if (![GXUserInfoTool isLogin]) {
        NSDictionary *dict = @{@"eventName":@"video_float_login"};
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotify object:nil userInfo:dict];
        return;
    }
    
    NSString *content = self.textView.fullText;
    if (content.length > 0) {
        if ([content hasPrefix:@"@"] && [content containsString:@" "]) {
            NSRange range = [content rangeOfString:@" "] ;
            content = [content substringFromIndex:(range.location + range.length)];
        }else{
            selectedIndex = -1;
        }
        NSMutableDictionary *paramQ = [[NSMutableDictionary alloc] init];
        paramQ[@"userType"] = @(1);
        paramQ[@"roomId"] = self.roomId;
//        GXLog(@"%@", self.roomId);
        paramQ[@"content"] = content;
        paramQ[@"roomType"] = @(1);
        if (selectedIndex <= 0) {
            paramQ[@"replyTo"] = @(0);
        }else{
            GXQuestion *selectedQ = self.questionsArrayM[selectedIndex];
//            paramQ[@"replyTo"] = [NSString stringWithFormat:@"%lld", selectedQ.questionNewId];
            paramQ[@"replyTo"] = selectedQ.id;
//            paramQ[@"userId"] = selectedQ.userId;
            paramQ[@"visitorName"] = selectedQ.nickName;
        }
        
        selectedIndex = -1;
        if (self.textView.isFullEmot) {
            //不审核
            paramQ[@"avoidAudit"] = @(1);
        }else{
            //审核
            paramQ[@"avoidAudit"] = @(0);
        }
        if (![GXUserInfoTool isLogin]) {
            paramQ[@"visitorName"] = [GXUserdefult objectForKey:GXVisitorName];
        }
        [self showTip];
        
        __weak typeof(self) weakSelf = self;
        [GXHttpTool POST:GXUrl_liveSpeakQ parameters:paramQ success:^(id responseObject) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSDictionary *dict = responseObject;
            NSString *msg = dict[@"message"];
            if(msg.length > 0){
                NSInteger errorCode = [dict[@"errCode"] integerValue];
                if (errorCode == 10100) {
                    [strongSelf showMsg:msg];
                }else if (errorCode == 10001){
                    [strongSelf showMsg:@"内容不能为空"];
                }
            }
            else if ([dict[@"success"] integerValue] == 1) {
                [strongSelf showMsg:@"发送消息成功"];
//                GXLog(@"发送消息成功");
            }else{
                [strongSelf showMsg:@"发送消息失败"];
//                GXLog(@"发送消息失败");
//                GXLog(@"%@",responseObject);
            }
        } failure:^(NSError *error) {
            [self showErrorNetMsg: @"信息发送不成功,网络连接失败"];
        }];
        self.textView.text = nil;
        [self.textView endEditing:YES];
    }else{
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertV show];
    }
    
}

- (void)showMsg: (NSString *)msg{
    if (self.isShowedTip) {
        return;
    }
    UILabel *label = [[UILabel alloc] init];
    label.text = msg;
    label.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    layer.frame = CGRectMake(-10, -10, label.size.width + 20, label.size.height + 20);
    layer.cornerRadius = 15;
    [label.layer addSublayer:layer];
    layer.masksToBounds = true;
    self.tipLable = label;
    
    [self addSubview:label];
    [self bringSubviewToFront:label];
    self.isShowedTip = true;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(self.btnView.mas_top).offset(-2*GXMargin);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tipLable removeFromSuperview];
        self.isShowedTip = false;
    });
}

#pragma mark - YYTextViewDelegate

- (void)textViewBegin{
    [self.widthConst uninstall];
    [self.offsetConst uninstall];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.askView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.widthConst = make.width.equalTo(@GXScreenWidth);
        }];
        [self.courseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
           self.offsetConst = make.right.equalTo(self.askView.mas_left);
        }];
        
        [self.btnView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)textViewEnd{
    [self.widthConst uninstall];
    [self.offsetConst uninstall];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.askView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.widthConst = make.width.equalTo(@(AskViewW + EmojiBtnW));
        }];
        [self.courseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            self.offsetConst = make.right.equalTo(self.askView.mas_left).offset(EmojiBtnW+OffsetX);
        }];
        //加效果
        [self.btnView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setupUI{
    UITableView *questionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    questionTableView.delegate = self;
    questionTableView.dataSource = self;
    questionTableView.estimatedRowHeight = 100;
    questionTableView.rowHeight = UITableViewAutomaticDimension;
    questionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    questionTableView.backgroundColor = BackgroundColor;
    questionTableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.questionTabelView = questionTableView;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesDid)];
    [questionTableView addGestureRecognizer:tapGes];
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    footerV.backgroundColor = BackgroundColor;
    questionTableView.tableFooterView = footerV;
    [self addSubview:questionTableView];
    [questionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-KeyBoardHeight);
    }];
    
    UIView *btnV = [[UIView alloc] init];
    [self addSubview:btnV];
    [btnV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(questionTableView.mas_bottom);
    }];
    btnV.backgroundColor = [UIColor blackColor];
    self.btnView = btnV;
    
    NSArray *titleArr = @[@"建议",@"节目表"];
    
    self.suggestionBtn = [self addBtnWithTitle:titleArr[0] imageName:@"newMsg" tag:10];
    self.courseBtn = [self addBtnWithTitle:titleArr[1] imageName:@"course" tag:20];
    self.askView = [[GXAskView alloc] init];
    self.textView = self.askView.textField;
    
    __weak typeof(self) weakSelf = self;
    self.askView.sendBtnClickDelegate = ^ void (NSString *contentStr){
        [weakSelf sendMsg];
    };
    
    [self.btnView addSubview:self.askView];
    self.suggestionBtn.backgroundColor = GXRGBColor(59, 62, 76);
    self.courseBtn.backgroundColor = GXRGBColor(59, 62, 76);
    [self.btnView addSubview:self.courseBtn];
    [self.btnView addSubview:self.suggestionBtn];
    CALayer *sepL = [CALayer layer];
    sepL.backgroundColor = GXRGBColor(51, 54, 67).CGColor;
    sepL.frame = CGRectMake(0, 0, GXScreenWidth, 0.5);
    [self.btnView.layer addSublayer:sepL];
    
    [self.askView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.btnView);
        self.widthConst = make.width.equalTo(@(AskViewW + EmojiBtnW));
    }];
    [self.courseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.btnView);
        self.offsetConst = make.right.equalTo(self.askView.mas_left).offset(EmojiBtnW + OffsetX);
        make.width.equalTo(@(BtnWidth));
    }];
    [self.suggestionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.btnView);
        make.right.equalTo(self.courseBtn.mas_left).offset(WidthScale_IOS6(25));
        make.width.equalTo(@(BtnWidth + WidthScale_IOS6(25) + OffsetX));
    }];
    
    UIView *topBarView = [[UIView alloc] init];
    [self addSubview:topBarView];
    self.topBarView = topBarView;
    topBarView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    [topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@TopBarHeight);
    }];
    
    //60 162 248
    UIButton *openABtn = [[UIButton alloc] init];
    openABtn.backgroundColor = GXRGBColor(60, 126, 248);
    openABtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.openABtn = openABtn;
    openABtn.layer.cornerRadius = OpenABtnW * 0.5;
    openABtn.layer.masksToBounds = true;
    [self addSubview:openABtn];
    [self bringSubviewToFront:openABtn];
    [openABtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-BottomOffset));
        make.bottom.equalTo(self.btnView.mas_top).offset(-BottomOffset);
        make.width.height.equalTo(@(OpenABtnW));
    }];
    openABtn.hidden = true;
    [openABtn addTarget:self action:@selector(openABtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 未登录状态下添加底部横条
    self.bottomToastTitle = [[[NSBundle mainBundle] loadNibNamed:@"GXBottomToastTitle" owner:self options:nil] lastObject];
    [self addSubview:self.bottomToastTitle];
    [self.bottomToastTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.height.mas_equalTo(@40);
    }];
}


- (void)openABtnClick: (UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"开户"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GXOpenRealAccountNotify object:nil];
    }else if ([btn.titleLabel.text isEqualToString:@"登录"]){
        NSDictionary *dict = @{@"eventName":@"video_float_login"};
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotify object:nil userInfo:dict];
    }
}
- (void)addTopBarSubView: (PriceMarketModel *) model{
    if (self.topBarSubView) {
        [self.topBarSubView removeFromSuperview];
    }
    UIView *topBar = [[UIView alloc] init];
    self.topBarSubView = topBar;
    topBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UILabel *nameL = [[UILabel alloc] init];
    nameL.textColor = [UIColor whiteColor];
    nameL.font = GXFONT_PingFangSC_Regular(14);
    UILabel *priceL = [[UILabel alloc] init];
    priceL.textColor = GXRGBColor(216, 62, 33);
    priceL.font = GXFONT_PingFangSC_Regular(14);
    UILabel *dotL = [[UILabel alloc] init];
    dotL.textColor = GXRGBColor(216, 62, 33);
    dotL.font = GXFONT_PingFangSC_Regular(14);
    UILabel *percentL = [[UILabel alloc] init];
    percentL.textColor = GXRGBColor(216, 62, 33);
    percentL.font = GXFONT_PingFangSC_Regular(14);
    nameL.textAlignment = NSTextAlignmentCenter;
    priceL.textAlignment = NSTextAlignmentCenter;
    dotL.textAlignment = NSTextAlignmentCenter;
    percentL.textAlignment = NSTextAlignmentCenter;
    [topBar addSubview:nameL];
    [topBar addSubview:priceL];
    [topBar addSubview:dotL];
    [topBar addSubview:percentL];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBarTapClick)];
    [topBar addGestureRecognizer:tapGes];
    self.nameL = nameL;
    self.priceL = priceL;
    self.dotL = dotL;
    self.percentL = percentL;
    [self setTopBar:model];
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@(GXScreenWidth * 1.2/ 3));
    }];
    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(nameL.mas_right);
        make.width.equalTo(@(GXScreenWidth * 1.8/ 3 / 3));
    }];
    [dotL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(priceL.mas_right);
        make.width.equalTo(@(GXScreenWidth * 1.8/ 3 / 3));
    }];
    [percentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(dotL.mas_right);
        make.width.equalTo(@(GXScreenWidth * 1.8/ 3 / 3));
    }];
    
    [self.topBarView addSubview:topBar];
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self addTransationAnimationView:self.topBarView Type:@"cube" subtype:kCATransitionFromBottom timeInterval:0.5];
}

- (void)tabBarTapClick{
    [MobClick event:@"live_market"];
    GXProductView *productView = [[GXProductView alloc] init];
    typeof(self) weakSelf = self;
    productView.productDelegate =  ^ void (GXProductView *productView){
        [productView removeFromSuperview];
        [weakSelf addTransationAnimationView:self Type:kCATransitionPush subtype:kCATransitionFromLeft timeInterval:0.5];
    };
    [self addSubview:productView];
    [productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self addTransationAnimationView:self Type:kCATransitionPush subtype:kCATransitionFromRight timeInterval:0.5];
}

- (void)tapGesDid{
    [self endEditing:true];
}

- (GXBottomBtn *)addBtnWithTitle: (NSString *)title imageName: (NSString *)imageName tag: (NSInteger)tag{
    GXBottomBtn *speakBtn = [[GXBottomBtn alloc] initWithFrame:CGRectMake(0, 0, BtnWidth, BtnH)];
    [speakBtn setTitle:title forState:UIControlStateNormal];
    [speakBtn setTitleColor:GXRGBColor(101, 106, 137) forState:UIControlStateNormal];
    [speakBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    speakBtn.tag = tag;

    [speakBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return speakBtn;
}

- (void)btnClick: (UIButton *)btn{
    switch (btn.tag) {
            
        case 10:
        {
            [MobClick event:@"live_warning"];
            if (self.model) {
                [GXUserdefult setObject:self.model.idNew forKey:GXSuggestionId];
                self.startId = (NSNumber *)self.model.idNew;
            }
            [self.msgLabel removeFromSuperview];
            
            GXSuggestionView *suggestionV = [[GXSuggestionView alloc] init];
            [self addSubview:suggestionV];
            [suggestionV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            __weak typeof (self) weakSelf = self;
            suggestionV.suggestionDelegate = ^void(GXSuggestionView *view){
                [view removeFromSuperview];
                [weakSelf addTransationAnimationView:self Type:@"cube" subtype:kCATransitionFromBottom timeInterval:0.5];
            };
            [self addTransationAnimationView:self Type:@"cube" subtype:kCATransitionFromTop timeInterval:0.5];
        }
            break;
        case 20:
        {
            [MobClick event:@"live_schedule"];
            GXCourseView *courseView = [[GXCourseView alloc] init];
            [self addSubview:courseView];
            [courseView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            __weak typeof (self) weakSelf = self;
            courseView.courseDelegate = ^void(GXCourseView *view){
                [view removeFromSuperview];
                [weakSelf addTransationAnimationView:self Type:@"cube" subtype:kCATransitionFromBottom timeInterval:0.5];

            };
            [self addTransationAnimationView:self Type:@"cube" subtype:kCATransitionFromTop timeInterval:0.5];
        }
            break;
            
        default:{
            
        }
            break;
    }
}

- (void)addTransationAnimationView: (UIView *)view Type: (NSString *)type subtype: (NSString *)subtype timeInterval: (CGFloat)intervel{
    CATransition *ca = [CATransition animation];
    ca.type = type;
    ca.subtype = subtype;
    ca.duration = intervel;
    [view.layer addAnimation:ca forKey:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionsArrayM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXQuestionCell"];
    if (!cell) {
        cell = [[GXQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GXQuestionCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLableGes:)];
    cell.nameLable.tag = indexPath.row;
    [cell.nameLable addGestureRecognizer:tapGes];
    GXQuestion *question = self.questionsArrayM[indexPath.row];
    cell.questionModel = question;
    return cell;
}

- (void)tapLableGes: (UITapGestureRecognizer *)ges{
    if (count != SpeakInterval) {
        return;
    }
    YYLabel *lable = (YYLabel *)ges.view;
    selectedIndex = lable.tag;
    if (selectedIndex < self.questionsArrayM.count) {
        GXQuestion *question = self.questionsArrayM[selectedIndex];
        self.textView.text = [NSString stringWithFormat:@"@%@ ", question.nickName];
    }
    [self.textView becomeFirstResponder];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return [super hitTest:point withEvent:event];
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = GXRGBColor(243, 68, 42);
        label.text = [NSString stringWithFormat:@"%zd", count];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = WidthScale_IOS6(7);
        label.layer.masksToBounds = true;
        label.font = GXFONT_PingFangSC_Medium(GXFitFontSize12);
        _msgLabel = label;
    }
    return _msgLabel;
}
- (NSMutableArray *)questionsArrayM{
    if (!_questionsArrayM) {
        _questionsArrayM = [NSMutableArray array];
    }
    return _questionsArrayM;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshQuestionData) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSTimer *)productTimer{
    if (!_productTimer) {
        _productTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshTopBarData) userInfo:nil repeats:YES];
    }
    return _productTimer;
}

- (NSArray *)productCodes{
    if (!_productCodes) {
        _productCodes = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GXProductCodes.plist" ofType:nil]];
    }
    return _productCodes;
}

- (NSTimer *)msgTimer{
    if (!_msgTimer) {
        _msgTimer =  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshMsgCount) userInfo:nil repeats:YES];
    }
    return _msgTimer;
}
@end

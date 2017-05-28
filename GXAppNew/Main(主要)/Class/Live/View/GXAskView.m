//
//  GXAskView.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/8.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAskView.h"
#import "GXLiveCommonSize.h"
#import "GXEmotionKeyboardView.h"

@interface GXAskView ()<YYTextViewDelegate>
@property (nonatomic, assign) BOOL isEmoji;
@property (nonatomic, strong) UIButton *emojiBtn;
@property (nonatomic,weak) UIView *customSuperView;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UIView *bgView;
@end
@implementation GXAskView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inserEmoji:) name:EmojiBtnNotifyName object:nil];
    }
    return self;
}

- (void)keyboardWillChangeFrameNotification: (NSNotification *)notify {
    if (self.customSuperView) {
        NSDictionary *keyboardDict = notify.userInfo;
        CGRect keyboardFrame = [keyboardDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        ;
        CGFloat offsetY = keyboardFrame.origin.y - GXScreenHeight;
        self.customSuperView.transform = CGAffineTransformMakeTranslation(0, offsetY);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    if (![newSuperview.superview isKindOfClass:NSClassFromString(@"GXQuestionView")]) {
        self.customSuperView = newSuperview;
    }else{
        self.customSuperView = newSuperview.superview;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [super willMoveToSuperview:newSuperview];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.customSuperView) {
        self.customSuperView = nil;
    }
}

- (void)setupUI{
    UIButton *emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiBtn setImage:[UIImage imageNamed:@"keyboardEmoji"] forState:UIControlStateNormal];
    [self addSubview:emojiBtn];
    self.emojiBtn = emojiBtn;
    
    GXTextView *textF = [[GXTextView alloc] init];
    textF.delegate = self;
    textF.backgroundColor = GXRGBColor(238, 238, 238);
    textF.layer.cornerRadius = 3;
    textF.layer.masksToBounds = true;
    textF.font = GXFONT_PingFangSC_Regular(GXFitFontSize17);
    textF.textColor = [UIColor blackColor];
    textF.backgroundColor = GXRGBColor(80, 85, 98);
    self.textField = textF;
    textF.placeholderText = @"您的发言需要审核";
    textF.placeholderTextColor = UIColorFromRGB(0x656D8C);
    textF.placeholderFont = GXFONT_PingFangSC_Regular(GXFitFontSize10);
    textF.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
//    textF.placeholderAttributedText = [[NSAttributedString alloc] initWithString:@"您的发言需要审核" attributes:@{NSFontAttributeName:GXFONTHelvetica_regular(GXFitFontSize10),NSForegroundColorAttributeName:UIColorFromRGB(0x656D8C)}];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesClick)];
    [textF addGestureRecognizer:tapGes];

    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn = sendBtn;
    [sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [self addSubview:sendBtn];
    
    [emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(self).offset(GXMargin);
        make.width.equalTo(@EmojiBtnW);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    bgView.layer.cornerRadius = (KeyBoardHeight - GXMargin) * 0.5 - 2;
    bgView.layer.masksToBounds = true;
    bgView.backgroundColor = GXRGBColor(80, 85, 98);
    [bgView addSubview:textF];
    [bgView addSubview:sendBtn];
    [textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@((KeyBoardHeight - GXMargin) * 0.5 - 5));
        make.right.equalTo(sendBtn.mas_left);
    }];
    
    textF.contentInset = UIEdgeInsetsMake(WidthScale_IOS6(2.2), 0, 0, 0);
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(35));
        make.right.equalTo(@0);
        make.top.bottom.equalTo(@0);
    }];
    
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(emojiBtn.mas_right);
        make.top.equalTo(@(0.5*GXMargin));
        make.bottom.equalTo(@(-0.5*GXMargin));
        make.right.equalTo(@(-2*GXMargin));
    }];
    
    self.backgroundColor = GXRGBColor(59, 62, 76);
    
    [emojiBtn addTarget:self action:@selector(emojiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)tapGesClick{
    [self.textField becomeFirstResponder];
    if (self.isEmoji) {
        [self emojiBtnClick];
    }
}

- (void)inserEmoji: (NSNotification *)notify{
    [self.textField insertEmotion:(GXEmotion *)(notify.object)];
}

- (void)emojiBtnClick{
    if (self.isEmoji) {
        [self.emojiBtn setImage:[UIImage imageNamed:@"keyboardEmoji"] forState:UIControlStateNormal];
        self.textField.inputView = nil;
        [self.textField reloadInputViews];
    }else{
        [self.emojiBtn setImage:[UIImage imageNamed:@"keyboard_system"] forState:UIControlStateNormal];
        GXEmotionKeyboardView * customerKeyV = [[GXEmotionKeyboardView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, KeyBoardInputViewHeight)];
        
        self.textField.inputView = customerKeyV;
        [self.textField reloadInputViews];
    }
    self.isEmoji = !self.isEmoji;
    [self.textField becomeFirstResponder];
}

- (void)sendBtnClick{
    [self endEditing:true];
    [self.sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];

    if (self.sendBtnClickDelegate) {
        self.sendBtnClickDelegate(self.textField.fullText);
        self.textField.text = nil;
    }
}


#pragma mark - YYTextViewDelegate
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    [textView layoutSubviews];
    [[NSNotificationCenter defaultCenter] postNotificationName:TextViewBeginNotify object:nil];
    return true;
}
- (BOOL)textViewShouldEndEditing:(YYTextView *)textView{
    [textView layoutSubviews];
    [[NSNotificationCenter defaultCenter] postNotificationName:TextViewEndNotify object:nil];
    return true;
}

- (void)textViewDidChange:(YYTextView *)textView{
    if (textView.text.length > 0) {
        [self.sendBtn setImage:[UIImage imageNamed:@"sending"] forState:UIControlStateNormal];
    }else{
        [self.sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    }
}
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if ([text isEqualToString:@"\n"]) {
        if (self.sendBtnClickDelegate) {
            self.sendBtnClickDelegate(self.textField.fullText);
            self.textField.text = nil;
        }
        return false;
    }
    return true;
}

- (void)setTextFieldColor: (UIColor *)color{
    self.bgView.backgroundColor = color;
    self.textField.backgroundColor = color;
}
@end

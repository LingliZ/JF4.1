//
//  GXCalendarBaseView.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXCalendarBaseView.h"
#import "GXUIParameter.h"

@interface GXCalendarBaseView ()

@end

@implementation GXCalendarBaseView

{
    UIView *lineBottom;
    UIView *topTabBottomLine;
    NSMutableArray *btnArray;
    NSArray *titlesArray;
    NSInteger arrayCount;
    UIColor *selectBtn;
    UIColor *unselectBtn;
    UIColor *underline;
    UIColor *topTabColors;
    NSInteger topTabType;
    UIView *ninaMaskView;
    NSInteger defaultPageIndex;
    
    CGFloat titleWidth;
    CGFloat newContentOffsetX;
    NSInteger currentPage ;
    CGFloat offect ;
    CGFloat nextWidth ;
    CGFloat lastWidth ;
    CGFloat nowWidth ;
    
    NSInteger titleFontSize;
    NSInteger defaultLineWidth;
    
}

- (instancetype)initWithFrame:(CGRect)frame WithSelectColor:(UIColor *)selectColor WithUnselectorColor:(UIColor *)unselectColor WithUnderLineColor:(UIColor *)underlineColor WithtopTabColor:(UIColor *)topTabColor WithTopTabType:(NSInteger)topTabNum WithNinaDefaultPageIndex:(NSInteger)ninaDefaultPageIndex
{
    self = [super initWithFrame:frame];
    topTabType = topTabNum;
    defaultPageIndex = ninaDefaultPageIndex;
    titleFontSize = 14;
    if (self) {
        if ([selectColor isKindOfClass:[UIColor class]]) {
            selectBtn = selectColor;
        }else {
            NSLog(@"please change the selectColor into UIColor!");
        }
        if ([unselectColor isKindOfClass:[UIColor class]]) {
            unselectBtn = unselectColor;
        }else {
            NSLog(@"please change the unselectColor into UIColor!");
        }
        if ([underlineColor isKindOfClass:[UIColor class]]) {
            underline = underlineColor;
        }else {
            NSLog(@"please change the underlineColor into UIColor!");
        }
        if ([topTabColor isKindOfClass:[UIColor class]]) {
            topTabColors = topTabColor;
        }else {
            NSLog(@"please change the topTabColor into UIColor!");
        }
    }
    return self;
}
//带标题字号大小初始化
- (instancetype)initWithFrame:(CGRect)frame WithSelectColor:(UIColor *)selectColor WithUnselectorColor:(UIColor *)unselectColor WithUnderLineColor:(UIColor *)underlineColor WithtopTabColor:(UIColor *)topTabColor WithTopTabType:(NSInteger)topTabNum WithNinaDefaultPageIndex:(NSInteger)ninaDefaultPageIndex WithNinaTitleFontSize:(NSInteger)fontSize{
    self = [super initWithFrame:frame];
    topTabType = topTabNum;
    defaultPageIndex = ninaDefaultPageIndex;
    titleFontSize = fontSize;

    if (self) {
        if ([selectColor isKindOfClass:[UIColor class]]) {
            selectBtn = selectColor;
        }else {
            NSLog(@"please change the selectColor into UIColor!");
        }
        if ([unselectColor isKindOfClass:[UIColor class]]) {
            unselectBtn = unselectColor;
        }else {
            NSLog(@"please change the unselectColor into UIColor!");
        }
        if ([underlineColor isKindOfClass:[UIColor class]]) {
            underline = underlineColor;
        }else {
            NSLog(@"please change the underlineColor into UIColor!");
        }
        if ([topTabColor isKindOfClass:[UIColor class]]) {
            topTabColors = topTabColor;
        }else {
            NSLog(@"please change the topTabColor into UIColor!");
        }
    }
    return self;
}

#pragma mark - SetMethod
- (void)setTitleArray:(NSArray *)titleArray {
    titlesArray = titleArray;
    arrayCount = titleArray.count;
    self.topTab.frame = CGRectMake(0, 0, FUll_VIEW_WIDTH, PageBtn);
    self.scrollView.frame = CGRectMake(0, PageBtn, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT - PageBtn);
    [self addSubview:self.topTab];
    [self addSubview:self.scrollView];
    [self createdButton];
}

- (void)setTitleScale:(CGFloat)titleScale {
    _titleScale = titleScale;
    UIButton *buttonZero = btnArray[0];
    if (topTabType != 1) {
        buttonZero.transform = CGAffineTransformMakeScale(_titleScale, _titleScale);
    }
}
-(void)setCustomBottomLinePer:(CGFloat)customBottomLinePer{
    _customBottomLinePer = customBottomLinePer;
    if (arrayCount > 7) {
        if (_customBottomLinePer > 0) {
            defaultLineWidth = _customBottomLinePer;
        }else{
            defaultLineWidth = FUll_VIEW_WIDTH / 7;
        }
    }else{
        if (_customBottomLinePer > 0) {
            defaultLineWidth = _customBottomLinePer;
        }else{
            defaultLineWidth = FUll_VIEW_WIDTH / arrayCount;
        }
    }
}
#pragma mark - GetMethod
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.tag = 318;
        _scrollView.backgroundColor = UIColorFromRGB(0xfafafa);
        _scrollView.contentSize = CGSizeMake(FUll_VIEW_WIDTH * titlesArray.count, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
    }
    return _scrollView;
}

- (UIScrollView *)topTab {
    if (!_topTab) {
        _topTab = [[UIScrollView alloc] init];
        _topTab.delegate = self;
        if (topTabColors) {
            _topTab.backgroundColor = topTabColors;
        }else {
            _topTab.backgroundColor = [UIColor whiteColor];
        }
        
        _topTab.dk_backgroundColorPicker=DKColorPickerWithColors([UIColor whiteColor],GXRGBColor(45, 47, 59));

        _topTab.tag = 917;
        _topTab.pagingEnabled = YES;
        _topTab.scrollEnabled = YES;
        _topTab.alwaysBounceHorizontal = YES;
        _topTab.showsHorizontalScrollIndicator = NO;
        _topTab.bounces = NO;
        
        CGFloat additionCount = 0;
        CGFloat yourCount = 0;
        if (arrayCount > 7) {
            additionCount = (arrayCount - 7.0) / 7.0;
            yourCount = 1.0 / 7.0;
        }
        _topTab.contentSize = CGSizeMake((1 + additionCount) * FUll_VIEW_WIDTH, PageBtn - TabbarHeight);
        //初始化topTab的位置
        NSDate *todayDate = [NSDate date];
        NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:todayDate];
        NSInteger weekday = [components weekday];//a就是星期几,1是星期日,2是星期一,后面依次后推
        NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        NSString *weekStr = weekArray[weekday - 1];
        
        NSString *titleStr = titlesArray[defaultPageIndex - 3];
        NSLog(@"今天是:%@",weekStr);
 
        CGFloat topTabOffsetX = 0;
        CGFloat topTabOffsetX1 = 0;
      
        if (defaultPageIndex >= 3) {
            if (defaultPageIndex <= titlesArray.count - 4) {
                topTabOffsetX = (defaultPageIndex - 3) * More5LineWidth;
            }
            else {
                if (defaultPageIndex == titlesArray.count - 3) {
                    topTabOffsetX = (defaultPageIndex - 4) * More5LineWidth;
                }else {
                    topTabOffsetX = (defaultPageIndex - 4) * More5LineWidth;
                }
            }
        }
        else {
            if (defaultPageIndex == 1) {
                topTabOffsetX = 0 * More5LineWidth;
            }else {
                topTabOffsetX = defaultPageIndex * More5LineWidth;
            }
        }
        [_topTab setContentOffset:CGPointMake(GXScreenWidth, 0) animated:YES];
        btnArray = [NSMutableArray array];
        for (NSInteger i = 0; i < titlesArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
            if ([titlesArray[i] isKindOfClass:[NSString class]]) {
                [button setTitle:titlesArray[i] forState:UIControlStateNormal];
                button.titleLabel.numberOfLines = 0;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
            }else {
                NSLog(@"Your title%li not fit for topTab,please correct it to NSString!",(long)i + 1);
            }
            if (titlesArray.count > 7) {
                button.frame = CGRectMake(More5LineWidth * i, 0, More5LineWidth, PageBtn);
            }else {
                button.frame = CGRectMake(FUll_VIEW_WIDTH / titlesArray.count * i, 0, FUll_VIEW_WIDTH / titlesArray.count, PageBtn);
            }
            [_topTab addSubview:button];
            [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
            [btnArray addObject:button];
            if (i == 0 && (topTabType == 0 || topTabType == 2 || topTabType == 3 || topTabType == 1)) {
                if (selectBtn) {
                    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }else {
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                button.transform = CGAffineTransformMakeScale(1.15, 1.15);
                } else {
                    if (unselectBtn) {
                        [button setTitleColor:unselectBtn forState:UIControlStateNormal];
                    }else {
                        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
            }
        }
        
        //Create Toptab underline.
        topTabBottomLine = [UIView new];
        topTabBottomLine.dk_backgroundColorPicker = DKColorPickerWithColors(UIColorFromRGB(0xEEEEEE),GXRGBColor(40, 40, 54));
        [_topTab addSubview:topTabBottomLine];
        //Create Toptab bottomline.
        lineBottom = [UIView new];
        if (underline) {
            lineBottom.backgroundColor = underline;
        }else {
            lineBottom.backgroundColor = UIColorFromRGB(0xff6262);
        }
        
        lineBottom.dk_backgroundColorPicker=DKColorPickerWithColors(GXRGBColor(64, 130, 244),GXRGBColor(64, 130, 244));

        lineBottom.clipsToBounds = YES;
        lineBottom.userInteractionEnabled = YES;
        [_topTab addSubview:lineBottom];
        //Create ninaMaskView.

        if (topTabType == 1) {
            ninaMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (1 + additionCount) * FUll_VIEW_WIDTH, SliderHeight)];
            ninaMaskView.backgroundColor = [UIColor clearColor];
            for (NSInteger j = 0; j < titlesArray.count; j++) {
                UILabel *maskLabel = [UILabel new];
                if (titlesArray.count > 7) {
                    maskLabel.frame = CGRectMake(More5LineWidth * j -((More5LineWidth - 35) / 2.0), -55, More5LineWidth, SliderHeight);
                }else {
                    maskLabel.frame = CGRectMake(FUll_VIEW_WIDTH / titlesArray.count * j - FUll_VIEW_WIDTH / titlesArray.count * (1 - SelectBottomLinePer) / 2, 0, FUll_VIEW_WIDTH / titlesArray.count, SliderHeight);
                }
                maskLabel.text = titlesArray[j];
                maskLabel.textColor = [UIColor whiteColor];
                maskLabel.numberOfLines = 0;
                maskLabel.textAlignment = NSTextAlignmentCenter;
                maskLabel.font = [UIFont systemFontOfSize:titleFontSize];
                [ninaMaskView addSubview:maskLabel];
            }
            [lineBottom addSubview:ninaMaskView];
        }
        if (topTabType == 2) {
            lineBottom.hidden = YES;
        }
    }
    return _topTab;
}
#pragma mark ----- createdButton -----
-(void)createdButton{
    self.nextPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextPageBtn.frame = CGRectMake(FUll_VIEW_WIDTH - 20, 0, 20, PageBtn);
    [self.nextPageBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 0, 30, 0)];
    [self.nextPageBtn dk_setImage:DKImagePickerWithNames(@"home_calendar_right_arrow_pic",@"home_calendar_right_arrow_pic") forState:UIControlStateNormal];
    self.nextPageBtn.tag = 9518;
    [self.nextPageBtn addTarget:self action:@selector(didClickPageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.previousPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousPageBtn setImageEdgeInsets:UIEdgeInsetsMake(30, 0, 30, 0)];
    [self.previousPageBtn dk_setImage:DKImagePickerWithNames(@"home_calendar_left_arrow_pic",@"home_calendar_left_arrow_pic") forState:UIControlStateNormal];
    self.previousPageBtn.frame = CGRectMake(0, 0, 20, PageBtn);
    self.previousPageBtn.tag = 9519;
    [self.previousPageBtn addTarget:self action:@selector(didClickPageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextPageBtn];
    [self addSubview:self.previousPageBtn];
}
#pragma mark - BtnMethod
- (void)touchAction:(UIButton *)button {
    [_scrollView setContentOffset:CGPointMake(FUll_VIEW_WIDTH * button.tag, 0) animated:YES];
    self.currentPage = (FUll_VIEW_WIDTH * button.tag + FUll_VIEW_WIDTH / 2) / FUll_VIEW_WIDTH;
}
-(void)didClickPageBtnAction:(UIButton *)sender{
    CGFloat next_X = _topTab.contentOffset.x;
    switch (sender.tag) {
        case 9518:{
            if ((_topTab.contentOffset.x + FUll_VIEW_WIDTH) < _topTab.contentSize.width) {
                if (_topTab.contentSize.width - _topTab.contentOffset.x - FUll_VIEW_WIDTH < FUll_VIEW_WIDTH) {
                    next_X = _topTab.contentSize.width -FUll_VIEW_WIDTH;
                }else{
                    next_X = _topTab.contentOffset.x + FUll_VIEW_WIDTH;
                }
                [_topTab setContentOffset:CGPointMake(next_X, 0) animated:YES];
            }else{
                return;
            }
        }
            break;
        case 9519:{
            if (_topTab.contentOffset.x > 0) {
                if (_topTab.contentOffset.x > FUll_VIEW_WIDTH) {
                    next_X = _topTab.contentOffset.x - FUll_VIEW_WIDTH;
                }else{
                    next_X = 0;
                }
                [_topTab setContentOffset:CGPointMake(next_X, 0) animated:YES];
            }else{
                return;
            }
        }
        default:
            break;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 318) {
        self.currentPage = (NSInteger)((scrollView.contentOffset.x + FUll_VIEW_WIDTH / 2) / FUll_VIEW_WIDTH);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 917) {
        if (_topTab.contentOffset.x + FUll_VIEW_WIDTH >= _topTab.contentSize.width) {
            self.nextPageBtn.hidden = YES;
        }else{
            self.nextPageBtn.hidden = NO;
        }
        if (_topTab.contentOffset.x <= 0) {
            self.previousPageBtn.hidden = YES;
        }else{
            self.previousPageBtn.hidden = NO;
        }
    }
    if (scrollView.tag == 318) {
        currentPage = scrollView.contentOffset.x / FUll_VIEW_WIDTH;
        
        CGFloat initOffect = currentPage * FUll_VIEW_WIDTH;
        NSInteger next = currentPage + 1;
        NSInteger last = currentPage - 1;
        
        //标题数组下标
        if (currentPage == titlesArray.count - 1) {
            next = titlesArray.count - 1;
        }
        if (currentPage == 0 ){
            last = 0;
        }
        newContentOffsetX = scrollView.contentOffset.x;
        
        offect = newContentOffsetX - initOffect;
        nextWidth = 0;
        lastWidth = 0;
        nowWidth = 0;
        // 字符串宽度
        CGRect bounds = [UIScreen mainScreen].bounds;
        CGRect stringRect = [titlesArray[currentPage] boundingRectWithSize:bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:titleFontSize]} context:nil];
        //当前字宽
        nowWidth = stringRect.size.width;
        //右划上一个字宽
        nextWidth = [titlesArray[next] boundingRectWithSize:bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:titleFontSize]} context:nil].size.width;
        //左划下一个字宽
        lastWidth = [titlesArray[last] boundingRectWithSize:bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:titleFontSize]} context:nil].size.width;
        
        if (newContentOffsetX - initOffect > 0) {
            if (nowWidth >= nextWidth) {
                nowWidth = nowWidth - (((nowWidth - nextWidth) / FUll_VIEW_WIDTH )* offect);
            }else{
                nowWidth = nowWidth + ((nextWidth - nowWidth) / FUll_VIEW_WIDTH * offect);
            }
            
        }
        if (newContentOffsetX - initOffect < 0) {
            if (nowWidth >= nextWidth) {
                nowWidth = nowWidth - ((nowWidth - lastWidth) / FUll_VIEW_WIDTH * offect);
            }else{
                nowWidth = nowWidth + ((lastWidth - nowWidth) / FUll_VIEW_WIDTH *offect);
            }
        }
        titleWidth = nowWidth;
        
        NSInteger yourPage = (NSInteger)((scrollView.contentOffset.x + FUll_VIEW_WIDTH / 2) / FUll_VIEW_WIDTH);
        CGFloat yourCount = 1.0 / arrayCount;
        if (arrayCount > 7) {
            yourCount = 1.0 / 7.0;
        }
        CGFloat lineBottomDis = yourCount * FUll_VIEW_WIDTH * (1 -SelectBottomLinePer) / 2;
        CGFloat lineBottomDis1 = (yourCount * FUll_VIEW_WIDTH - titleWidth) / 2;
        CGFloat lineBottomDis2 = (yourCount * FUll_VIEW_WIDTH - defaultLineWidth) / 2;
        CGPoint maskCenter = ninaMaskView.center;
        if (topTabType == 1) {
            if (arrayCount >= 7) {
                maskCenter.x = ninaMaskView.frame.size.width / 2.0 - (scrollView.contentOffset.x * 1 / 7);
            }else {
                maskCenter.x = ninaMaskView.frame.size.width / 2.0 - (scrollView.contentOffset.x * yourCount);
            }
            ninaMaskView.center = maskCenter;
        }
        if (arrayCount > 7) {
            switch (topTabType) {
                case 0:
                    if (SelectBottomLineHeight >= 3) {
                        lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 7 + lineBottomDis2, PageBtn - 3, defaultLineWidth, 3);
                    }
                    lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 7 + lineBottomDis2, PageBtn - SelectBottomLineHeight, defaultLineWidth, SelectBottomLineHeight);
                    break;
                case 1:
                    lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 7 + lineBottomDis2, SliderHeight - 45, defaultLineWidth, defaultLineWidth);
                    break;
                case 3:
                    if (SelectBottomLineHeight >= 3) {
                        lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 7 + lineBottomDis1, PageBtn - 3, titleWidth, 3);
                    }
                    lineBottom.frame = CGRectMake(scrollView.contentOffset.x / 7 + lineBottomDis1, PageBtn - SelectBottomLineHeight,titleWidth, SelectBottomLineHeight);
                    break;
                default:
                    break;
            }
        }else {
            switch (topTabType) {
                case 0:
                    if (SelectBottomLineHeight >= 3) {
                        lineBottom.frame = CGRectMake(scrollView.contentOffset.x / arrayCount + lineBottomDis2, PageBtn - 3,defaultLineWidth, 3);
                    }else {
                        lineBottom.frame = CGRectMake(scrollView.contentOffset.x / arrayCount + lineBottomDis2, PageBtn - SelectBottomLineHeight, defaultLineWidth, SelectBottomLineHeight);
                    }
                    break;
                case 1:
                    lineBottom.frame = CGRectMake(scrollView.contentOffset.x / arrayCount + lineBottomDis2, SliderHeight - 45, defaultLineWidth, 50);
                    break;
                case 3:
                    if (SelectBottomLineHeight >= 3) {
                        lineBottom.frame = CGRectMake(scrollView.contentOffset.x / arrayCount + lineBottomDis1, PageBtn - 3, titleWidth, 3);
                    }
                    lineBottom.frame = CGRectMake(scrollView.contentOffset.x / arrayCount + lineBottomDis1, PageBtn - SelectBottomLineHeight,titleWidth, SelectBottomLineHeight);
                    break;
                default:
                    break;
            }
        }
        for (NSInteger i = 0;  i < btnArray.count; i++) {
            if (topTabType == 0 || topTabType == 2 || topTabType == 3 || topTabType == 1) {
                if (unselectBtn) {
                    [btnArray[i] setTitleColor:unselectBtn forState:UIControlStateNormal];
                    [btnArray[i] dk_setTitleColorPicker:DKColorPickerWithColors(GXRGBColor(145, 145, 145),GXRGBColor(145, 145, 145)) forState:UIControlStateNormal];
                }else {
                    [btnArray[i] setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
            }
            UIButton *changeButton = btnArray[i];
            [UIView animateWithDuration:0.3 animations:^{
                changeButton.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
        if (topTabType == 0 || topTabType == 2 || topTabType == 3 || topTabType == 1) {
            if (selectBtn) {
                [btnArray[yourPage] setTitleColor:selectBtn forState:UIControlStateNormal];
                [btnArray[yourPage] dk_setTitleColorPicker:DKColorPickerWithColors(GXRGBColor(64, 130, 244),GXRGBColor(64, 130, 244)) forState:UIControlStateNormal];
                
            }else {
                [btnArray[yourPage] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            UIButton *changeButton = btnArray[yourPage];
            if (_titleScale > 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    changeButton.transform = CGAffineTransformMakeScale(_titleScale, _titleScale);
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    changeButton.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
        }
    }
}

#pragma mark - LayOutSubViews
- (void)layoutSubviews {
    [super layoutSubviews];
    [self initUI];
}

- (void)initUI {
    CGFloat initTitleWidth = 0;
    CGRect bounds = [UIScreen mainScreen].bounds;
    // 字符串frame
    CGRect stringRect = [titlesArray[defaultPageIndex] boundingRectWithSize:bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:titleFontSize]} context:nil];
    initTitleWidth = stringRect.size.width;
    
    CGFloat yourCount = 1.0 / arrayCount;
    CGFloat additionCount = 0;
    if (arrayCount > 7) {
        additionCount = (arrayCount - 7.0) / 7.0;
        yourCount = 1.0 / 7.0;
    }
    CGFloat lineBottomDis = yourCount * FUll_VIEW_WIDTH * (1 -SelectBottomLinePer) / 2;
    CGFloat lineBottomDis1 = (yourCount * FUll_VIEW_WIDTH - initTitleWidth) / 2;
    CGFloat lineBottomDis2 = (yourCount * FUll_VIEW_WIDTH - defaultLineWidth) / 2;
    switch (topTabType) {
        case 0:
            if (SelectBottomLineHeight >= 3) {
                lineBottom.frame = CGRectMake(lineBottomDis2, PageBtn - 3, defaultLineWidth, 3);
            }else {
                lineBottom.frame = CGRectMake(lineBottomDis2 + FUll_VIEW_WIDTH * yourCount * defaultPageIndex, PageBtn - SelectBottomLineHeight, defaultLineWidth, SelectBottomLineHeight);
            }
            break;
        case 1:
            lineBottom.frame = CGRectMake(lineBottomDis2 + FUll_VIEW_WIDTH * yourCount * defaultPageIndex, SliderHeight - 45,defaultLineWidth, defaultLineWidth);
            if (SlideBlockCornerRadius > 0) {
                lineBottom.layer.cornerRadius = defaultLineWidth / 2;
            }
            break;
        case 3:
            if (SelectBottomLineHeight >= 3) {
                lineBottom.frame = CGRectMake(lineBottomDis1, PageBtn - 3, initTitleWidth, 3);
            }else {
                lineBottom.frame = CGRectMake(lineBottomDis1 + FUll_VIEW_WIDTH * yourCount * defaultPageIndex, PageBtn - SelectBottomLineHeight, initTitleWidth, SelectBottomLineHeight);
            }
            break;
        default:
            break;
    }
    topTabBottomLine.frame = CGRectMake(0, PageBtn - 0.5, (1 + additionCount) * FUll_VIEW_WIDTH, 0.5);
}
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

@end

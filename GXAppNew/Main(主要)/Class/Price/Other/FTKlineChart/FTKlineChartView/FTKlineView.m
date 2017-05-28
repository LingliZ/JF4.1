//
//  FTKlineView.m
//  ChartDemo
//
//  Created by futang yang on 2016/10/13.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "FTKlineView.h"
#import "UIBezierPath+curved.h"
#import "FTChartDealvalueTool.h"


#import "FTKlineItemData.h"
#import "FTKlineModel.h"
#import "FTLineData.h"
#import "CCSTitledLine.h"
#import "KlineTipView.h"
#import "IndexTipView.h"

typedef NS_ENUM(NSUInteger, ChartTimeFormater) {
    Chart_yyyymmdd,
    Chart_mmddhhmm
};

NSString *const FTKLineKeyStartUserInterfaceNotification = @"FTKLineKeyStartUserInterfaceNotification";
NSString *const FTKLineKeyEndOfUserInterfaceNotification = @"FTKLineKeyEndOfUserInterfaceNotification";

@interface FTKlineView ()

@property (nonatomic, assign) CGFloat yAxisHeight;

@property (nonatomic, assign) CGFloat yAxisIndexHeight;





// 绘图相关
@property (nonatomic, assign) NSInteger startDrawIndex;
@property (nonatomic, assign) NSInteger kLineDrawNume;

@property (nonatomic, assign) CGFloat maxHighValue;
@property (nonatomic, assign) CGFloat minLowValue;

@property (nonatomic, assign) CGFloat maxKlineValue;
@property (nonatomic, assign) CGFloat minKlineValue;


@property (nonatomic, assign) float maxIndexValue;
@property (nonatomic, assign) float minIndexValue;

@property (nonatomic, assign) CGFloat IndexNameHeight;




// 坐标轴
@property (nonatomic, strong) NSMutableDictionary *xAxisContext;
@property (nonatomic, strong) NSMutableDictionary *xAxisAvgLineContext;
@property (nonatomic, strong) NSMutableDictionary *xAxisIndexContext;



// 十字线
@property (nonatomic, strong) UIView *verticalCrossLine;
@property (nonatomic, strong) UIView *horizantalCrossLine;
@property (nonatomic, strong) UIView *verticalIndexCrossLine;
@property (nonatomic, strong) KlineTipView *klineTipView;
@property (nonatomic, strong) IndexTipView *indexTipView;

// 时间框
@property (nonatomic, strong) UILabel *timeLb;
// 左侧数值框
@property (nonatomic, strong) UILabel *valueLb;

// 指标切换button
@property (nonatomic, strong) UIButton *indexChaneBtn;
@property (nonatomic, strong) UIButton *klineChangeBtn;
// 指标设置button
@property (nonatomic, strong) UIButton *indexSetBtn;

// 指标提示数组
@property (nonatomic, strong) NSMutableArray *klineTipArray;
@property (nonatomic, strong) NSMutableArray *indexTipArray;

// 时间价格
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;

// 时间显示格式
@property (nonatomic, assign) ChartTimeFormater timeFormater;



// 手势相关
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestrue;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat lastPacScale;

//交互中， 默认NO
@property (nonatomic, assign) BOOL interactive;
//更新临时存储
@property (nonatomic, strong) NSMutableArray *updateTempContexts;
@property (nonatomic, strong) NSMutableArray *updateTempDates;
@property (nonatomic, assign) CGFloat updateTempMaxHigh;
@property (nonatomic, assign) CGFloat updateTempMaxVol;


@end


@implementation FTKlineView



#pragma mark - lifeCircle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver];
}


#pragma mark - initCofig
- (void)config {
    
 
    
    self.timeAxisHeight = 20.0;
    self.IndexNameHeight = 20.0;
    
    self.positiveLineColor = [UIColor colorWithRed:1.000 green:0.400 blue:0.400 alpha:1.000];
    self.negativeLineColor = [UIColor colorWithRed:0.000 green:0.800 blue:0.200 alpha:1.000];
    

    self.axisShadowColor = [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.0];
    self.axisShadowWidth = 0.8;
    
    self.separatorColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0];
    self.separatorWidth = 0.5;
    
    self.yAxisTitleFont = [UIFont systemFontOfSize:8];
    self.yAxisTitleColor = [UIColor colorWithWhite:0.510 alpha:1.000];
    
    
    self.xAxisTitleFont = [UIFont systemFontOfSize:8];
    self.xAxisTitleColor = [UIColor colorWithWhite:0.510 alpha:1.000];
    
    self.croosLineColor = [UIColor blackColor];
    
    
    self.tipBackGroundColor = [UIColor whiteColor];
    self.tipBorderColor = [UIColor grayColor];
    self.tipBorderWidth = 0.5;
    self.tipTextColor = [UIColor whiteColor];
    
    
    self.isShowMaxMinValue = YES;
    self.scrollEnable = YES;
    self.zommEnable = YES;
    self.showAvgLine = YES;
    self.yAxisTitleIsChange = YES;
    self.supportGesture = YES;
  //  self.saveDecimalPlaces = 2;
    
    self.movingAvgLineWidth = 1;
    self.maxKlineWidth = 24;
    self.minKlineWidth = 2;
    
    self.klineWidth = 5.0;
    self.klinePadding = 1.5;
    
    self.lastPacScale = 1.0;
    
    self.pointCrossLineWidth = 9;
    
    
    self.isShowKlineYAxisTitle = YES;
    self.isShowIndexYAxisTitle = YES;
    
    
    self.isHollowLine = NO;
    

    self.xAxisContext = [NSMutableDictionary new];
    self.xAxisIndexContext = [NSMutableDictionary new];
    self.xAxisAvgLineContext = [NSMutableDictionary new];
    
    self.updateTempContexts = [NSMutableArray new];
    self.updateTempDates = [NSMutableArray new];
    
    
    self.direction = KlineChartDirectionVertical;
    
    [self registerObserver];
    
}


- (void)ClickOnKlineChangeIndex:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(klineView:ClickOnChangeTopIndex:topIndexType:)]) {
        [self.delegate klineView:self ClickOnChangeTopIndex:btn topIndexType:self.topIndexType];
    }
}

- (void)ClickOnIndexChangeIndex:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(klineView:ClickOnChangeBottomIndex:bottomIndexType:)]) {
        [self.delegate klineView:self ClickOnChangeBottomIndex:btn bottomIndexType:self.bottomIndexType];
    }
}

- (void)ClickOnSetIndexButton:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(klineView:ClickOnSetIndexButton:)]) {
        [self.delegate klineView:self ClickOnSetIndexButton:btn];
    }
}



- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTouchNotification:) name:FTKLineKeyStartUserInterfaceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfTouchNotification:) name:FTKLineKeyEndOfUserInterfaceNotification object:nil];
}


- (void)postNotificationWithGestureRecognizerStatus:(UIGestureRecognizerState)state {
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FTKLineKeyStartUserInterfaceNotification object:nil];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [[NSNotificationCenter defaultCenter] postNotificationName:FTKLineKeyEndOfUserInterfaceNotification object:nil];
            break;
        }
        default:
            break;
    }
}


- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FTKLineKeyStartUserInterfaceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FTKLineKeyEndOfUserInterfaceNotification object:nil];
}

- (void)startTouchNotification:(NSNotification *)notification {
    self.interactive = YES;
}

- (void)endOfTouchNotification:(NSNotification *)notification {
    self.interactive = NO;
}



#pragma mark - public Method
- (void)drawChartWithData:(FTKlineItemData *)klineItemData {
    
    _klinItemData = klineItemData;
    
    self.contexts = klineItemData.context;
    self.dates = klineItemData.dates;
    self.lineContexts = klineItemData.lineContexts;
    self.IndexContexts = klineItemData.indexContexts;
    
    
    self.kLineDrawNume = (self.frame.size.width - self.leftMargin - self.rightMargin - _klinePadding)/(self.klineWidth + _klinePadding);
    

    self.startDrawIndex = self.contexts.count > 0 ? self.contexts.count - self.kLineDrawNume : 0;
    
    // 绘制
    [self setNeedsDisplay];
    
}


- (void)drawChart1111WithData:(FTKlineItemData *)klineItemData {
    
    _klinItemData = klineItemData;
    
    self.contexts = klineItemData.context;
    self.dates = klineItemData.dates;
    self.lineContexts = klineItemData.lineContexts;
    self.IndexContexts = klineItemData.indexContexts;
    
    
    self.kLineDrawNume = (self.frame.size.width - self.leftMargin - self.rightMargin - _klinePadding)/(self.klineWidth + _klinePadding);
    
    
   // self.startDrawIndex = self.contexts.count > 0 ? self.contexts.count - self.kLineDrawNume : 0;
    
    // 绘制
    [self setNeedsDisplay];
}



#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.contexts || self.contexts.count == 0) {
        return;
    }
    
    self.backgroundColor = self.chartBackgroundColor;
    

    self.xAxisWidth = rect.size.width - self.leftMargin - self.rightMargin;

    self.yAxisHeight = rect.size.height - self.topMargin - self.bottomMargin;

    self.yAxisIndexHeight = rect.size.height - self.topMargin - self.yAxisHeight - self.timeAxisHeight - self.IndexNameHeight;

    [self resetMaxAndMin];

    [self drawLashRect:rect];
 
    [self drawTimeAxis];
    
  
    [self drawKline];
    

    [self drawAvgLine];


    [self drawIndexChart];
    
    [self drawAxisInRect:rect];
    
    
    
    if (self.direction == KlineChartDirectionVertical) {
        [self.klineChangeBtn setTitle:[self.klineChangeTitle stringByAppendingString:@"⇋"]forState:UIControlStateNormal];
    } else {
        [self.klineChangeBtn setTitle:[self.klineChangeTitle stringByAppendingString:@""]forState:UIControlStateNormal];
    }
    
    CGSize titleSize1 = [self.klineChangeBtn.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.xAxisTitleFont} context:nil].size;
    _klineChangeBtn.frame = CGRectMake(self.leftMargin, self.topMargin, titleSize1.width, 40);
    self.klineTipView.frame = CGRectMake(self.leftMargin + self.klineChangeBtn.width, self.topMargin, self.xAxisWidth, 10);
    
    
    
    if (self.direction == KlineChartDirectionVertical) {
        [self.indexChaneBtn setTitle:[self.indexChangeTitle stringByAppendingString:@"▼"]forState:UIControlStateNormal];
    } else {
        [self.indexChaneBtn setTitle:[self.klineChangeTitle stringByAppendingString:@""]forState:UIControlStateNormal];
    }
    

    CGSize titleSize2 = [self.indexChaneBtn.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.xAxisTitleFont} context:nil].size;
     _indexChaneBtn.frame = CGRectMake(self.leftMargin, self.topMargin + self.yAxisHeight + self.timeAxisHeight, titleSize2.width, self.IndexNameHeight);
    [_indexChaneBtn setEnlargeEdgeWithTop:20 right:50 bottom:20 left:20];
    self.indexTipView.frame = CGRectMake(self.leftMargin + self.indexChaneBtn.width, self.topMargin + self.yAxisHeight + self.timeAxisHeight, self.xAxisWidth, 20);
    
    
    if (self.direction == KlineChartDirectionVertical) {
        [self addSubview:self.indexSetBtn];
    }
    
    self.indexTipView.tipTitleArray = self.indexTipArray;
    
    
    if (self.direction == KlineChartDirectionLandscape) {
        
        if (self.klineTipArray.count != 0) {
            [self.klineTipArray removeAllObjects];
        }
        
        if (self.indexTipArray.count != 0) {
            [self.indexTipArray removeAllObjects];
        }
        
        
        
        for (NSInteger i = 0; i < self.lineContexts.count; i++) {
            CCSTitledLine *titleLine = self.lineContexts[i];
            FTLineData *line = [titleLine.data lastObject];
            line.title = titleLine.title;
            line.color = titleLine.color;
            
            [self.klineTipArray addObject:line];
        }
        
        self.klineTipView.tipTitleArray = self.klineTipArray;
        
        
        for (NSInteger i = 0; i < self.IndexContexts.count; i++) {
            CCSTitledLine *titleLine = self.IndexContexts[i];
            FTLineData *line = [titleLine.data lastObject];
            line.title = titleLine.title;
            line.color = titleLine.color;
            [self.indexTipArray addObject:line];
        }
        self.indexTipView.tipTitleArray = self.indexTipArray;
        
    }
}

- (void)drawLashRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    

    CGRect strokeRect = CGRectMake(self.leftMargin, self.topMargin, self.xAxisWidth, self.yAxisHeight);
    CGContextSetLineWidth(context, self.axisShadowWidth);
    CGContextSetStrokeColorWithColor(context, self.axisShadowColor.CGColor);
    CGContextStrokeRect(context, strokeRect);
    
    CGFloat avgHeight = self.yAxisHeight/5.0;
    for (NSInteger i = 1; i <= 4; i++) {
        CGContextSetLineWidth(context, self.separatorWidth);
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
        CGFloat lengths[] = {5,5};
        CGContextSetLineDash(context, 0, lengths, 2);
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, self.leftMargin + 1.25, self.topMargin + avgHeight * i);
        CGContextAddLineToPoint(context, rect.size.width - self.rightMargin, self.topMargin + avgHeight *i);
        CGContextStrokePath(context);
    }
    
    CGContextSetLineDash(context, 0, 0, 0);
    

    CGContextSetLineWidth(context, self.separatorWidth);
    CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
    CGFloat lengths[] = {5,5};
    CGContextSetLineDash(context, 0, lengths, 2);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.leftMargin + 1.25, self.topMargin + self.yAxisHeight + self.timeAxisHeight + self.IndexNameHeight + self.yAxisIndexHeight/2.0);
    CGContextAddLineToPoint(context, self.leftMargin + self.xAxisWidth, self.topMargin + self.yAxisHeight + self.timeAxisHeight + self.IndexNameHeight + self.yAxisIndexHeight/2.0);
    CGContextStrokePath(context);
}


- (void)drawAxisInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat avgHeight = self.yAxisHeight/5.0;
    if (self.isShowKlineYAxisTitle) {
        
        CGFloat avgValue = (self.maxKlineValue - self.minKlineValue)/5.0;
        
        for (NSInteger i = 0; i < 6; i++) {
            
            float yAxisValue = i == 5 ? self.minKlineValue : self.maxKlineValue - (avgValue * i);
            
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[FTChartDealvalueTool dealDecimalWithNum:@(yAxisValue) DecimalPlaces:self.lastSaveDecimalPlaces] attributes:@{NSFontAttributeName:self.yAxisTitleFont,NSForegroundColorAttributeName:self.yAxisTitleColor}];
            CGSize size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            
            CGFloat attStringX;
            if (self.yAxisIsOutSide) {
                attStringX = self.leftMargin - size.width - 2;
            } else {
                attStringX = self.leftMargin;
            }
            
            if (i == 0) {
                [attString drawInRect:CGRectMake(attStringX, self.topMargin, self.width, size.height)];
            } else {
                [attString drawInRect:CGRectMake(attStringX, self.topMargin + avgHeight * i - (i == 5 ? size.height - 1 : size.height/2.0), size.width, size.height)];
            }
           
        }
    }
  
    if (!self.showIndexChart) {
        return;
    }
    CGContextSetLineWidth(context, self.axisShadowWidth);
    CGContextSetStrokeColorWithColor(context, self.axisShadowColor.CGColor);
    CGRect IndexChartTopRect = CGRectMake(self.leftMargin, self.topMargin + self.yAxisHeight + self.timeAxisHeight, self.xAxisWidth, self.IndexNameHeight);
    CGContextStrokeRect(context, IndexChartTopRect);
    
    CGRect IndexChartdRect = CGRectMake(self.leftMargin, self.topMargin + self.yAxisHeight + self.timeAxisHeight + self.IndexNameHeight, self.xAxisWidth, self.frame.size.height - self.yAxisHeight - self.topMargin - self.timeAxisHeight - self.IndexNameHeight - self.axisShadowWidth - 1);
    CGContextStrokeRect(context, IndexChartdRect);
    
  

    if (self.isShowIndexYAxisTitle) {
        NSAttributedString *attStringMaxIndex = [[NSAttributedString alloc] initWithString:[FTChartDealvalueTool dealDecimalWithNum:@(self.maxIndexValue) DecimalPlaces:self.saveDecimalPlaces] attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:self.yAxisTitleColor}];
        CGSize maxSize = [attStringMaxIndex boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        [attStringMaxIndex drawInRect:CGRectMake((self.yAxisIsOutSide) ? self.leftMargin - maxSize.width - 2 : self.leftMargin , self.topMargin + self.yAxisHeight + self.timeAxisHeight + self.IndexNameHeight, maxSize.width, maxSize.height)];
        
        
        NSAttributedString *attStringMinIndex = [[NSAttributedString alloc] initWithString:[FTChartDealvalueTool dealDecimalWithNum:@(self.minIndexValue) DecimalPlaces:self.saveDecimalPlaces] attributes:@{NSFontAttributeName:self.yAxisTitleFont,NSForegroundColorAttributeName:self.yAxisTitleColor}];
        CGSize minSize = [attStringMinIndex boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        [attStringMinIndex drawInRect:CGRectMake((self.yAxisIsOutSide) ? self.leftMargin - minSize.width - 2 : self.leftMargin, self.frame.size.height - minSize.height, minSize.width, minSize.height)];
    }
    

}


- (void)drawTimeAxis {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat quarteredWidth = self.xAxisWidth/4.0;
#warning todo
    NSInteger avgDrawCount = ceil(quarteredWidth/(_klinePadding + _klineWidth));
    NSInteger timeAxisDrawCount = 4;
    CGFloat drawAxisWidth = self.kLineDrawNume * (self.klineWidth + self.klinePadding);
    
    if (drawAxisWidth > 2 * quarteredWidth && drawAxisWidth < 3 *quarteredWidth) {
        timeAxisDrawCount = 4;
    } else if (drawAxisWidth < 2 * quarteredWidth && drawAxisWidth > quarteredWidth) {
        timeAxisDrawCount = 2;
    } else if (drawAxisWidth < quarteredWidth) {
        timeAxisDrawCount = 1;
    }
    
#warning TODO
    CGFloat xAxis = self.leftMargin + _klineWidth/2.0 + _klinePadding;
    for (NSInteger i = 0; i < timeAxisDrawCount; i++) {
        if (xAxis > self.leftMargin + self.xAxisWidth) {
            break;
        }
        
        CGContextSetLineWidth(context, self.separatorWidth);
        CGFloat lenghts[] = {5,5};
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
        CGContextSetLineDash(context, 0, lenghts, 2);
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, xAxis, self.topMargin + 1.25);
        CGContextAddLineToPoint(context, xAxis, self.topMargin + self.yAxisHeight - 1.25);
        CGContextStrokePath(context);
        
   
        NSInteger timeIndex = self.startDrawIndex + avgDrawCount *i;
        timeIndex = timeIndex < self.dates.count - 1 ? timeIndex : self.dates.count - 1;
        
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[self timeWithTimeIntervalString:self.dates[timeIndex] returnType:self.timeFormater] attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
        CGSize size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGFloat originX = MIN(xAxis - size.width/2.0, self.frame.size.width - self.rightMargin - size.width);
        if (i == 0) {
            originX = self.leftMargin + 2;
        }
        [attString drawInRect:CGRectMake(originX, self.topMargin + self.yAxisHeight + 4, size.width, size.height)];
#warning TODO
        
        if (drawAxisWidth < avgDrawCount * (_klinePadding + _klineWidth) && timeAxisDrawCount == 2) {
            xAxis += self.kLineDrawNume *(_klinePadding + _klineWidth);
        } else {
            xAxis += avgDrawCount *(_klinePadding + _klineWidth);
        }
    }
    
    CGContextSetLineDash(context, 0, 0, 0);
}



- (void)drawKline {

    CGFloat scale = (self.maxKlineValue - self.minKlineValue)/self.yAxisHeight;
    if (scale == 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    
    CGFloat xAxis = _klinePadding;
    [self.xAxisContext removeAllObjects];
    
    
    CGPoint maxPoint, minPoint;
    
    for (FTKlineModel *item in [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNume)]) {
        
        [self.xAxisContext setObject:@([_contexts indexOfObject:item]) forKey:@(self.leftMargin + xAxis + _klineWidth)];
        
        
   
        CGFloat open = [item.open floatValue];
        CGFloat close = [item.close floatValue];
        UIColor *fillColor = open > close ? self.negativeLineColor : self.positiveLineColor;
        
      
        [fillColor set];
        CGContextSetLineWidth(context, 1);
        
        
        CGFloat diffValue = fabs(open - close);
        CGFloat width = _klineWidth;
        

        CGFloat highYAxis = self.yAxisHeight - (item.high - self.minKlineValue)/scale;
        CGPoint highPoint = CGPointMake(self.leftMargin + xAxis + width/2.0, self.topMargin + highYAxis);
        CGFloat lowYAxis = self.yAxisHeight - (item.low - self.minKlineValue)/scale;
        CGPoint lowPoint = CGPointMake(self.leftMargin + xAxis + width/2.0, self.topMargin + lowYAxis);
        
      
        const CGPoint points[] = {highPoint,lowPoint};
        CGContextStrokeLineSegments(context, points, 2);
        
       
        CGFloat openYAxis = self.yAxisHeight - (([item.open floatValue]) - self.minKlineValue)/scale;
        CGPoint openPoint = CGPointMake(self.leftMargin + xAxis + width/2.0, self.topMargin + openYAxis);
        
        CGFloat closeYAxis = self.yAxisHeight - (([item.close floatValue]) - self.minKlineValue)/scale;
        CGPoint closePoint = CGPointMake(self.leftMargin + xAxis + width/2.0, self.topMargin + closeYAxis);
        
    
        if (openPoint.y > closePoint.y) {
            CGMutablePathRef path = CGPathCreateMutable();
            
            CGRect rectangle = CGRectMake(openPoint.x - width/2, closePoint.y, width, diffValue/scale == 0 ? 1 : diffValue/scale);
            CGPathAddRect(path, NULL, rectangle);
            CGContextRef currentContext = UIGraphicsGetCurrentContext();
            CGContextAddPath(currentContext, path);
            [self.chartBackgroundColor setFill];
            CGContextSetLineWidth(currentContext, 1.f);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            CGPathRelease(path);
        } else {
            //绿线
            CGMutablePathRef path = CGPathCreateMutable();
            CGRect rectangle = CGRectMake(openPoint.x - width/2, openPoint.y, width, diffValue/scale == 0 ? 1 : diffValue/scale);
            CGPathAddRect(path, NULL, rectangle);
            CGContextRef currentContext = UIGraphicsGetCurrentContext();
            CGContextAddPath(currentContext, path);
            [self.negativeLineColor setFill];
            CGContextSetLineWidth(currentContext, 1.f);
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            CGPathRelease(path);
        }
        
        
        if (item.high == self.maxHighValue) {
            maxPoint = highPoint;
        }

        if ( item.low == self.minLowValue) {
            minPoint = lowPoint;
        }
        
        
        xAxis += width + _klinePadding;
    }
    
    if (self.isShowMaxMinValue) {

        
        
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[FTChartDealvalueTool dealDecimalWithNum:@(self.maxHighValue) DecimalPlaces:self.lastSaveDecimalPlaces] attributes:@{NSFontAttributeName:self.xAxisTitleFont,NSForegroundColorAttributeName:self.yAxisTitleColor,NSBackgroundColorAttributeName:maxHighBgColor}];
    
        
        CGSize size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        
        float originX = maxPoint.x - size.width - self.klineWidth - 2 < self.leftMargin + self.klineWidth + 2.0 ?  maxPoint.x + self.klineWidth + 5: maxPoint.x - size.width - self.klineWidth - 5;
        
        CGContextSetLineWidth(context, 0.5);
        CGContextSetStrokeColorWithColor(context, PriceLightGray.CGColor);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, maxPoint.x, maxPoint.y);
        CGContextAddLineToPoint(context, originX, maxPoint.y);
        CGContextStrokePath(context);
        
        [attString drawInRect:CGRectMake(originX, maxPoint.y - size.height/2.0, size.width + 8, size.height)];
        
        
        
        attString = [[NSAttributedString alloc] initWithString:[FTChartDealvalueTool dealDecimalWithNum:@(self.minLowValue) DecimalPlaces:self.lastSaveDecimalPlaces] attributes:@{NSFontAttributeName:self.xAxisTitleFont,NSForegroundColorAttributeName:self.yAxisTitleColor,NSBackgroundColorAttributeName:minLowBgColor}];
        size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        originX = minPoint.x - size.width - self.klineWidth - 2 < self.leftMargin + self.klineWidth + 2.0 ?  minPoint.x + self.klineWidth + 5 : minPoint.x - size.width - self.klineWidth - 5;
        
        
        CGContextSetLineWidth(context, 0.5);
        CGContextSetStrokeColorWithColor(context, PriceLightGray.CGColor);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, minPoint.x, minPoint.y);
        CGContextAddLineToPoint(context, originX, minPoint.y);
        CGContextStrokePath(context);
        
        [attString drawInRect:CGRectMake(originX, minPoint.y - size.height/2.0, size.width + 8, size.height)];
    }
}

- (void)drawAvgLine {
    if (!self.showAvgLine) {
        return;
    }
    
    self.lineContexts = self.klinItemData.lineContexts;
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:self.lineContexts.count];
    NSMutableArray *colorArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.lineContexts.count; i++) {
        
        NSMutableArray *lineArray = [NSMutableArray array];
        CCSTitledLine *titledLine = self.lineContexts[i];
        
        [colorArray addObject:titledLine.color];
        
        NSArray *subArray = [titledLine.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNume)];
        
        for (NSInteger j = 0; j < subArray.count; j++) {
            FTLineData *model = subArray[j];
            [lineArray addObject:model];
        }
        [dataArray addObject:lineArray];
    }
    
    
    
    CGFloat lineScale = (self.maxKlineValue - self.minKlineValue)/self.yAxisHeight;
    CGFloat lineAxis = self.leftMargin + _klinePadding;
    CGFloat maxlineY = self.topMargin + self.yAxisHeight;
    
    
    for (NSInteger i = 0; i < dataArray.count; i++) {
        NSArray *tempArray = [self changeKlineValuesToPoints:dataArray[i] FromAxis:lineAxis MainScale:lineScale minValue:self.minKlineValue ViewMaxY:maxlineY];
        [self drawAvgGraphPathFromPoints:tempArray lineColor:colorArray[i] lineWidth:self.movingAvgLineWidth];
    }
}

- (void)drawIndexChart {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat scale = (fabs(self.maxIndexValue) + fabs(self.minIndexValue))/self.yAxisIndexHeight;
    if (scale == 0 || self.IndexContexts.count == 0) {
        return;
    }
    
    CGContextSetLineWidth(context, self.klineWidth);
    CGFloat xAxisIndexMin = self.leftMargin + self.klinePadding;
    CGFloat yAxisIndexMin = self.topMargin + self.yAxisHeight + self.timeAxisHeight + self.IndexNameHeight;
    CGFloat yAxisIndexMax = self.topMargin + self.yAxisHeight + self.timeAxisHeight + self.IndexNameHeight + self.yAxisIndexHeight;
    CGFloat yAxisIndexZero = yAxisIndexMin + self.yAxisIndexHeight - fabs(0 - self.minIndexValue)/scale;
 
    
    CGFloat yAxisIndex;
    
    
    if (self.bottomIndexType == MACD) {
        
        for (NSInteger i = self.IndexContexts.count - 1; i >= 0; i--) {
            
            if (i == self.IndexContexts.count - 1) {
                CCSTitledLine *macdBar = self.IndexContexts[i];
                NSArray *subMacdArray = [macdBar.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNume)];
                for (NSInteger i = 0; i < subMacdArray.count; i++) {
                    FTLineData *item = subMacdArray[i];
                    CGFloat macdValue = item.value;
                    CGFloat macdValueHeight = fabs((macdValue - 0)/scale);
                    
                    UIColor *fillColor;
                    if (macdValue > 0) {
                        fillColor = self.positiveLineColor;
                        yAxisIndex = yAxisIndexZero - macdValueHeight;
                    } else {
                        fillColor = self.negativeLineColor;
                        yAxisIndex = yAxisIndexZero;
                    }
                    
                    
                    CGRect strokeRect = CGRectMake(xAxisIndexMin, yAxisIndex                                                                                                   , self.klineWidth, macdValueHeight);
                    CGContextSetFillColorWithColor(context, fillColor.CGColor);
                    CGContextAddRect(context, strokeRect);
                    CGContextFillPath(context);
                    xAxisIndexMin += self.klinePadding + self.klineWidth;
                }
            }
            
            
            if (i != self.IndexContexts.count - 1) {
                CCSTitledLine *macdLines = self.IndexContexts[i];
                UIColor *lineColor = macdLines.color;
                NSArray *subMacdArray = [macdLines.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNume)];
                NSMutableArray *linesArray = [NSMutableArray new];
                for (NSInteger i = 0; i < subMacdArray.count; i++) {
                    FTLineData *item = subMacdArray[i];
                    [linesArray addObject:item];
                }
                
               
                
                NSArray *tempArray = [self changeKlineValuesToPoints:linesArray FromAxis:self.leftMargin + self.klinePadding MainScale:scale minValue:self.minIndexValue ViewMaxY:self.topMargin + self.yAxisHeight + self.timeAxisHeight + self.IndexNameHeight + self.yAxisIndexHeight];
                [self drawAvgGraphPathFromPoints:tempArray lineColor:lineColor lineWidth:self.movingAvgLineWidth];
            }
            
        }
    }
    
    
    if (self.bottomIndexType != MACD) {
        
        for (NSInteger i = 0; i < self.IndexContexts.count; i++) {
            CCSTitledLine *macdLines = self.IndexContexts[i];
            UIColor *lineColor = macdLines.color;
        
            NSArray *subMacdArray = [macdLines.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNume)];
            NSMutableArray *linesArray = [NSMutableArray new];
            for (NSInteger i = 0; i < subMacdArray.count; i++) {
                FTLineData *item = subMacdArray[i];
                [linesArray addObject:item];
            }
            
            
            scale = (self.maxIndexValue - self.minIndexValue)/self.yAxisIndexHeight;
            
            
            NSArray *tempArray = [self changeIndexValuesToPoints:linesArray FromAxis:self.leftMargin + self.klinePadding MainScale:scale minValue:self.minIndexValue ViewMaxY:yAxisIndexMax];
            [self drawAvgGraphPathFromPoints:tempArray lineColor:lineColor lineWidth:self.movingAvgLineWidth];
        }
    }
    
}




#pragma mark - drawPrivateMethd
- (void)resetMaxAndMin {
    
    if (self.contexts.count == 0 || self.lineContexts.count == 0 || self.IndexContexts.count == 0) {
        return;
    }
    
    
    NSArray *drawContext = self.contexts;
    NSArray *drawlineContexts = self.lineContexts;
    NSArray *drawIndexContexts = self.IndexContexts;
    
    NSString *maxLineValue;
    NSString *minLineValeu;
    
    NSString *maxKlineValue;
    NSString *minKlineValue;
    
    NSString *maxValue;
    NSString *minValue;
 

    
    NSMutableArray *compareArray = [NSMutableArray new];
    NSMutableArray *tempArray = [NSMutableArray new];
    

    NSMutableArray *klineOpenValue = [NSMutableArray new];
    NSMutableArray *klineCloseValue = [NSMutableArray new];
    
    if (self.yAxisTitleIsChange) {
        drawContext = [drawContext subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNume)];
        
        for (FTKlineModel *kline in drawContext) {
            
            [klineOpenValue addObject:@(kline.high)];
            [klineCloseValue addObject:@(kline.low)];
            
        }
        maxKlineValue = [klineOpenValue valueForKeyPath:@"@max.floatValue"];
        minKlineValue = [klineCloseValue valueForKeyPath:@"@min.floatValue"];
        
        [compareArray addObject:maxKlineValue];
        [compareArray addObject:minKlineValue];
    }
    
    self.maxHighValue = [[compareArray valueForKeyPath:@"@max.floatValue"] floatValue];
    self.minLowValue = [[compareArray valueForKeyPath:@"@min.floatValue"] floatValue];
    

    for (CCSTitledLine *line in drawlineContexts) {
        
        if (line.data.count == 0) return;

        for (FTLineData *item in [line.data subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNume)]) {
            if (item.value == 0) {
                continue;
            }
            [tempArray addObject:@(item.value)];
        }
        
        if (tempArray.count != 0) {
            
            maxLineValue = [tempArray valueForKeyPath:@"@max.floatValue"];
            minLineValeu = [tempArray valueForKeyPath:@"@min.floatValue"];
            
            [compareArray addObject:maxLineValue];
            [compareArray addObject:minLineValeu];

        }

    }
    
    maxValue = [compareArray valueForKeyPath:@"@max.floatValue"];
    minValue = [compareArray valueForKeyPath:@"@min.floatValue"];
    

    self.maxKlineValue = [maxValue floatValue] + ([maxValue floatValue] - [minValue floatValue])/8;
    self.minKlineValue = [minValue floatValue] - ([maxValue floatValue] - [minValue floatValue])/10;
    
    DLog(@"%f", self.maxKlineValue);
    DLog(@"%f", self.minKlineValue);
    
    
    // 清空容器
    [compareArray removeAllObjects];
    
    
    
    NSMutableArray *compareIndexArray = [NSMutableArray new];
    
    if (self.yAxisTitleIsChange) {
    
        float minIndexValue = 0.0;
        float maxIndexValue = 0.0;
        
        for (NSInteger i = 0; i < drawIndexContexts.count; i++) {
        

            NSArray *subArray = [[(CCSTitledLine *)drawIndexContexts[i] data] subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kLineDrawNume)];
            
            for (NSInteger j = 0; j < subArray.count; j++) {
                
                FTLineData *lineItem = subArray[j];
                
                if (j == 0) {
                    minIndexValue = lineItem.value;
                    maxIndexValue = lineItem.value;
                }
                
                if (j != 0) {
                    
                    if (minIndexValue < lineItem.value) {
                        minIndexValue = lineItem.value;
                    }
                    
                    if (maxIndexValue > lineItem.value) {
                        maxIndexValue = lineItem.value;
                    }
                    
                }
            }
            
            [compareIndexArray addObject:@(minIndexValue)];
            [compareIndexArray addObject:@(maxIndexValue)];
        }
        
    }
    
    
    float maxIndexValue = [[compareIndexArray valueForKeyPath:@"@max.floatValue"] floatValue];
    float minIndexValue = [[compareIndexArray valueForKeyPath:@"@min.floatValue"] floatValue];
  
    self.maxIndexValue = maxIndexValue + (maxIndexValue - minIndexValue)/10;
    self.minIndexValue = minIndexValue - (maxIndexValue - minIndexValue)/10;
}


- (NSArray *)changeKlineValuesToPoints:(NSArray *)Values FromAxis:(CGFloat)xAxis MainScale:(CGFloat)scale minValue:(CGFloat)minValue ViewMaxY:(CGFloat)maxY{
    
    xAxis += self.klineWidth/2.0;
    NSMutableArray *pointsArray = [NSMutableArray array];
    for (NSInteger i = 0; i < Values.count; i++) {
        FTLineData *item = Values[i];
        CGFloat value = item.value;
        if (value == 0) {
            xAxis += _klinePadding + _klineWidth;
            continue;
        }
        CGFloat yAxis = maxY - fabs(value - minValue)/scale;
        CGPoint point = CGPointMake(xAxis, yAxis);
        [pointsArray addObject:NSStringFromCGPoint(point)];
        
        [self.xAxisAvgLineContext setObject:@([Values indexOfObject:item]) forKey:@(xAxis + _klineWidth/2.0)];
        
        xAxis += _klinePadding + _klineWidth;
    }
    return pointsArray;
}

- (NSArray *)changeIndexValuesToPoints:(NSArray *)Values FromAxis:(CGFloat)xAxis MainScale:(CGFloat)scale minValue:(CGFloat)minValue ViewMaxY:(CGFloat)maxY{
    
    xAxis += self.klineWidth/2.0;
    NSMutableArray *pointsArray = [NSMutableArray array];
    for (NSInteger i = 0; i < Values.count; i++) {
        FTLineData *item = Values[i];
        CGFloat value = item.value;
        if (value == 0) {
            xAxis += _klinePadding + _klineWidth;
            continue;
        }
        
        CGFloat yAxis = self.yAxisIndexHeight - (item.value - self.minIndexValue)/scale;

        CGPoint point = CGPointMake(xAxis,self.topMargin + self.yAxisHeight + self.timeAxisHeight + self.IndexNameHeight + yAxis);
        [pointsArray addObject:NSStringFromCGPoint(point)];
        
        [self.xAxisIndexContext setObject:@([Values indexOfObject:item]) forKey:@(xAxis + _klineWidth/2.0)];
        
        xAxis += _klinePadding + _klineWidth;
    }
    return pointsArray;
}


- (void)drawAvgGraphPathFromPoints:(NSArray *)points lineColor:(UIColor *)color lineWidth:(CGFloat)lineWidth{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointFromString([points firstObject])];
    
    for (NSInteger i = 1; i < points.count; i++) {
        [path addLineToPoint:CGPointFromString(points[i])];
    }
    
   // path = [path smoothedPathWithGranularity:10];
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
}


#pragma mark - touchEvent
- (void)tapEvent:(UITapGestureRecognizer *)tap {
    return;
}


#pragma mark - EventMethod
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    
    [self postNotificationWithGestureRecognizerStatus:longPress.state];
    
    if (!self.contexts || self.contexts.count == 0 || self.supportGesture == NO) {
        return;
    }
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.horizantalCrossLine.hidden = YES;
            self.verticalCrossLine.hidden = YES;
            self.verticalIndexCrossLine.hidden = YES;
            self.pointCrossLine.hidden = YES;
           // self.klineTipView.hidden = YES;
            
            self.klineTipView.hidden = (self.direction == KlineChartDirectionVertical) ? YES : NO;
            self.indexTipView.hidden = (self.direction == KlineChartDirectionVertical) ? YES : NO;
            
            self.valueLb.hidden = YES;
            self.timeLb.hidden = YES;
       
            self.klineChangeBtn.hidden = NO;
            self.indexChaneBtn.hidden = NO;
            self.indexSetBtn.hidden = NO;
          
            
            if ([self.delegate respondsToSelector:@selector(klineViewLongPressCancle:)]) {
                [self.delegate klineViewLongPressCancle:self];
            }
        });
        return;
    }
    
    CGPoint touchPoint = [longPress locationInView:self];
    
    if (touchPoint.x > self.leftMargin && touchPoint.x < self.frame.size.width - self.rightMargin && touchPoint.y > self.topMargin && touchPoint.y < self.frame.size.height) {
        
        self.indexSetBtn.hidden = YES;
      //  self.indexChaneBtn.hidden = YES;
      //  self.klineTipView.hidden = NO;
        self.klineTipView.hidden = NO;
        self.indexTipView.hidden = NO;
        
        [self.xAxisContext enumerateKeysAndObjectsUsingBlock:^(NSNumber *xAxiskey, NSNumber *indexObject, BOOL * _Nonnull stop) {
           
            CGFloat endPoint =  [xAxiskey floatValue];
            CGFloat startPoint = endPoint - self.klineWidth - self.klinePadding;
            
            if (touchPoint.x > startPoint && touchPoint.x < endPoint) {
                
                
                self.verticalCrossLine.hidden = NO;
                self.horizantalCrossLine.hidden = NO;
                self.verticalIndexCrossLine.hidden = NO;
                
            
                NSInteger index = [indexObject integerValue];

          
                CGFloat scale = (self.maxKlineValue - self.minKlineValue)/self.yAxisHeight;
                FTKlineModel *model = self.contexts[index];
                CGFloat xAxis = [xAxiskey floatValue] - self.klineWidth/2.0;
                CGFloat yAxis  = self.yAxisHeight - ([model.close floatValue] - self.minKlineValue)/scale + self.topMargin;
                
              
                CGFloat open = [model.open floatValue];
                CGFloat close = [model.close floatValue];
                CGFloat closeAxis = self.yAxisHeight - (close - self.minKlineValue)/scale + self.topMargin;
                yAxis = (open > close) ? closeAxis : closeAxis;
                
        
                [self showCroosLineWithPoint:CGPointMake(xAxis, yAxis) index:index];
                
                
                if (model == nil) {
                    return;
                } else {
                    [self configDataWithIndex:index atPoint:CGPointMake(xAxis, yAxis)];
                }
                
                *stop = YES;
            }
            
        }];
    }
}


- (void)showCroosLineWithPoint:(CGPoint)point index:(NSInteger)index {
    
    
    self.pointCrossLine.hidden = NO;
    self.pointCrossLine.center = point;
    
    

    CGRect verticalRect = self.verticalCrossLine.frame;
    CGRect horizantalRect = self.horizantalCrossLine.frame;
    
    horizantalRect.origin.y = point.y;
    verticalRect.origin.x = point.x;
    self.horizantalCrossLine.frame = horizantalRect;
    self.verticalCrossLine.frame = verticalRect;
    

    CGRect verticalIndexRect = self.verticalIndexCrossLine.frame;
    verticalIndexRect.origin.x = point.x;
    self.verticalIndexCrossLine.frame = verticalIndexRect;
    

    NSString *date = [self timeWithTimeIntervalString:self.dates[index] returnType:self.timeFormater];
    self.timeLb.text = date;
    self.timeLb.hidden = date.length > 0 ? NO : YES;
    if (date.length > 0) {
        CGSize size = [date boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.xAxisTitleFont} context:nil].size;
        CGFloat originX = MAX(self.leftMargin, point.x - size.width/2);
        originX = MIN((self.leftMargin + self.xAxisWidth - size.width), originX);
        self.timeLb.frame = CGRectMake(originX, self.topMargin + self.yAxisHeight + self.separatorWidth, size.width + 5 , size.height + 5);
    }

    
  
    self.valueLb.hidden = NO;
    FTKlineModel *model = self.contexts[index];
    NSString *valueText = [FTChartDealvalueTool dealDecimalWithNum:[NSNumber numberWithFloat:[model.close floatValue]] DecimalPlaces:self.lastSaveDecimalPlaces];
    
    CGSize size = [valueText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.yAxisTitleFont} context:nil].size;
    CGRect frameValuelb = self.valueLb.frame;
    CGFloat ValuelbX;
    
    ValuelbX = self.direction == KlineChartDirectionVertical ? self.leftMargin : self.leftMargin -  2 * _klinePadding - self.klineWidth/2.0 - size.width;

    CGFloat ValuelbY = self.horizantalCrossLine.frame.origin.y - frameValuelb.size.height/2.0;
    self.valueLb.frame = CGRectMake(ValuelbX, ValuelbY, size.width + 5, size.height + 5);
    self.valueLb.text = valueText;
    
    
}


- (void)configDataWithIndex:(NSInteger )index atPoint:(CGPoint)point {
    

    FTKlineModel *model = self.contexts[index];
    
    
    if ([self.delegate respondsToSelector:@selector(klineView:TouchOnkline:Context:AtIndex:)]) {
        [self.delegate klineView:self TouchOnkline:model Context:self.contexts AtIndex:index];
    }
    
    
    if (self.klineTipArray.count != 0) {
        [self.klineTipArray removeAllObjects];
    }

    for (NSInteger i = 0; i < self.lineContexts.count; i++) {
        CCSTitledLine *titleLine = self.lineContexts[i];
        FTLineData *line = [titleLine.data objectAtIndex:index];
        line.title = titleLine.title;
        line.color = titleLine.color;
        
        [self.klineTipArray addObject:line];

    }
    
    self.klineTipView.tipTitleArray = self.klineTipArray;
    
    
    
    if (self.indexTipArray.count != 0) {
        [self.indexTipArray removeAllObjects];
    }
    
   
    for (NSInteger i = 0; i < self.IndexContexts.count; i++) {
        CCSTitledLine *titleLine = self.IndexContexts[i];
        FTLineData *line = [titleLine.data objectAtIndex:index];
        line.title = titleLine.title;
        line.color = titleLine.color;
        [self.indexTipArray addObject:line];
    }
    
    self.indexTipView.tipTitleArray = self.indexTipArray;

}


- (void)panEventWith:(UIPanGestureRecognizer *)pan {

    CGPoint touchPoint = [pan translationInView:self];
    
    self.verticalCrossLine.hidden = YES;
    self.horizantalCrossLine.hidden = YES;
    
    NSInteger offsetIndex = fabs(touchPoint.x/((self.klineWidth > self.maxKlineWidth/2.0 ? 16.0f : 8)));
    
    if (!self.scrollEnable || self.contexts.count == 0 || offsetIndex == 0) {
        return;
    }
    
    if (touchPoint.x > 0) {
        self.startDrawIndex = self.startDrawIndex - offsetIndex < 0 ? 0 : self.startDrawIndex - offsetIndex;
    } else {
        self.startDrawIndex = self.startDrawIndex + offsetIndex + self.kLineDrawNume > self.contexts.count ? self.contexts.count - self.kLineDrawNume : self.startDrawIndex + offsetIndex;
    }

    
  //  [self resetMaxAndMin];
    [pan setTranslation:CGPointZero inView:self];
    [self setNeedsDisplay];
}


- (void)pichEventWith:(UIPinchGestureRecognizer *)pinch {
    
    
    DLog(@"lastPaScale = %f",self.lastPacScale);
    
    CGFloat scale = pinch.scale - self.lastPacScale + 1;
    
    [self postNotificationWithGestureRecognizerStatus:pinch.state];
    
    if (!self.zommEnable || self.contexts.count == 0) {
        return;
    }
    
    self.klineWidth = _klineWidth * scale;
    
    CGFloat forwardDrawCount = self.kLineDrawNume;
    
    _kLineDrawNume = floor((self.frame.size.width - self.leftMargin - self.rightMargin) / (self.klineWidth + self.klinePadding));
    
    CGFloat diffWidth = (self.frame.size.width - self.leftMargin - self.rightMargin) - (self.klineWidth + self.klinePadding)*_kLineDrawNume;
    if (diffWidth > 4*(self.klineWidth + self.klinePadding)/5.0) {
        _kLineDrawNume = _kLineDrawNume + 1;
    }
    
    _kLineDrawNume = self.contexts.count > 0 && _kLineDrawNume < self.contexts.count ? _kLineDrawNume : self.contexts.count;
//    if (forwardDrawCount == self.kLineDrawNume && self.maxKlineWidth != self.klineWidth) {
//        return;
//    }
    
    NSInteger diffCount = fabs(self.kLineDrawNume - forwardDrawCount);
    
    if (forwardDrawCount > self.startDrawIndex) {
  
        self.startDrawIndex += ceil(diffCount/2.0);
    } else {

        self.startDrawIndex -= floor(diffCount/2.0);
        self.startDrawIndex = self.startDrawIndex < 0 ? 0 : self.startDrawIndex;
    }
    
    self.startDrawIndex = self.startDrawIndex + self.kLineDrawNume > self.contexts.count ? self.contexts.count - self.kLineDrawNume : self.startDrawIndex;

    
    pinch.scale = scale;
    self.lastPacScale = pinch.scale;
    
    [self setNeedsDisplay];
    
}

#pragma mark - private Method
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString returnType:(ChartTimeFormater)formaterTime {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    if (formaterTime == Chart_yyyymmdd) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    } else if (formaterTime == Chart_mmddhhmm) {
        [formatter setDateFormat:@"MM-dd HH:mm"];
    }
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}



#pragma mark - setter
- (void)setKlinItemData:(FTKlineItemData *)klinItemData {
    _klinItemData = klinItemData;
    self.contexts = klinItemData.context;
    self.lineContexts = klinItemData.lineContexts;
    self.IndexContexts = klinItemData.indexContexts;
}


- (void)setKLineDrawNume:(NSInteger)kLineDrawNume {
    if (kLineDrawNume < 0) {
        _kLineDrawNume = 0;
    }
    
    _kLineDrawNume = self.contexts.count > 0  && kLineDrawNume < self.contexts.count ? kLineDrawNume : self.contexts.count;
    
//    if (_kLineDrawNume != 0) {
//        self.klineWidth = (self.frame.size.width - self.leftMargin - self.rightMargin - _klinePadding)/_kLineDrawNume - _klinePadding;
//    }
}


- (void)setKlineWidth:(CGFloat)klineWidth {
    
    
    if (klineWidth <= self.minKlineWidth) {
        klineWidth = self.minKlineWidth;
    }
    
    if (klineWidth >= self.maxKlineWidth) {
        klineWidth = self.maxKlineWidth;
    }

    _klineWidth = klineWidth;
}

- (void)setMaxKlineWidth:(CGFloat)maxKlineWidth {
    if (maxKlineWidth < _minKlineWidth) {
        maxKlineWidth = _minKlineWidth;
    }
    
    CGFloat realAxisWidth = (self.frame.size.width - self.leftMargin - self.rightMargin - _klinePadding);
    NSInteger maxKlineCount = floor(realAxisWidth)/(maxKlineWidth + _klinePadding);
    maxKlineWidth = realAxisWidth/maxKlineCount - _klinePadding;
    
    _maxKlineWidth = maxKlineWidth;
}

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    self.maxKlineWidth = _maxKlineWidth;
}

- (void)setPeriod:(NSString *)period {
    _period = period;
    
    if ([period isEqualToString:@"1440"] || [period isEqualToString:@"week"] || [period isEqualToString:@"week"]) {
        self.timeFormater = Chart_yyyymmdd;
    } else {
        self.timeFormater = Chart_mmddhhmm;
    }
    
}


#pragma mark - getter
- (NSInteger)saveDecimalPlaces {
    CGFloat avgValue = (self.maxKlineValue - self.minKlineValue)/5.0;
    if (avgValue < 0.01) {
        _saveDecimalPlaces = 4;
    } else if (avgValue < 0.1) {
        _saveDecimalPlaces = 3;
    } else if (avgValue < 1) {
        _saveDecimalPlaces = 2;
    } else {
        _saveDecimalPlaces = 0;
    }
    return _saveDecimalPlaces;
}

- (UIView *)pointCrossLine {
    if (!_pointCrossLine) {
        _pointCrossLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pointCrossLineWidth, self.pointCrossLineWidth)];
        _pointCrossLine.backgroundColor = self.croosLineColor;
        _pointCrossLine.hidden = YES;
        _pointCrossLine.layer.cornerRadius = _pointCrossLine.frame.size.height/2.0;
        [self addSubview:_pointCrossLine];
    }
    return _pointCrossLine;
}


- (UIView *)verticalCrossLine {
    if (!_verticalCrossLine) {
        _verticalCrossLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.topMargin, 0.5, self.yAxisHeight)];
        _verticalCrossLine.backgroundColor = self.croosLineColor;
        _verticalCrossLine.hidden = YES;
        [self addSubview:_verticalCrossLine];
    }
    return _verticalCrossLine;
}

- (UIView *)horizantalCrossLine {
    if (!_horizantalCrossLine) {
        _horizantalCrossLine = [[UIView alloc] initWithFrame:CGRectMake(self.leftMargin, 0, self.xAxisWidth, 0.5)];
        _horizantalCrossLine.backgroundColor = self.croosLineColor;
        _horizantalCrossLine.hidden = YES;
        [self addSubview:_horizantalCrossLine];
    }
    return _horizantalCrossLine;
}


- (UIView *)verticalIndexCrossLine {
    if (!_verticalIndexCrossLine) {
        _verticalIndexCrossLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.topMargin + self.yAxisHeight + self.timeAxisHeight + self.IndexNameHeight, 0.5, self.yAxisIndexHeight)];
        _verticalIndexCrossLine.backgroundColor = self.croosLineColor;
        _verticalIndexCrossLine.hidden = YES;
        [self addSubview:_verticalIndexCrossLine];
    }
    return _verticalIndexCrossLine;
}




- (UIButton *)klineChangeBtn {
    if (!_klineChangeBtn) {
        _klineChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       // _klineChangeBtn.frame = CGRectMake(self.leftMargin, 0, 80, 30);
        //_klineChangeBtn.titleLabel.font = GXFONT_PingFangSC_Regular(7);
        _klineChangeBtn.titleLabel.font = self.xAxisTitleFont;
        [_klineChangeBtn setTitleColor:PriceLightGray forState:UIControlStateNormal];
        _klineChangeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _klineChangeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _klineChangeBtn.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
        [_klineChangeBtn setEnlargeEdgeWithTop:20 right:40 bottom:10 left:10];
        if (self.direction == KlineChartDirectionVertical) {
            [_klineChangeBtn addTarget:self action:@selector(ClickOnKlineChangeIndex:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:_klineChangeBtn];
    }
    return _klineChangeBtn;
}

- (UIButton *)indexChaneBtn {
    if (!_indexChaneBtn) {
        _indexChaneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     //   _indexChaneBtn.frame = CGRectMake(self.leftMargin, self.topMargin + self.yAxisHeight + self.timeAxisHeight, 100, self.IndexNameHeight);
        [_indexChaneBtn setTitleColor:PriceLightGray forState:UIControlStateNormal];
      //  _indexChaneBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        ///_indexChaneBtn.titleLabel.font = GXFONT_PingFangSC_Regular(7);
        _indexChaneBtn.titleLabel.font = self.xAxisTitleFont;
        _indexChaneBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     //   _indexChaneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [_indexChaneBtn addTarget:self action:@selector(ClickOnIndexChangeIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_indexChaneBtn];
        
    }
    return _indexChaneBtn;
}


- (UIButton *)indexSetBtn {
    if (!_indexSetBtn) {
        _indexSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _indexSetBtn.frame = CGRectMake(self.leftMargin + self.xAxisWidth - 100, self.topMargin + self.yAxisHeight + self.timeAxisHeight, 100, self.IndexNameHeight);
        [_indexSetBtn setEnlargeEdgeWithTop:20 right:10 bottom:20 left:10];
        _indexSetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_indexSetBtn addTarget:self action:@selector(ClickOnSetIndexButton:) forControlEvents:UIControlEventTouchUpInside];
        [_indexSetBtn setImage:IMAGE_NAMED(@"priceset") forState:UIControlStateNormal];
    }
    
    return _indexSetBtn;
}

- (KlineTipView *)klineTipView {
    if (!_klineTipView) {
        _klineTipView = [[KlineTipView alloc] initWithFrame:CGRectMake(self.leftMargin + self.klineChangeBtn.width, self.topMargin, self.xAxisWidth, 10)];
        [self addSubview:_klineTipView];
    }
    return _klineTipView;
}

- (IndexTipView *)indexTipView {
    if (!_indexTipView) {
        _indexTipView = [[IndexTipView alloc] initWithFrame:CGRectMake(self.leftMargin + self.indexChaneBtn.width, self.topMargin + self.yAxisHeight + self.timeAxisHeight, self.xAxisWidth, 20)];
        [self addSubview:_indexTipView];
    }
    return _indexTipView;
}


- (NSMutableArray *)klineTipArray {
    if (!_klineTipArray) {
        _klineTipArray = [NSMutableArray array];
    }
    return _klineTipArray;
}

- (NSMutableArray *)indexTipArray {
    if (!_indexTipArray) {
        _indexTipArray = [NSMutableArray array];
    }
    return _indexTipArray;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [[UILabel alloc] init];
        _timeLb.textAlignment = NSTextAlignmentCenter;
        _timeLb.font = self.xAxisTitleFont;
        _timeLb.textColor = self.tipTextColor;
        _timeLb.layer.borderColor = self.tipBorderColor.CGColor;
        _timeLb.layer.borderWidth = self.tipBorderWidth;
        _timeLb.backgroundColor = self.tipBackGroundColor;
        [self addSubview:_timeLb];
    }
    return _timeLb;
}



- (UILabel *)valueLb {
    if (!_valueLb) {
        _valueLb = [[UILabel alloc] init];
        _valueLb.textAlignment = NSTextAlignmentCenter;
        _valueLb.font = self.yAxisTitleFont;
        _valueLb.textColor = self.tipTextColor;
        _valueLb.layer.borderColor = self.tipBorderColor.CGColor;
        _valueLb.layer.borderWidth = self.tipBorderWidth;
        _valueLb.backgroundColor = self.tipBackGroundColor;
        [self addSubview:_valueLb];
    }
    return _valueLb;
}


//- (UITapGestureRecognizer *)tapGesture {
//    if (!_tapGesture) {
//        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
//    }
//    return _tapGesture;
//}
//
//
//- (UILongPressGestureRecognizer *)longPressGesture {
//    if (!_longPressGesture) {
//        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
//    }
//    return  _longPressGesture;
//}
//
//- (UIPanGestureRecognizer *)panGesture {
//    if (!_panGesture) {
//        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
//    }
//    return _panGesture;
//}
//
//- (UIPinchGestureRecognizer *)pinchGestrue {
//    if (!_pinchGestrue) {
//        _pinchGestrue = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pichEvent:)];
//    }
//    return _pinchGestrue;
//}




@end

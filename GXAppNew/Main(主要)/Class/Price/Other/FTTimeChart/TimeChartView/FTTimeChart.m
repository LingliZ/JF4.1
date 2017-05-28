//
//  FTTimeChart.m
//  ChartDemo
//
//  Created by futang yang on 16/9/20.
//  Copyright © 2016年 yang All rights reserved.
//

#import "FTTimeChart.h"
#import "FTChartDealvalueTool.h"
#import "FTTimeChartDefine.h"



#define FineMargin 5


@interface FTTimeChart ()


// X轴宽度
@property (nonatomic, assign) CGFloat xAxisWidth;
// Y轴宽度
@property(nonatomic ,assign) CGFloat yAxisHeight;
// 实际数据个数
@property (nonatomic, assign) NSUInteger ActualCount;
// 数据点个数
@property (nonatomic, assign) NSInteger kGraphDrawCount;
// 开始绘图的序列
@property (nonatomic, assign) NSInteger startDrawIndex;


// 最大值
@property (nonatomic ,assign) CGFloat maxValue;
// 最小值
@property (nonatomic, assign) CGFloat minValue;




// 昨日收盘价
@property (nonatomic, assign) CGFloat lastCloseValue;
// 图上数据的点
@property (nonatomic, strong) NSArray *points;
// 垂直线
@property (nonatomic, strong) UIView *vtlCrossLine;
// 水平线
@property (nonatomic, strong) UIView *ldCrossLine;
// 交叉点
@property (nonatomic, strong) UIView *pointCrossLine;
// 长按手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
// 单点手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
// 闪烁视图
@property (nonatomic, strong) CALayer *flashLayer;



@property (nonatomic, assign) CGFloat leftMarginX;
@property (nonatomic, assign) CGFloat rightMarginX;


// 时间框
@property (nonatomic, strong) UILabel *timeLb;
// 左侧数值框
@property (nonatomic, strong) UILabel *valueLeftLb;
// 右侧比率数值
@property (nonatomic, strong) UILabel *valueRightLb;




// 数据源
@property (nonatomic, strong) NSDictionary *data;
// 内容数据数组
@property (nonatomic, strong) NSArray *contexts;
// 时间数组
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) FTTimeData *timeData;



@end


@implementation FTTimeChart


@synthesize bottomMargin = _bottomMargin;

#pragma mark - lifeCircle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //配置属性
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    //文字字体
    self.yAxisTitleFont = [UIFont systemFontOfSize:8.0];
    self.yAxisTitleColor = [UIColor grayColor];
    self.yAxisTitleMargin = 2;
    self.xAxisTitleFont = [UIFont systemFontOfSize:8.0];
    self.xAxisTitleColor = [UIColor grayColor];
    self.xAxisTitleMargin = 2;
    
    self.upperCloseColor = [UIColor blackColor];
    self.lowerCloseColor = [UIColor greenColor];
    

    
    // 边框颜色
    self.axisBoderWidth = 1.5;
    self.axisBoderColor = [UIColor colorWithWhite:0.500 alpha:0.953];
    
    //分割
    self.separtorNum = 4;
    self.separatorWidth = 0.5;
    self.separatorColor = [UIColor lightGrayColor];
    
    // 时间高度
    self.timeAxisHeighth = 20.0;

    // 折线颜色宽度
    self.lineWidth = 0.5;
    self.lineColor = [UIColor colorWithHexString:@"#3a87e6"];
    
    
    // 闪烁和颜色
    self.flashPoint = YES;
    self.flashPointColor = [UIColor colorWithRed:0.000 green:0.400 blue:0.600 alpha:1.000];
    
    // 阴影颜色
    //self.gradientStartColor = [UIColor colorWithHexString:@"#4b80c5" withAlpha:0.3];
    self.gradientStartColor = [UIColor clearColor];
    self.gradientEndColor = [UIColor clearColor];
    
    // 提示框相关
    self.tipBackGroundColor = [UIColor whiteColor];
    self.tipBorderColor = [UIColor grayColor];
    self.tipBorderWidth = 0.5;
    
    // 阴影边框宽度
    self.axisBoderWidth = 0.5;
    self.crossLineColor = [UIColor blackColor];
    
    // 保留小数点个数
    self.saveDecimalPlaces = 2;
    
    // 昨日收盘
    self.lastCloseColor = [UIColor grayColor];
    self.lastCloseLineWidth = 0.6;
    
    // 默认圆滑
    self.smoothPath = YES;
    
    // 交叉线大小
    self.pointCrossLineWidth = 3.0;
    self.pointCrossColor = [UIColor blackColor];
    self.crossLineWidth = 0.5;
    self.isShowCrossLine = YES;
    self.delayDisappearCrossLine = 0.3;
    
    

    self.isLdCrosslineAttachmentPoint = YES;
    
    

    
    // 默认不是TD
    self.isTD = NO;
    


    
    // 横向坐标起点
    self.landPointPadding = 0;

    // 添加长按手势
    [self addGestureRecognizer:self.longGesture];
    
    // 添加单点手势
 //[self addGestureRecognizer:self.tapGesture];
}



- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // X坐标轴长度
    self.xAxisWidth = rect.size.width - self.leftMargin - self.rightMargin;
    // Y轴坐标高度
    self.yAxisHeight = rect.size.height - self.topMargin - self.bottomMargin;
    
    //绘制坐标轴虚线
     [self drawLashRect:rect];

    // 绘制折线图
    [self drawLineChart];
    
    // 时间轴
    [self drawTimeAxis];
    
    // 画坐标轴
    [self drawAxisInRect:rect];
}




#pragma mark - public Method
- (void)drawChartWithData:(FTTimeData *)data {
    
    if (!data) {
        return;
    }
    
    _timeData = data;
    
    // 获取数数据
    self.contexts = data.context;
    self.dates = data.dates;

    // 最大最小交易量
    self.maxValue = [data.maxValue floatValue];
    self.minValue = [data.minValue floatValue];
    
    // 昨日收盘价
    self.lastCloseValue = [data.lastClose floatValue];

    // 配置页面
    [self drawSetting];
    
    // 调用绘图
    [self setNeedsDisplay];

}



#pragma mark - private methods
- (void)drawSetting {
    
    //    ceil(x)返回大于或者等于指定表达式的最小整数头文件
    //    floor(x)返回不大于x的最大整数值。
    //    round(x)返回x的四舍五入整数值。
    
    // 调整左侧边距
    if (self.direction == FTChartDirectionVertical) {
        
    }
    
    if (self.direction == FTChartDirectionLandscape) {
    }
    
    
    
    [self cofigLeftAndRight];
 
    
    
    
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[FTChartDealvalueTool dealDecimalWithNum:[NSNumber numberWithFloat:self.maxValue] DecimalPlaces:self.saveDecimalPlaces] attributes:@{NSFontAttributeName:self.yAxisTitleFont, NSForegroundColorAttributeName:self.yAxisTitleColor}];
//    CGSize size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    

    // 调整最大最小值
    [self resetMinAndMax];
    

    self.pointPadding = (self.frame.size.width - self.leftMargin - self.rightMargin - self.landPointPadding)/self.contexts.count;
    self.kGraphDrawCount = ((self.frame.size.width - self.leftMargin - self.rightMargin - self.landPointPadding)/self.pointPadding);
    
}



- (void)cofigLeftAndRight {
    
    // 价格
    NSAttributedString *priceAttString =[[NSAttributedString alloc] initWithString:[FTChartDealvalueTool dealDecimalWithNum:[NSNumber numberWithFloat:self.maxValue] DecimalPlaces:self.saveDecimalPlaces] attributes:@{NSFontAttributeName:self.yAxisTitleFont}];
    // 比率
    NSString *rateString = [NSString stringWithFormat:@"%.2f%%", ((self.minValue - self.lastCloseValue)/self.lastCloseValue) * 100];
    NSAttributedString *rateAttString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",rateString] attributes:@{NSFontAttributeName:self.yAxisTitleFont}];;
    
    CGSize priceSize = [priceAttString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGSize rateSize = [rateAttString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    if (self.isTipsDisplayOutSide) {
        
        self.leftMargin = priceSize.width + 10.0f;
        self.rightMargin = rateSize.width + 10.0f;
        
        
        self.leftMarginX = self.leftMargin - priceSize.width;
        self.rightMarginX = self.bounds.size.width - self.rightMargin;
        
    } else {
        
        self.leftMarginX = self.leftMargin;
        self.rightMarginX = self.bounds.size.width - self.rightMargin - rateSize.width;
        
    }
    
    
}





- (void)resetMinAndMax {
    
    // 以昨日收盘价为基准
    float offsetValue;
    float maxfabsf = fabs(self.maxValue - self.lastCloseValue);
    float minfabsf = fabs(self.minValue - self.lastCloseValue);
    
    offsetValue = (maxfabsf > minfabsf) ? maxfabsf : minfabsf;

    self.maxValue = self.lastCloseValue + offsetValue;
    self.minValue = (self.lastCloseValue - offsetValue) < 0 ? 0 : self.lastCloseValue - offsetValue;
    
    offsetValue = (self.maxValue - self.minValue)/10.0f;
    self.maxValue += offsetValue;
    self.minValue = self.minValue - offsetValue < 0 ? 0 : self.minValue - offsetValue;
  
}


- (void)drawLashRect:(CGRect)rect {
    //绘制边框
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.axisBoderWidth);
    CGContextSetStrokeColorWithColor(context, self.axisBoderColor.CGColor);
    CGRect strokeRect = CGRectMake(self.leftMargin, self.topMargin, self.xAxisWidth, self.yAxisHeight);
    CGContextStrokeRect(context, strokeRect);
    
    
    //绘制分割线横向
    CGFloat avgHeight = strokeRect.size.height/(self.separtorNum);
    CGContextSetLineWidth(context, self.separatorWidth);
    CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
    CGFloat lengths[] = {1,1};
    self.isSeparatorLash ? CGContextSetLineDash(context, 0, lengths, 2) : nil;
    CGContextBeginPath(context);
    
    //画线
    for (NSInteger i = 1; i < self.separtorNum; i++) {
        // 收盘虚线不画
        if (i == 2) {
            continue;
        }
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
        CGContextMoveToPoint(context, self.leftMargin , self.topMargin + avgHeight *i);
        CGContextAddLineToPoint(context, rect.size.width - self.rightMargin, self.topMargin + avgHeight *i);
        CGContextStrokePath(context);
    }
    
    if (self.isSeparatorLash) {
        CGContextSetLineDash(context, 0, 0, 0);
    }
    
    // 昨日收盘价分割线
    CGFloat lengthsClose[] = {6,2};
    CGContextSetLineDash(context, 0, lengthsClose, 2);
    CGContextSetLineWidth(context, self.lastCloseLineWidth);
    CGContextSetStrokeColorWithColor(context, self.lastCloseColor.CGColor);
    CGContextMoveToPoint(context, self.leftMargin, self.yAxisHeight/2.0 + self.topMargin);
    CGContextAddLineToPoint(context, self.leftMargin + self.xAxisWidth , self.yAxisHeight/2.0 + self.topMargin);
    CGContextStrokePath(context);
    
    CGContextSetLineDash(context, 0, 0, 0);
}


- (void)drawAxisInRect:(CGRect)rect {
    
    CGRect strokeRect = CGRectMake(self.leftMargin, self.topMargin, self.xAxisWidth, self.yAxisHeight);
    CGFloat avgHeight = strokeRect.size.height/(self.separtorNum);
    
    CGFloat avgValue = (self.maxValue - self.minValue)/(self.separtorNum);
    
    for (NSInteger i = 0; i < self.separtorNum + 1; i++) {
        
        float yAxisValue = i == (self.separtorNum) ? self.minValue : self.maxValue - avgValue *i;
        
        
        UIColor *color = self.yAxisTitleColor;
        if (yAxisValue - self.lastCloseValue > 0) {
            color = self.upperCloseColor;
        } else if (yAxisValue - self.lastCloseValue < 0) {
            color = self.lowerCloseColor;
        }
    
        //价格
        NSAttributedString *priceAttString = [[NSAttributedString alloc] initWithString:[FTChartDealvalueTool dealDecimalWithNum:@(yAxisValue) DecimalPlaces:self.saveDecimalPlaces] attributes:@{NSFontAttributeName:self.yAxisTitleFont,NSForegroundColorAttributeName:color}];
        //比率
        NSString *rateString = [NSString stringWithFormat:@"%.2f%%", ((yAxisValue - self.lastCloseValue)/self.lastCloseValue) * 100];
        NSAttributedString *rateAttString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",rateString] attributes:@{NSFontAttributeName:self.yAxisTitleFont,NSForegroundColorAttributeName:color}];;
        
        CGSize priceSize = [priceAttString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGSize rateSize = [rateAttString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.yAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGFloat priceX = self.isTipsDisplayOutSide ? self.leftMarginX - 2 : self.leftMarginX + 2;
        CGFloat rateX = self.isTipsDisplayOutSide ? self.rightMarginX + 2 : self.rightMarginX - 2;

        if (i == 0) {
            [priceAttString drawInRect:CGRectMake(priceX, self.topMargin, priceSize.width, priceSize.height)];
            [rateAttString drawInRect:CGRectMake(rateX, self.topMargin, rateSize.width, priceSize.height)];
        } else if(i != 0 && i < 4) {
            [priceAttString drawInRect:CGRectMake(priceX, self.topMargin + avgHeight *i - (priceSize.height/2.0), priceSize.width, priceSize.height)];
            [rateAttString drawInRect:CGRectMake(rateX, self.topMargin + avgHeight *i - (priceSize.height/2.0), rateSize.width, priceSize.height)];
            
        } else {
            [priceAttString drawInRect:CGRectMake(priceX, self.topMargin + avgHeight *i - (priceSize.height), priceSize.width, priceSize.height)];
            [rateAttString drawInRect:CGRectMake(rateX, self.topMargin + avgHeight *i - (priceSize.height), rateSize.width, priceSize.height)];
        }
        
    }
}

#pragma mark - 绘制X轴
- (void)drawTimeAxis {
    
    if (self.isTD == NO) {
        [self drawNormalTimxAxis];
    } else {
        [self drawTDTimeAxis];
    }
}

- (void)drawTDTimeAxis {
    
    if (!self.dates || self.dates.count == 0) {
        return;
    }
    
    if (self.timeTypeCount == 1) {
        
        CGFloat closeTime1Scale = 390.f/660.f;
        CGFloat closeTime2Scale = 540.f/660.f;
        
        CGFloat xAxis = self.leftMargin + self.pointPadding + (self.xAxisWidth * closeTime1Scale);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, self.separatorWidth);
        if (self.isSeparatorLash) {
            CGFloat lengths[] = {1,1};
            CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
        }
        
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, xAxis, self.topMargin + 5);    //开始画线
        CGContextAddLineToPoint(context, xAxis, self.topMargin + self.yAxisHeight - 1.25);
        CGContextStrokePath(context);
        
        
        // 绘制 20：00
        NSAttributedString *timeAtt = [[NSAttributedString alloc] initWithString:@"20:00" attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
        
        CGSize size = [timeAtt boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        [timeAtt drawInRect:CGRectMake(self.leftMargin + self.xAxisTitleMargin, self.topMargin + self.yAxisHeight + self.xAxisTitleMargin, size.width, size.height)];
        
        
        //绘制 2:30/9:00
        timeAtt = [[NSAttributedString alloc] initWithString:@"2:30/9:00" attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
        
        size = [timeAtt boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        [timeAtt drawInRect:CGRectMake(xAxis - size.width/2, self.topMargin + self.yAxisHeight + self.xAxisTitleMargin, size.width, size.height)];
        
        
        
        
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
        xAxis = self.leftMargin + self.pointPadding + (self.xAxisWidth * closeTime2Scale);
        CGContextMoveToPoint(context, xAxis, self.topMargin + 5);    //开始画线
        CGContextAddLineToPoint(context, xAxis, self.topMargin + self.yAxisHeight - 1.25);
        CGContextStrokePath(context);
        
        
        // 绘制 11:30/13:30
        timeAtt = [[NSAttributedString alloc] initWithString:@"11:30/13:30" attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
        size = [timeAtt boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        [timeAtt drawInRect:CGRectMake(xAxis - size.width/2, self.topMargin + self.yAxisHeight + self.xAxisTitleMargin, size.width, size.height)];
        
        // 绘制 15：30
        timeAtt = [[NSAttributedString alloc] initWithString:@"15:30" attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
        size = [timeAtt boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        [timeAtt drawInRect:CGRectMake(self.xAxisWidth - size.width, self.topMargin + self.yAxisHeight + self.xAxisTitleMargin, size.width, size.height)];
        CGContextSetLineDash(context, 0, 0, 0);
        
    } else {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        NSAttributedString *attString;
        CGFloat xAxis = self.leftMargin + self.landPointPadding;
        CGFloat quarteredWidth = self.xAxisWidth/self.dayTimeTitles.count;
        NSInteger avgDrawCount = (quarteredWidth/_pointPadding);
        
        
        CGContextSetLineWidth(context, self.separatorWidth);
        if (self.isSeparatorLash) {
            CGFloat lengths[] = {1,1};
            CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
        }
        
        

        
        for (NSInteger i = 0; i < self.dayTimeTitles.count; i++) {
            
            CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, xAxis, self.topMargin + 5);    //开始画线
            CGContextAddLineToPoint(context, xAxis, self.topMargin + self.yAxisHeight - 1.25);
            CGContextStrokePath(context);
            
            
            
         //   NSInteger index = [self.dayTimeTitles[i] integerValue];
            
         //   attString = [[NSAttributedString alloc] initWithString:[self dealTime:self.dates[index] TimeType:self.timeTypeCount] attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
            
            attString = [[NSAttributedString alloc] initWithString:self.dayTimeTitles[i] attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
            
            CGSize size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            CGFloat originX;
            
            originX = MIN(xAxis + quarteredWidth/2.0 - size.width/2.0, self.frame.size.width - self.rightMargin - size.width);
            
            [attString drawInRect:CGRectMake(originX, self.topMargin + self.yAxisHeight + self.xAxisTitleMargin, size.width, size.height)];
            
            xAxis += avgDrawCount*_pointPadding;

        }
        
        CGContextSetLineDash(context, 0, 0, 0);
        
    }
}


- (void)drawNormalTimxAxis {
    
    if (!self.dates || self.dates.count == 0) {
        return;
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger lineCount = self.timeTypeCount == 1 ? 4 : self.dayTimeTitles.count;
    CGFloat quarteredWidth = self.xAxisWidth/lineCount;
    NSInteger avgDrawCount = (quarteredWidth/_pointPadding);
    CGFloat xAxis = self.leftMargin + self.landPointPadding;
    
    
    for (int i = 0; i < lineCount ; i ++) {
        if (xAxis > self.leftMargin + self.xAxisWidth) {
            break;
        }
        CGContextSetLineWidth(context, self.separatorWidth);
        if (self.isSeparatorLash) {
            CGFloat lengths[] = {1,1};
            CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
        }
        
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, xAxis, self.topMargin + 5);    //开始画线
        CGContextAddLineToPoint(context, xAxis, self.topMargin + self.yAxisHeight - 1.25);
        CGContextStrokePath(context);
        
        //x轴坐标
        NSInteger timeIndex = i*avgDrawCount + self.startDrawIndex;
        
        if (timeIndex > self.dates.count - 1) {
            xAxis += avgDrawCount*_pointPadding;
            continue;
        }
        
        NSAttributedString *attString = nil;
        
        
        if (self.timeTypeCount == 1) {
            
            attString = [[NSAttributedString alloc] initWithString:[self dealTime:self.dates[timeIndex] TimeType:self.timeTypeCount] attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
        } else {
            // 绘制时间轴时间文字
            NSInteger index = [self.dayTimeTitles[i] integerValue];
            attString = [[NSAttributedString alloc] initWithString:[self dealTime:self.dates[index] TimeType:self.timeTypeCount] attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
        }
        
        CGSize size = [attString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGFloat originX;
        
        if (self.timeTypeCount == 1) {
            originX = (xAxis - size.width/2.0) < 0 ? self.leftMargin : (xAxis - size.width/2.0);
        } else {
            originX = MIN(xAxis + quarteredWidth/2.0 - size.width/2.0, self.frame.size.width - self.rightMargin - size.width);
        }
        
        [attString drawInRect:CGRectMake(originX, self.topMargin + self.yAxisHeight + self.xAxisTitleMargin, size.width, size.height)];
        xAxis += avgDrawCount*_pointPadding;
    }
    
    
    if (self.timeTypeCount == 1) {
        NSAttributedString *lastAttString = [[NSAttributedString alloc] initWithString:[self dealTime:[self.dates lastObject] TimeType:1] attributes:@{NSFontAttributeName:self.xAxisTitleFont, NSForegroundColorAttributeName:self.xAxisTitleColor}];
        CGSize size = [lastAttString boundingRectWithSize:CGSizeMake(MAXFLOAT, self.xAxisTitleFont.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGFloat lastOriginX = self.leftMargin + self.xAxisWidth - size.width;
        [lastAttString drawInRect:CGRectMake(lastOriginX, self.topMargin + self.yAxisHeight + self.xAxisTitleMargin, size.width, size.height)];
    }
    
    CGContextSetLineDash(context, 0, 0, 0);
}



- (NSString *)dealTime:(NSString *)time TimeType:(NSInteger)type {
    
    NSString *dealString;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    if (type == 1) {
        [formatter setDateFormat:@"HH:mm"];
        dealString = [formatter stringFromDate:date];
    } else {
        [formatter setDateFormat:@"MM-dd"];
        dealString = [formatter stringFromDate:date];
    }
    return dealString;
}


- (void)drawLineChart {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    UIBezierPath *bPath = [self getLineChartPath];
    CGContextAddPath(context, bPath.CGPath);
    CGContextStrokePath(context);
    
    
    
    
    
    CGPoint point = CGPointFromString([self.points lastObject]);
    
    [bPath addLineToPoint:CGPointMake(point.x, self.frame.size.height - self.bottomMargin)];
    [bPath addLineToPoint:CGPointMake(self.leftMargin + self.landPointPadding, self.frame.size.height - self.bottomMargin)];
    
    CGPathRef path = bPath.CGPath;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat lengths[] = {0.01,0.8};
    NSArray *colors = @[(__bridge id)self.gradientStartColor.CGColor, (__bridge id)self.gradientEndColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, lengths);
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextSetAlpha(context, 1.0);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


- (UIBezierPath *)getLineChartPath {
    
    
    UIBezierPath *path;
    CGFloat xAxis = self.leftMargin + self.landPointPadding;
    CGFloat yscale = (self.maxValue - self.minValue) / self.yAxisHeight;
    
    
    if (yscale != 0) {
        
        if (self.contexts) {
            _ActualCount = 0;
        
            for (id obj in self.contexts) {
                if (![obj isKindOfClass:[NSNull class]]) {
                    _ActualCount += 1;
                }
            }
        }
        
        NSArray *drawContexts = [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.ActualCount)];
        NSMutableArray *contentPoints = [NSMutableArray new];
        
        for (NSString *line in drawContexts) {
            
            CGFloat yAxis;
            CGFloat volValue = [line floatValue];
            
            yAxis = self.yAxisHeight - (volValue - self.minValue)/yscale + self.topMargin;
            CGPoint maPoint = CGPointMake(xAxis, yAxis);
            
            if (yAxis < self.topMargin) {
                xAxis += self.pointPadding;
                [contentPoints addObject:NSStringFromCGPoint(CGPointMake(xAxis, self.frame.size.height - self.bottomMargin))];
            }
            
            if (!path) {
                path = [UIBezierPath bezierPath];
                [path moveToPoint:maPoint];
            } else {
                [path addLineToPoint:maPoint];
            }
            
            [contentPoints addObject:NSStringFromCGPoint(CGPointMake(xAxis, yAxis))];
            xAxis += self.pointPadding;
            
        }
        
        self.points = contentPoints;
        
        if (self.timeTypeCount == 1) {
            [self startFlashAnimation];
        } else {
            [self.flashLayer removeFromSuperlayer];
            self.flashLayer = nil;
        }
        
    }
    
    
    
    if (self.smoothPath) {
        path = [path smoothedPathWithGranularity:15];
    }
    
    return path;
}

//- (UIBezierPath *)getLineChartPath {
//    
//    
//    UIBezierPath *path;
//    CGFloat xAxis = self.leftMargin + self.landPointPadding;
//    CGFloat yscale = (self.maxValue - self.minValue) / self.yAxisHeight;
//   
//
//    if (yscale != 0) {
//    
//    if (self.contexts) {
//        _ActualCount = 0;
//        for (NSString *current in self.contexts) {
//            if ([current floatValue] != 0) {
//                _ActualCount += 1;
//            }
//        }
//    }
//        
//    NSArray *drawContexts = [_contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.ActualCount)];
//    
//    NSMutableArray *contentPoints = [NSMutableArray new];
//        
//    for (NSString *line in drawContexts) {
//        
//        CGFloat yAxis;
//        CGFloat volValue = [line floatValue];
//
//        yAxis = self.yAxisHeight - (volValue - self.minValue)/yscale + self.topMargin;
//        CGPoint maPoint = CGPointMake(xAxis, yAxis);
//
//        if (yAxis < self.topMargin) {
//            xAxis += self.pointPadding;
//            [contentPoints addObject:NSStringFromCGPoint(CGPointMake(xAxis, self.frame.size.height - self.bottomMargin))];
//        }
//        
//        if (!path) {
//            path = [UIBezierPath bezierPath];
//            [path moveToPoint:maPoint];
//        } else {
//            [path addLineToPoint:maPoint];
//        }
//        
//        [contentPoints addObject:NSStringFromCGPoint(CGPointMake(xAxis, yAxis))];
//        xAxis += self.pointPadding;
//        
//    }
//        
//    self.points = contentPoints;
//    
//    if (self.timeTypeCount == 1) {
//          [self startFlashAnimation];
//    } else {
//        [self.flashLayer removeFromSuperlayer];
//        self.flashLayer = nil;
//    }
//  
//}
//    
//    
//  
//    if (self.smoothPath) {
//        path = [path smoothedPathWithGranularity:15];
//    }
//    
//    return path;
//}

- (void)startFlashAnimation {
    if (!self.flashPoint || self.timeTypeCount != 1) {
        return;
    }

    CGRect frame = self.flashLayer.frame;
    CGPoint lastPoint = CGPointFromString([self.points lastObject]);
    frame.origin.x = lastPoint.x - frame.size.width/2.0;
    frame.origin.y = lastPoint.y - frame.size.height/2.0;
    self.flashLayer.frame = frame;
    [self.layer addSublayer:self.flashLayer];
    
    //动画
    CAAnimationGroup *animaTionGroup = [CAAnimationGroup animation];
    animaTionGroup.duration = 0.8;
    animaTionGroup.removedOnCompletion = NO;
    animaTionGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animaTionGroup.autoreverses = YES;
    animaTionGroup.repeatCount = MAXFLOAT;
    
    // 缩放
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1.0;
    scaleAnimation.toValue = @0;
    
    // 放大
    CAKeyframeAnimation *opencityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opencityAnimation.values = @[@1,@0.1];
    opencityAnimation.keyTimes = @[@0, @(animaTionGroup.duration)];

    animaTionGroup.animations = @[scaleAnimation, opencityAnimation];
    [self.flashLayer addAnimation:animaTionGroup forKey:nil];
}

#pragma mark - event method
- (void)longPressedEvent:(UILongPressGestureRecognizer *)longGesture {
    
    if (self.contexts.count == 0 || !self.contexts) {
        return;
    }
    
    if (longGesture.state == UIGestureRecognizerStateEnded) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayDisappearCrossLine * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.ldCrossLine.hidden = YES;
            self.vtlCrossLine.hidden = YES;
            self.pointCrossLine.hidden = YES;
            self.valueLeftLb.hidden = YES;
            self.valueRightLb.hidden = YES;
            self.timeLb.hidden = YES;
            
            if ([self.delegate respondsToSelector:@selector(timeChartLongPressCancle:)]) {
                [self.delegate timeChartLongPressCancle:self];
            }
            
        });
        
        return;
    }
    
 
    CGPoint touchPoint = [longGesture locationInView:self];
  
    CGPoint lastPoint = CGPointFromString([self.points lastObject]);
    // 遍历
    [self.points enumerateObjectsUsingBlock:^(NSString* pointString, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint point = CGPointFromString(pointString);
        
        //整个
        if (touchPoint.x > (self.landPointPadding + self.leftMargin) && touchPoint.x < (self.frame.size.width - self.landPointPadding - self.rightMargin)  && touchPoint.y > self.topMargin && touchPoint.y < self.topMargin + _yAxisHeight) {
            
            // 下标
            CGFloat graphCount = (point.x - self.leftMargin - self.landPointPadding)/self.pointPadding;
            NSInteger index = floor(graphCount);
            
            if ((graphCount - index) > self.pointPadding/2.0) {
                index = ceil(graphCount);
            }
            
            //有
            if (touchPoint.x > (point.x - self.pointPadding/2.0) && touchPoint.x < (point.x + self.pointPadding/2.0)) {
                *stop = YES;

                [self showCroosLine:point touchPont:touchPoint index:index];
            }
            
            //没
            if (touchPoint.x > lastPoint.x + self.pointPadding/2.0 && touchPoint.x < (self.frame.size.width - self.landPointPadding - self.rightMargin)) {
                 *stop = YES;
                [self showCroosLine:lastPoint touchPont:touchPoint index:index];
            }

        }
    }];
}


- (void)showCroosLine:(CGPoint)point touchPont:(CGPoint)touchPoint index:(NSInteger)index {
    
    self.vtlCrossLine.hidden = NO;
    self.ldCrossLine.hidden = NO;
    self.pointCrossLine.hidden = NO;
    self.pointCrossLine.center = point;
    self.valueLeftLb.hidden = NO;
    self.valueRightLb.hidden = NO;
    
    
    
    // 垂直线
    CGRect frameVtl = self.vtlCrossLine.frame;
    frameVtl.origin.x = point.x;
    
    // 水平线
    CGRect frameLd = self.ldCrossLine.frame;
    frameLd.origin.y = point.y;

    if (self.isLdCrosslineAttachmentPoint == NO) {
        frameLd.origin.y = touchPoint.y;
    }
    
    self.vtlCrossLine.frame = frameVtl;
    self.ldCrossLine.frame = frameLd;


    

    NSString *date = [self dealTime:self.dates[index] TimeType:1];
    self.timeLb.text = date;
    self.timeLb.hidden = date.length > 0 ? NO : YES;
    if (date.length > 0) {
        CGSize size = [date boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.xAxisTitleFont} context:nil].size;
        CGFloat originX = MAX(self.leftMargin, point.x - size.width/2 - 2);
        self.timeLb.frame = CGRectMake(originX, self.topMargin + self.yAxisHeight + self.separatorWidth, size.width + 5 , size.height + 5);
    }
    
    
    
    
    // 左侧滑动value
    CGFloat leftLastValue = (self.yAxisHeight - touchPoint.y) / self.yAxisHeight * fabs(self.maxValue - self.minValue) + self.minValue;
    NSString *leftLastValueStr = [FTChartDealvalueTool dealDecimalWithNum:[NSNumber numberWithFloat:leftLastValue] DecimalPlaces:self.saveDecimalPlaces];
    // 右侧滑动value
    CGFloat rightPercentValue = (leftLastValue - self.lastCloseValue)/self.lastCloseValue * 100;
    NSString *rightPercentValueStr = [NSString stringWithFormat:@"%.2f%%", rightPercentValue];
    // 交叉点价格
    NSArray *line = [self.contexts subarrayWithRange:NSMakeRange(self.startDrawIndex, self.kGraphDrawCount)];
    NSString *PointLastStr = [FTChartDealvalueTool dealDecimalWithNum: @([line[index] floatValue]) DecimalPlaces:self.saveDecimalPlaces];
    // 交叉点百分比
    NSString *PointPercentStr = [NSString stringWithFormat:@"%.2f%%", (([PointLastStr floatValue] - self.lastCloseValue)/self.lastCloseValue) * 100];
    
    
    CGRect frameValuelb = self.valueLeftLb.frame;
    
    
    CGFloat ValuelbY = self.ldCrossLine.frame.origin.y - frameValuelb.size.height/2.0;
    

    if (self.isLdCrosslineAttachmentPoint == NO) {
        self.valueLeftLb.text = leftLastValueStr;
        self.valueRightLb.text = rightPercentValueStr;
    } else {
        self.valueLeftLb.text = PointLastStr;
        self.valueRightLb.text = PointPercentStr;
    }
    
    CGSize sizeLeft = [self.valueLeftLb.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.yAxisTitleFont} context:nil].size;
    CGSize sizeRight = [self.valueRightLb.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.yAxisTitleFont} context:nil].size;
    
    
    
    CGFloat valueLeftLbX = (self.isTipsDisplayOutSide) ? self.leftMarginX - FineMargin : self.leftMarginX;
    CGFloat valueRightLbX = (self.isTipsDisplayOutSide) ? self.rightMarginX + FineMargin : self.rightMarginX;
    
    
    //self.valueLeftLb.frame = CGRectMake(self.leftMarginX, ValuelbY, sizeLeft.width + FineMargin, sizeLeft.height + FineMargin);
    self.valueLeftLb.frame = CGRectMake(valueLeftLbX, ValuelbY, sizeLeft.width + FineMargin, sizeLeft.height + FineMargin);
    
    


    // 修改了
    //self.valueLeftLb.frame = CGRectMake(self.leftMarginX - (FineMargin), ValuelbY, sizeLeft.width + FineMargin, sizeLeft.height + FineMargin);
   // self.valueRightLb.frame = CGRectMake(self.rightMarginX, ValuelbY, sizeRight.width + FineMargin, sizeRight.height + FineMargin);
     self.valueRightLb.frame = CGRectMake(valueRightLbX, ValuelbY, sizeRight.width + FineMargin, sizeRight.height + FineMargin);
    
    
    
    if ([self.delegate respondsToSelector:@selector(timeChart:timeData:longPressInTime:price:changeValue:)]) {
        [self.delegate timeChart:self timeData:_timeData longPressInTime:date price:PointLastStr changeValue:PointPercentStr];
    }
    
    
    
    
}


#pragma mark - getters

//- (NSInteger)saveDecimalPlaces {
//    
//    if (_saveDecimalPlaces == 0) {
//        
//        float avgValue;
//        float maxfabsf = fabs(self.maxValue - self.lastCloseValue);
//        float minfabsf = fabs(self.minValue - self.lastCloseValue);
//        
//        avgValue = (maxfabsf > minfabsf) ? maxfabsf : minfabsf;
//        
//        if (avgValue < 0.01) {
//            _saveDecimalPlaces = 4;
//        } else if (avgValue < 0.1) {
//            _saveDecimalPlaces = 3;
//        } else if (avgValue < 1) {
//            _saveDecimalPlaces = 2;
//        } else {
//            _saveDecimalPlaces = 0;
//        }
//        return _saveDecimalPlaces;
//    }
//    
//    return _saveDecimalPlaces;
//}


- (CALayer *)flashLayer {
    if (!_flashLayer) {
        _flashLayer = [[CALayer alloc] init];
        _flashLayer.frame = CGRectMake(0, 0, MAX(MIN(4.0f, self.pointPadding), 10.0), MAX(MIN(4.0, self.pointPadding), 10.0));
        _flashLayer.cornerRadius = _flashLayer.frame.size.height/2.0;
        _flashLayer.backgroundColor = self.flashPointColor.CGColor;
    }
    return _flashLayer;
}

- (UILongPressGestureRecognizer *)longGesture {
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedEvent:)];
    }
    return _longGesture;
}

//- (UITapGestureRecognizer *)tapGesture {
//    if (!_tapGesture) {
//        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressedEvent:)];
//    }
//    return _tapGesture;
//}

- (UIView *)vtlCrossLine {
    if (!_vtlCrossLine) {
        _vtlCrossLine = [[UIView alloc] initWithFrame:CGRectMake(self.leftMargin + self.pointPadding, self.axisBoderWidth + self.topMargin, self.crossLineWidth, self.yAxisHeight - self.axisBoderWidth)];
        _vtlCrossLine.backgroundColor = self.crossLineColor;
        _vtlCrossLine.hidden = YES;
        [self addSubview:_vtlCrossLine];
    }
    return _vtlCrossLine;
}

- (UIView *)ldCrossLine {
    if (!_ldCrossLine) {
        _ldCrossLine = [[UIView alloc] initWithFrame:CGRectMake(self.leftMargin, 0, self.xAxisWidth, self.crossLineWidth)];
        _ldCrossLine.backgroundColor = self.crossLineColor;
        _ldCrossLine.hidden = YES;
        [self addSubview:_ldCrossLine];
    }
    return _ldCrossLine;
}


- (UIView *)pointCrossLine {
    if (!_pointCrossLine) {
        _pointCrossLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pointCrossLineWidth, self.pointCrossLineWidth)];
        _pointCrossLine.backgroundColor = self.pointCrossColor;
        _pointCrossLine.hidden = YES;
        _pointCrossLine.layer.cornerRadius = _pointCrossLine.frame.size.height/2.0;
        [self addSubview:_pointCrossLine];
    }
    return _pointCrossLine;
}


- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [[UILabel alloc] init];
        _timeLb.textAlignment = NSTextAlignmentCenter;
        _timeLb.font = self.xAxisTitleFont;
        _timeLb.textColor = self.xAxisTitleColor;
        _timeLb.layer.borderColor = self.tipBorderColor.CGColor;
        _timeLb.layer.borderWidth = self.tipBorderWidth;
           _timeLb.backgroundColor = self.tipBackGroundColor;
        [self addSubview:_timeLb];
    }
    return _timeLb;
}



//- (UILabel *)valueLb {
//    if (!_valueLb) {
//        _valueLb = [[UILabel alloc] init];
//        _valueLb.backgroundColor = self.tipBackGroundColor;
//        _valueLb.textAlignment = NSTextAlignmentCenter;
//        _valueLb.font = self.yAxisTitleFont;
//        _valueLb.textColor = self.yAxisTitleColor;
//        [self addSubview:_valueLb];
//    }
//    return _valueLb;
//}


- (UILabel *)valueLeftLb {
    if (!_valueLeftLb) {
        _valueLeftLb = [[UILabel alloc] init];
        _valueLeftLb.backgroundColor = self.tipBackGroundColor;
        _valueLeftLb.textAlignment = NSTextAlignmentCenter;
        _valueLeftLb.font = self.yAxisTitleFont;
        _valueLeftLb.textColor = self.yAxisTitleColor;
        [self addSubview:_valueLeftLb];
    }
    return _valueLeftLb;
}


- (UILabel *)valueRightLb {
    if (!_valueRightLb) {
        _valueRightLb = [[UILabel alloc] init];
        _valueRightLb.backgroundColor = self.tipBackGroundColor;
        _valueRightLb.textAlignment = NSTextAlignmentCenter;
        _valueRightLb.font = self.yAxisTitleFont;
        _valueRightLb.textColor = self.yAxisTitleColor;
        [self addSubview:_valueRightLb];
    }
    return _valueRightLb;
}


#pragma mark - setters
- (void)setKGraphDrawCount:(NSInteger)kGraphDrawCount {
    
    if (kGraphDrawCount > self.contexts.count || kGraphDrawCount < self.contexts.count) {
        kGraphDrawCount = self.contexts.count;
    }

    self.startDrawIndex = self.contexts.count > kGraphDrawCount ? self.contexts.count - kGraphDrawCount : 0;
    _kGraphDrawCount = kGraphDrawCount;

}



- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = (bottomMargin < self.timeAxisHeighth) ? self.timeAxisHeighth : bottomMargin;
}


//- (void)setIsTipsDisplayOutSide:(BOOL)isTipsDisplayOutSide {
//    _isTipsDisplayOutSide = isTipsDisplayOutSide;
//    
//    if (self.rightMargin == 0 || self.leftMargin == 0) {
//        self.rightMargin = self.maxValue
//    }
//    
//}



@end

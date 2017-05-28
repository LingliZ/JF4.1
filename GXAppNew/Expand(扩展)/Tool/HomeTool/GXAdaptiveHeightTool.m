//
//  GXAdaptiveHeightTool.m
//  GXApp
//
//  Created by GXJF on 16/7/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXAdaptiveHeightTool.h"

@implementation GXAdaptiveHeightTool
//创建类方法计算lable的高度
+ (CGFloat)lableHeightWithText:(NSString *)text font:(UIFont *)font Width:(CGFloat)width{
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width - width,CGFLOAT_MAX );
    NSDictionary *dic = @{NSFontAttributeName:font};
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [text boundingRectWithSize:size options:opts attributes: dic context:nil];
    return rect.size.height;
    
}

//根据字符串计算lable的宽度
+ (CGFloat)labelWidthFromString:(NSString *)str FontSize:(CGFloat)FontSize {
    CGRect bounds = [UIScreen mainScreen].bounds;
    // 字符串frame
    CGRect stringRect = [str boundingRectWithSize:bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FontSize]} context:nil];
    // 返回
    return stringRect.size.width;
}


//创建类方法根据image计算imageView的高度
+ (CGFloat)imageScaleHeightWith:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    return height / width *[[UIScreen mainScreen] bounds].size.width;
}

//提示框和自动消失时间方法
+(void)showMessage:(NSString *)message Time:(NSTimeInterval)time
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    //CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    CGRect LabelSize = [message boundingRectWithSize:CGSizeMake(GXScreenWidth, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    label.frame = CGRectMake(10, 5, LabelSize.size.width, LabelSize.size.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((GXScreenWidth - LabelSize.size.width - 20)/2, GXScreenHeight - 100, LabelSize.size.width+20, LabelSize.size.height+10);
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
//计算指定时间与当前的时间差  比如，3天前、10分钟前
/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */

+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}
//加载css文件
+ (NSString *)htmlWithContent:(NSString *)content title:(NSString *)title adddate:(NSString *)addate author:(NSString *)author source:(NSString *)source {
    NSMutableString *html = [NSMutableString string];
    NSString *htmlCSSpath = [[NSBundle mainBundle] pathForResource:@"NewsDetail.css" ofType:nil];
    NSString *htmlCSS = [NSString stringWithContentsOfFile:htmlCSSpath encoding:NSUTF8StringEncoding error:nil];
    [html appendString:htmlCSS];
    NSString *appendTitle = [NSString stringWithFormat:@"<h3 class=""titles"">%@</h3>", title];
    NSString *appenOther = [NSString stringWithFormat:@"<div class='time_line'><span> %@    </span><span>   作者 : %@    </span><span> 来源 : %@ </span></div>",addate,author,source];
    [html appendString:appendTitle];
    [html appendString:appenOther];
    if (content != nil) {
        [html appendString:content];
    }
    [html appendString:@"</html>"];
    return html;
}
//加载课程表html文件
+(NSString *)syllabusHtmlWithContent:(NSString *)content title:(NSString *)title{
    NSMutableString *html = [NSMutableString string];
    NSString *htmlCSSpath = [[NSBundle mainBundle] pathForResource:@"SyllabusDetail.css" ofType:nil];
    NSString *htmlCSS = [NSString stringWithContentsOfFile:htmlCSSpath encoding:NSUTF8StringEncoding error:nil];
    [html appendString:htmlCSS];
    NSString *appendTitle = [NSString stringWithFormat:@"<h3 class=""titles"">%@</h3>", title];
    [html appendString:appendTitle];
    if (content != nil) {
        [html appendString:content];
    }
    [html appendString:@"</html>"];
    return html;
}
//计算两个日期相差的天数,(忽略24小时之内)
+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return dayComponents.day;
}
//日期转换格式
+(NSString *)getDateStyle:(NSString *)dateStr{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *getDate = [format dateFromString:dateStr];
    NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
    [format1 setDateFormat:@"MM/dd HH:mm"];
    NSString *dateString = [format1 stringFromDate:getDate];
    return dateString;
}
////yyyy-MM-dd
////yyyy-MM-dd HH:mm:ss
////yyyy-MM-dd HH:mm:ss.SSS
////MM dd yyyy
+(NSDate *)dateFromStringWithDateStyle:(NSString *)dateStyle withDateString:(NSString *)dateStr{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:dateStyle];
    NSDate *date = [formater dateFromString:dateStr];
    return date;
}
//判断今天,昨天,明天
+(NSString *)compareTodayOrYestodayOrTomorrowDate:(NSDate *)date{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString * dateString = [[date description] substringToIndex:10];
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}
//日期转换成字符串格式
+(NSString *)getDateStyle:(NSString *)style withDate:(NSString *)dateStr{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *getDate = [format dateFromString:dateStr];
    NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
    [format1 setDateFormat:style];
    NSString *dateString = [format1 stringFromDate:getDate];
    return dateString;
}
//缩放图片大小
+(UIImage*) OriginImage:(UIImage*)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+(void)cleanWKWebViewCache{
    if ([[[UIDevice currentDevice] systemVersion] intValue ] > 8) {
        NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];  // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

@end

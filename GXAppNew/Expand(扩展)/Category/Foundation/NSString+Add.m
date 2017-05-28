//
//  NSString+Add.m
//  GXApp
//
//  Created by yangfutang on 16/6/29.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "NSString+Add.h"

@implementation NSString (Add)

- (CGSize)boundingWithSize:(CGSize)size FontSize:(CGFloat)fontsize {
    
    CGSize stringSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    return stringSize;
}

- (BOOL)validatePositiveNumber:(NSString *)String {
    
    if(![self isPureInt:String])
    {
        return NO;
    }
    return YES;
}



- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


-(BOOL)isChinese
{
    NSString*str=[self copy];
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}
-(NSString*)checkName
{
    if(self.length==0)
    {
        return @"请输入姓名";
    }
    if(![[self stringByReplacingOccurrencesOfString:@"·" withString:@""] isChinese])
    {
        return @"姓名中不得包含除汉字和·之外的其他字符";
    }
    if([[self stringByReplacingOccurrencesOfString:@"·" withString:@""] length]<2)
    {
        return @"姓名不得少于2个汉字";
    }
    if(self.length>15)
    {
        return @"姓名长度不得大于15位";
    }
    if([self hasPrefix:@"·"])
    {
        return @"姓名不得以“·”开头";
    }
    if([self hasSuffix:@"·"])
    {
        return @"姓名不得以“·”结尾";
    }
    int numbersOfDow=0;
    for(int i=0;i<self.length;i++)
    {
        NSString*subStr=[self substringWithRange:NSMakeRange(i, 1)];
        if([subStr isEqualToString:@"·"])
        {
            numbersOfDow++;
        }
    }
    if(numbersOfDow>1)
    {
        return @"姓名中最多只能够包含一个“·”";
    }
    return Check_Name_Qualified;
}
#pragma mark--校验身份证号码格式
/**
 *  校验身份证号码格式
 *
 *  @return 校验结果
 */
-(BOOL)isLegalID_CardNum
{
    if(self.length==15||self.length==18)
    {
        NSString *emailRegex = @"^[0-9]*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if(self.length==15)
        {
            if(!sfzNo)
            {
                return NO;
            }
        }
        else if (self.length==18)
        {
            BOOL sfz18NO=[self checkIdentityCardNo];
            if(!sfz18NO)
            {
                return NO;
            }
        }
    }
    else
    {
        return NO;
    }

    return YES;
}
- (BOOL)checkIdentityCardNo
{
    if (self.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[self substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[self substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[self substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

#pragma mark--校验密码格式
/**
 *  校验密码格式
 *
 *  @return 校验结果
 */
-(NSString*)checkPassword
{
    BOOL isContainSymbol=NO;
    BOOL isContainNum=NO;
    BOOL isContainLetter = NO;
    NSMutableString*psStr=[[NSMutableString alloc]init];
    
    if(self.length<6)
    {
        return @"密码长度不得小于6位";
    }
    for(int i=0;i<self.length;i++)
    {
        char character=[self characterAtIndex:i];
        if((character>=21&&character<=47)||(character>=58&&character<=64)||(character>=91&&character<=96)||(character>=123&&character<=126))
        {
            isContainSymbol=YES;
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
        if(character>=48&&character<=57)
        {
            isContainNum=YES;
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
        if((character>=65&&character<=90)||(character>=97&&character<=122))
        {
            isContainLetter=YES;
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
    }
    if(![psStr isEqualToString:self])
    {
        return @"密码中含有非法字符";
    }
    if(!((isContainLetter&&isContainNum)||(isContainLetter&&isContainSymbol)||(isContainNum&&isContainSymbol)))
    {
        return @"密码需要包含字母、数字、常用符号中的至少两种组合";
    }
    return Check_Password_Qualified;
}
-(BOOL)checkPay_password
{
    BOOL isConfirm=YES;
    for(int i=0;i<self.length;i++)
    {
        char character=[self characterAtIndex:i];
        if(!((character>=48&&character<=57)||(character>=65&&character<=90)||(character>=97&&character<=122)))
        {
            isConfirm=NO;
        }
    }
    return isConfirm;
}
#pragma mark--校验广贵交易密码格式
/**
 *校验广贵交易密码格式
 *
 *@return 校验结果
 */
-(NSString*)checkDeal_password_Guanggui
{
    BOOL isContainNumbers;//是否包含数字
    BOOL isContainLetters;//是否包含字母
    NSMutableString*psStr=[[NSMutableString alloc]init];
    if(self.length<8)
    {
        return @"密码长度不得小于8";
    }
    for(int i=0;i<self.length;i++)
    {
        char character=[self characterAtIndex:i];
        if(character>=48&&character<=57)
        {
            isContainNumbers=YES;
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
        if((character>=65&&character<=90)||(character>=97&&character<=122))
        {
            isContainLetters=YES;
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
    }
    if(!isContainLetters||!isContainNumbers)
    {
        return @"密码必须为字母和数字的组合";
    }
    if(![psStr isEqualToString:self])
    {
        return @"密码中不得包含除字母数字之外的其他符号";
    }
    return Check_DealPassword_Guanggui_Qualified;
}
-(NSString*)checkNickName
{
    if(self.length==0)
    {
        return @"昵称不可以为空";
    }
    if(self.length<2)
    {
        return @"昵称的长度不得小于2位";
    }
    if(self.length>16)
    {
        return @"昵称的长度不得大于16位";
    }
    BOOL isContainNum=NO;
    BOOL isContainLetter = NO;

    int numberOfNum=0;
    NSString*nickStr=[self copy];
    for(int i=0;i<self.length;i++)
    {
        char character=[self characterAtIndex:i];
        if(character>=48&&character<=57)
        {
            isContainNum=YES;
            numberOfNum++;
            nickStr=[nickStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c",character] withString:@""];
        }
        if((character>=65&&character<=90)||(character>=97&&character<=122))
        {
            isContainLetter=YES;
            nickStr=[nickStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c",character] withString:@""];
        }
    }
    if(numberOfNum>=5)
    {
        return @"昵称中数字的个数不得大于等于5";
    }
    if(![nickStr isChinese]&&nickStr.length)
    {
        return @"昵称只能由字母、数字、汉字组成";
    }
    if(!isContainLetter&&!nickStr.length)
    {
        return @"昵称不能只由数字组成";
    }
    return Check_NickName_Qualified;
}
-(NSString*)checkContactForFeedBack
{
    NSMutableString*psStr=[[NSMutableString alloc]init];
    
    for(int i=0;i<self.length;i++)
    {
        char character=[self characterAtIndex:i];
        if((character>=21&&character<=47)||(character>=58&&character<=64)||(character>=91&&character<=96)||(character>=123&&character<=126))
        {
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
        if(character>=48&&character<=57)
        {
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
        if((character>=65&&character<=90)||(character>=97&&character<=122))
        {
            [psStr appendString:[NSString stringWithFormat:@"%c",character]];
        }
    }
    if(![psStr isEqualToString:self])
    {
        return @"联系方式中含有非法字符，只能够包含字母，数字，常用字符";
    }
    
    return Check_ContactForFeedBack_Qualified;
}
+ (NSString *)StringFromquoteTime:(NSString *)quoteTime {
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[quoteTime longLongValue]];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd HH:mm:ss"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

#pragma mark--邮箱格式是否合法
/*
 *邮箱格式是否合法
 */
-(BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
//+ (NSString *)getKlineValue:(CGFloat )floatValue {
//    
//    
//    
//}


@end

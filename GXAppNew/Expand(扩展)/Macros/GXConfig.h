//
//  GXConfig.h
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#ifndef GXConfig_h
#define GXConfig_h


// ********************** UI ********************** //

//基于6适配其他尺寸
#define HeightScale_IOS6(height) ((height/667.0) * GXScreenHeight)
#define WidthScale_IOS6(width) ((width/375.0) * GXScreenWidth)

#define WidthLandScale_IOS6(width) ((width/375.0) * GXScreenHeight)
#define HeightLandScale_IOS6(height) ((height/667.0) * GXScreenWidth)

//是否是虚拟器
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif
// 手机型号
#define SCREEN_MAX_LENGTH (MAX(GXScreenWidth, GXScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(Screen_width, Screen_height))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_6_OR_LESS (IS_IPHONE_6 || IS_IPHONE_6P)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//屏幕宽高
#define GXScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define GXScreenWidth ([UIScreen mainScreen].bounds.size.width)


//间隔
#define GXMargin WidthScale_IOS6(10)

//图片间隔
#define imageMargin WidthScale_IOS6(5)

#define GXFitFontSize6 (IS_IPHONE_6 ? 6:(IS_IPHONE_6P ? 6:4))
#define GXFitFontSize7 (IS_IPHONE_6 ? 7:(IS_IPHONE_6P ? 7:5))
#define GXFitFontSize8 (IS_IPHONE_6 ? 8:(IS_IPHONE_6P ? 8:6))
#define GXFitFontSize9 (IS_IPHONE_6 ? 9:(IS_IPHONE_6P ? 9:7))
#define GXFitFontSize10 (IS_IPHONE_6 ? 10:(IS_IPHONE_6P ? 10:8))
#define GXFitFontSize11 (IS_IPHONE_6 ? 11:(IS_IPHONE_6P ? 11:9))
#define GXFitFontSize12 (IS_IPHONE_6 ? 12:(IS_IPHONE_6P ? 12:10))
#define GXFitFontSize13 (IS_IPHONE_6 ? 13:(IS_IPHONE_6P ? 13:11))
#define GXFitFontSize14 (IS_IPHONE_6 ? 14:(IS_IPHONE_6P ? 14:12))
#define GXFitFontSize15 (IS_IPHONE_6 ? 15:(IS_IPHONE_6P ? 15:13))
#define GXFitFontSize16 (IS_IPHONE_6 ? 16:(IS_IPHONE_6P ? 16:13))
#define GXFitFontSize17 (IS_IPHONE_6 ? 17:(IS_IPHONE_6P ? 17:15))
#define GXFitFontSize18 (IS_IPHONE_6 ? 18:(IS_IPHONE_6P ? 18:16))
#define GXFitFontSize19 (IS_IPHONE_6 ? 19:(IS_IPHONE_6P ? 19:17))
#define GXFitFontSize20 (IS_IPHONE_6 ? 20:(IS_IPHONE_6P ? 20:18))
#define GXFitFontSize21 (IS_IPHONE_6 ? 21:(IS_IPHONE_6P ? 21:19))
#define GXFitFontSize22 (IS_IPHONE_6 ? 22:(IS_IPHONE_6P ? 22:20))
#define GXFitFontSize23 (IS_IPHONE_6 ? 23:(IS_IPHONE_6P ? 23:21))
#define GXFitFontSize24 (IS_IPHONE_6 ? 24:(IS_IPHONE_6P ? 24:22))
#define GXFitFontSize25 (IS_IPHONE_6 ? 25:(IS_IPHONE_6P ? 25:23))
#define GXFitFontSize26 (IS_IPHONE_6 ? 26:(IS_IPHONE_6P ? 26:24))
#define GXFitFontSize30 (IS_IPHONE_6 ? 30:(IS_IPHONE_6P ? 30:28))

//字体SIZE
#define GXFontSize (IS_IPHONE_6 ? 15:(IS_IPHONE_6P ? 16:12))
#define GXFONT_PingFangSC_Light(s) (IS_OS_9_OR_LATER ? PingFangSC_Light(s):Helvetica_light(s))
#define GXFONT_PingFangSC_Regular(s) (IS_OS_9_OR_LATER ? PingFangSC_Regular(s):Helvetica_regular(s))
#define GXFONT_PingFangSC_Medium(s) (IS_OS_9_OR_LATER ? PingFangSC_Medium(s):Helvetica_medium(s))

//字体样式
//pangfang-light
#define PingFangSC_Light(s) [UIFont fontWithName:@"PingFangSC-Light" size:s]
#define Helvetica_light(s) [UIFont fontWithName:@"Helvetica-Light" size:s]
//ping-regular
#define PingFangSC_Regular(s) [UIFont fontWithName:@"PingFangSC-Regular" size:s]
#define Helvetica_regular(s) [UIFont fontWithName:@"Helvetica" size:s]
//ping-medium
#define PingFangSC_Medium(s) [UIFont fontWithName:@"PingFangSC-Medium" size:s]
#define Helvetica_medium(s) [UIFont fontWithName:@"Helvetica" size:s]

//字体颜色
// 淡灰线 #EEEEEE
#define GXLightLineColor [UIColor colorWithWhite:0.933 alpha:1.000]
// 灰色线 #CCCCCC
#define GXLineColor [UIColor colorWithWhite:0.894 alpha:1.000]
//白色背景颜色
#define GXPriceBackGroundColor [UIColor colorWithWhite:0.973 alpha:1.000]

//字体黑色 #4A4A4A
#define GXBlackColor [UIColor colorWithWhite:0.290 alpha:1.000]
//字体黑色 #000000
#define GXBlackTextColor [UIColor blackColor]

//字体橘黄色 #FF971C
#define GXOrangeColor [UIColor colorWithRed:1.000 green:0.549 blue:0.000 alpha:1.000]
//字体绿色 #55C554
#define GXGreenColor [UIColor colorWithRed:0.333 green:0.773 blue:0.329 alpha:1.000]
//字体红色 #F15B6F
#define GXRedColor [UIColor colorWithRed:0.945 green:0.357 blue:0.435 alpha:1.000]
// 白色
#define GXWhiteColor [UIColor whiteColor]
//白天夜间模式颜色宏
#define GXHomeBackGroundColor GXRGBColor(237,237,243)
#define GXHomeDKBlackColor GXRGBColor(45,47,59)
#define GXHomeDKWhiteColor [UIColor whiteColor]

//16进制颜色宏
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 颜色
#define GXColor(r,g,b,p) [UIColor colorWithRed:(r)/255 green:(g)/255 blue:(b)/255 alpha:(p)]
#define GXRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
// 主window
#define GXKeyWindow [UIApplication sharedApplication].keyWindow
// 当前window
#define CurrentWindow [[[UIApplication sharedApplication] windows] lastObject]
// 导航栏背景颜色
#define GXNavigationBarBackColor [UIColor colorWithRed:1.000 green:0.549 blue:0.000 alpha:1.000]
// 导航栏
#define GXNavigationBarTitleColor  [UIColor whiteColor]
// 主题颜色
#define ThemeBlack_Color GXRGBColor(38, 40, 52)

//4.1顾问平台
#define GXGrayColor GXRGBColor(161, 166, 187)
#define GXAdviserBGColor GXRGBColor(241, 242, 247)




// ****************** Other ****************** //

// 手机系统版本
#define iOS8ORLESS ([UIDevice currentDevice].systemVersion.floatValue <= 8.0)
#define iOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define iOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
/* 是否是ipad */
#define GXkIs_Pad  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO)

//利用十六进制颜色绘制图片
#define ImageFromHex(hex) [UIImage getImageWithHexColor:hex]
//RSA加密字符串
#define GXRsaEncryptor_string(str) [[GXRSAEncryptor sharedInstance]rsaEncryptString:str]
//当前App版本
#define GXAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 偏好设置
#define GXUserdefult [NSUserDefaults standardUserDefaults]
// 通知中心
#define GXNotificationCenter [NSNotificationCenter defaultCenter]
// 是否空对象
#define IS_NULL_CLASS(OBJECT) [OBJECT isKindOfClass:[NSNull class]]

//Library/Caches 文件路径
#define GXFilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])
//获取temp
#define GXPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define GXPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define GXPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

// UIimageWithName
#ifndef IMAGE_NAMED
#define IMAGE_NAMED(__imageName__)\
[UIImage imageNamed:__imageName__]
#endif

// GXLog打印
#ifdef DEBUG //调试模式
#define GXLog(...) NSLog(__VA_ARGS__)
#else //发布
#define GXLog(...)
#endif

// Dlog 
#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

//释放定时器
#define TT_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
__TIMER = nil;\
}

//冬冬
#define TitleFont GXFONT_PingFangSC_Regular(GXFitFontSize17)
#define SubTitleFont GXFONT_PingFangSC_Regular(GXFitFontSize12)

#endif /* GXConfig_h */

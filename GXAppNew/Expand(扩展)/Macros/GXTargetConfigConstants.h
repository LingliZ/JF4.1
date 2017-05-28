//
//  GXTargetConfigConstants.h
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#ifndef GXTargetConfigConstants_h
#define GXTargetConfigConstants_h


#ifdef DEBUG //调试模式


//测试环境
//#define baseUrl @"http://192.168.100.140:20100"
//#define baseImageUrl @"http://image.91test-cloud.bj"
//#define EaseMobCusterKey @"yangji"             //测试的客服key
//#define GXGrowingAppKey @"b4326f4bcc1eec58"    //GroingIO key
//#define JPushKey @"65ac052ad9030eeb46e4de16"
//#define EaseMobAppKey @"155-255#gxapp" //推送
//#define GXUrl_H5BaseUrl @"http://h5.91test-cloud.bj"
//#define JpushApsForProduction 0



//正式环境
#define baseUrl @"app.91guoxin.com"
#define baseImageUrl @"http://image.91guoxin.com/cloud"
#define EaseMobCusterKey @"u1423191635866"     //正式的客服key
#define GXGrowingAppKey @"b4326f4bcc1eec58"    //GroingIO key
#define JPushKey @"65ac052ad9030eeb46e4de16"
#define EaseMobAppKey @"91jin#91jinappv2" //推送Key
#define GXUrl_H5BaseUrl @"http://h5.91guoxin.com"
#define JpushApsForProduction 1



#else //发布


#define baseUrl @"app.91guoxin.com"
#define baseImageUrl @"http://image.91guoxin.com/cloud"
#define EaseMobCusterKey @"u1423191635866"     //正式的客服key
#define GXGrowingAppKey @"b4326f4bcc1eec58"    //GroingIO key
#define JPushKey @"65ac052ad9030eeb46e4de16"
#define EaseMobAppKey @"91jin#91jinappv2" //推送
#define GXUrl_H5BaseUrl @"http://h5.91guoxin.com"
#define JpushApsForProduction 1






#endif




// 终端
#define GXTerminal @"_IOS"
// 平台
#define GXPlatform @"_gx"
// 频道/位置
// 免注册登录
#define GXSiteLoc_UC @"_UC"
#define GXSiteLoc_Home @"_Home"
#define GXSiteLoc_VIP @"_VIP"
#define GXSiteLoc_Trades @"_Trades"
#define GXSiteLoc_Live @"_Live"
#define GXSiteLoc_OnlineCS @"_OnlineCS"
// 诉求
#define GXSource_Login @"_Login"
#define GXSource_Real @"_Real"
#define GXSource_Reg @"_Reg"
#define GXSource_Suggest @"_Suggest"
#define GXSource_Banner @"_banner"
#define GXSource_Exchange @"_Exchange"
#define GXSource_REAL @"_REAL"
//默认source字符串
#define GXDefaultSiteReg [NSString stringWithFormat:@"%@%@%@%@%@",GXSiteChannel,GXTerminal,GXPlatform,GXSiteLoc_UC,GXSource_Reg]
#define GXDefaultSiteLogin [NSString stringWithFormat:@"%@%@%@%@%@",GXSiteChannel,GXTerminal,GXPlatform,GXSiteLoc_UC,GXSource_Login]
//首页开户
#define GXSiteHomeReal [NSString stringWithFormat:@"%@%@%@%@%@",GXSiteChannel,GXTerminal,GXPlatform,GXSiteLoc_Home,GXSource_Real]
//顾问平台登录
#define GXSiteVIPLogin [NSString stringWithFormat:@"%@%@%@%@%@",GXSiteChannel,GXTerminal,GXPlatform,GXSiteLoc_VIP,GXSource_Login]
//交易开户
#define GXSiteTradeReal [NSString stringWithFormat:@"%@%@%@%@%@",GXSiteChannel,GXTerminal,GXPlatform,GXSiteLoc_Trades,GXSource_Real]
//视频直播即时建议登录
#define GXSiteLiveSuggest [NSString stringWithFormat:@"%@%@%@%@%@",GXSiteChannel,GXTerminal,GXPlatform,GXSiteLoc_Live,GXSource_Suggest]
//首页banner
#define GXSiteHomeBanner [NSString stringWithFormat:@"%@%@%@%@%@",GXSiteChannel,GXTerminal,GXPlatform,GXSiteLoc_Home,GXSource_Banner]
//我的_交易所信息
#define GXDefaultSiteExchange [NSString stringWithFormat:@"%@%@%@%@%@",GXSiteChannel,GXTerminal,GXPlatform,GXSiteLoc_UC,GXSource_Exchange]
//在线客服_开户
#define GXOnlineCSSite [NSString stringWithFormat:@"%@%@%@%@%@",GXSiteChannel,GXTerminal,GXPlatform,GXSiteLoc_OnlineCS,GXSource_REAL]



//判断是否是原来的target
#ifdef GXAppNew

#define about_headImage @"logo_commpany"
#define versionInformation @"4.1.3"
#define GXSiteChannel @"0"
#define GXGrowingAppKey @"b4326f4bcc1eec58"
#define GXUMSocialDataAppKey @"5776072967e58e9709003422"
#define isOnlyLoginBtn NO

#endif

//判断是否是鑫掌柜XZG的target
#ifdef GXXZG

#define about_headImage @"about_headImage"
#define versionInformation @"1.2.0"
#define GXSiteChannel @"XZG"
#define GXGrowingAppKey @"b4326f4bcc1eec58"
#define GXUMSocialDataAppKey @"58a688eb9f06fd7b42001216"
#define isOnlyLoginBtn YES

#endif

//判断是否是国鑫金服Vip的target
#ifdef GXAppVip

#define about_headImage @"about_headImage"
#define versionInformation @"1.3.1"
#define GXSiteChannel @"VIP"
#define GXGrowingAppKey @"b4326f4bcc1eec58"
#define GXUMSocialDataAppKey @"5838165ebbea836e250007eb"
#define isOnlyLoginBtn YES

#endif


//判断是否是贵金属通的target
#ifdef GXGJS

#define about_headImage @"about_headImage-1"
#define versionInformation @"1.2.0"
#define GXSiteChannel @"GJS"
#define GXGrowingAppKey @"b4326f4bcc1eec58"
#define GXUMSocialDataAppKey @"5838142de88bad5d1b00070c"
#define isOnlyLoginBtn YES

#endif


//判断是否是国鑫现货宝的target
#ifdef GXXHB

#define about_headImage @"about_headImage-2"
#define versionInformation @"1.1.0"
#define GXSiteChannel @"XHB"
#define GXGrowingAppKey @"b4326f4bcc1eec58"
#define GXUMSocialDataAppKey @"5838162ff5ade412c9000c32"
#define isOnlyLoginBtn YES
#endif
/*
 *专业版
 */
#ifdef GXZYB

#define about_headImage @"about_headImage-2"
#define versionInformation @"1.0.0"
#define GXSiteChannel @"ZYB"
#define GXGrowingAppKey @"b4326f4bcc1eec58"
#define GXUMSocialDataAppKey @"58c793dbc8957655ec0007d3"
#define isOnlyLoginBtn YES




#endif























#endif /* GXTargetConfigConstants_h */

//
//  GXPriceConst.h
//  GXApp
//
//  Created by futang yang on 16/7/27.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#ifndef GXPriceConst_h
#define GXPriceConst_h

#import "UIColor+Ext.h"



// 报价提醒开关通知
#define GXPriceRemindTurnOffNotificationName @"GXPriceRemindTurnOffNotificationName"
#define GXAppDelegateRemindNotificationName @"GXAppDelegateRemindNotificationName"
#define GXPopularSelectControllerHotModlesfilePath @"GXPopularSelectControllerHotModles"


#define PriceVertical_HeaderViewColor GXRGBColor(38, 40, 52)
#define PriceVertical_HeaderLineColor GXRGBColor(19, 19, 24)
#define PriceVertical_CanlendarHearViewColor GXRGBColor(38, 40, 52)
#define PriceVertical_SuggestionTipViewColor GXRGBColor(38, 40, 52)
#define PriceVertical_PriceTabbarBackgroundColor GXRGBColor(24, 24, 31)
#define PriceVertiacl_CalandarCellColor GXRGBColor(24, 24, 31)



//***********************New
#define kStatusBarHeight        (20.f)
#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)
#define kCellDefaultHeight      (44.f)
#define kTopAllHeight           (64.f)


// 长按高亮视图背景颜色
#define TopHighligthViewColor [UIColor colorWithHexString:@"18181F"]

// 文字
#define PriceRedColor [UIColor colorWithHexString:@"D83E21"]
#define PriceGreenColor  [UIColor colorWithHexString:@"059C39"]
#define PriceFontColor [UIColor colorWithHexString:@"E7E7E7"]
#define PriceLightGray [UIColor colorWithHexString:@"656A89"]

//K线
#define PositiveColor [UIColor colorWithHexString:@"D83E21"]
#define NegativeColor  [UIColor colorWithHexString:@"059C39"]

//十字线颜色
#define CroosLineColor [UIColor colorWithHexString:@"C3C4C6"]

//MA颜色
#define MA1Color [UIColor colorWithHexString:@"F5A623"]
#define MA2Color [UIColor colorWithHexString:@"4082F4"]
#define MA3Color [UIColor colorWithHexString:@"C7238B"]

//BOLL颜色
#define MIDColor [UIColor colorWithHexString:@"F5A623"]
#define UPPERColor [UIColor colorWithHexString:@"4082F4"]
#define LOWERColor [UIColor colorWithHexString:@"C7238B"]

// MACD颜色
#define DIFColor [UIColor colorWithHexString:@"F5A623"]
#define DEAColor [UIColor colorWithHexString:@"4082F4"]
#define MACDColor [UIColor colorWithHexString:@"FFFFFF"]


//KDJ颜色
#define KColor [UIColor colorWithHexString:@"F5A623"]
#define DColor [UIColor colorWithHexString:@"4082F4"]
#define JColor [UIColor colorWithHexString:@"C7238B"]

//RSI颜色
#define RSI1Color [UIColor colorWithHexString:@"F5A623"]
#define RSI2Color [UIColor colorWithHexString:@"4082F4"]
#define RSI3Color [UIColor colorWithHexString:@"C7238B"]

//ADX颜色
#define ADXColor [UIColor colorWithHexString:@"F5A623"]

//ATR颜色
#define ATRColor [UIColor colorWithHexString:@"F5A623"]


//k线最大值 最小值
#define maxHighBorderColor [UIColor colorWithHexString:@"585862"]
#define minLowBorderColor [UIColor colorWithHexString:@"585862"]

#define maxHighBgColor [UIColor colorWithHexString:@"34384B"]
#define minLowBgColor [UIColor colorWithHexString:@"34384B"]

// Detail
#define CalendarHeaderHeight 30
#define priceTabbarHeight       (44.f)

// 上部分指标枚举
typedef NS_ENUM(NSInteger, KLineChartTopType){
    MA,
    BOLL,
};


// 下部分指标枚举
typedef NS_ENUM(NSInteger, KLineChartBottomType){
    MACD,
    KDJ,
    RSI,
    ADX,
    ATR,
};




//通知名称
#define PriceReDrawPriceKlineChartNotificaitonName @"PriceReDrawPriceKlineChartNotificaitonName"
#define PriceReDrawPriceIndexChartNotificaitonName @"PriceReDrawPriceIndexChartNotificaitonName"
#define PriceReLoadChartNotificaitonName @"PriceReLoadChartNotificaitonName"

























/**********************List***********************/
#define priceList_height_tableviewTitle 40//标题视图高
#define priceList_height_tableviewCell 50//cell高


#define priceList_color_tableViewTitleText [UIColor whiteColor]//标题文字颜色
#define priceList_color_tableViewTitleBackg [UIColor colorWithRed:38.0f/255.0f green:40.0f/255.0f blue:52.0f/255.0f alpha:1.0f]//标题背景颜色


#define priceList_color_tableViewBackg [UIColor colorWithRed:45.0f/255.0f green:47.0f/255.0f blue:59.0f/255.0f alpha:1.0f]//tableview背景色
#define priceList_color_tableViewCellBackg [UIColor colorWithRed:46.0f/255.0f green:45.0f/255.0f blue:61.0f/255.0f alpha:1.0f]//cell背景色


#define priceList_color_tableViewCellNameText [UIColor whiteColor]//品种名字颜色
#define priceList_color_tableViewCellNameTextLittle [UIColor colorWithRed:120.0f/255.0f green:126.0f/255.0f blue:156.0f/255.0f alpha:1.0f]//品种名字下面的小字颜色


#define priceList_color_tableViewCellPriceTextRed [UIColor colorWithRed:216.0f/255.0f green:62.0f/255.0f blue:33.0f/255.0f alpha:1.0f]//涨时的颜色
#define priceList_color_tableViewCellPriceTextGreen [UIColor colorWithRed:5.0f/255.0f green:156.0f/255.0f blue:57.0f/255.0f alpha:1.0f]//跌时的颜色
#define priceList_color_tableViewCellPriceTextEqual [UIColor whiteColor]//不涨不跌颜色


#define priceList_color_tableViewCellLastBackgRed [UIColor colorWithRed:202.0f/255.0f green:60.0f/255.0f blue:35.0f/255.0f alpha:0.19f]//最新价闪动背景颜色，涨时候
#define priceList_color_tableViewCellLastBackgGreen [UIColor colorWithRed:5.0f/255.0f green:156.0f/255.0f blue:57.0f/255.0f alpha:0.19f]//最新价闪动背景颜色，跌时候


#define priceList_color_tableViewFootViewText [UIColor colorWithRed:120.0f/255.0f green:126.0f/255.0f blue:156.0f/255.0f alpha:1.0f]//列表下面文字颜色


#define priceList_color_SelectExchangeViewBackg [UIColor colorWithRed:46.0f/255.0f green:45.0f/255.0f blue:61.0f/255.0f alpha:1.0f]//交易所选择视图背景色
#define priceList_color_SelectExchangeViewText [UIColor whiteColor]//交易所选择视图文字颜色
#define priceList_color_SelectExchangeViewBackgLine [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:54.0f/255.0f alpha:1.0f]//交易所选择视图线的颜色


#define priceList_color_addCodeImgTipsText [UIColor colorWithRed:120.0f/255.0f green:126.0f/255.0f blue:156.0f/255.0f alpha:1.0f]//自选为空时出现的“添加自选”文字颜色


#define priceList_color_NavTitleText [UIColor whiteColor]//导航栏上标题按钮颜色


#define priceList_imgname_NavTitleImg @"priceListNavBtn"//导航栏上标题按钮的图片
#define priceList_imgname_NavBarButtonImg_addCode @"addcodeimg"//导航栏上添加自选的图片
#define priceList_imgname_NavBarButtonImg_addCode_blue @"addcodeimg_blue"//导航栏上添加自选的图片




#define priceList_color_cellBackg [UIColor colorWithRed:37.0f/255.0f green:36.0f/255.0f blue:51.0f/255.0f alpha:1.0f]//行情列表cell选中背景色


/*****************************************添加自选*******************/


#define priceAddCodeList_color_CellLineBackg [UIColor colorWithRed:42.0f/255.0f green:41.0f/255.0f blue:57.0f/255.0f alpha:1.0f]//添加自选列表都合上时候 cell线的颜色
#define priceAddCodeList_color_cellTitleText [UIColor whiteColor]//添加自选列表标题颜色
#define priceAddCodeList_color_cellTitleTextSelect [UIColor colorWithRed:69.0f/255.0f green:128.0f/255.0f blue:243.0f/255.0f alpha:1.0f]//添加自选列表选中标题颜色
#define priceAddCodeList_color_cellTitleBackg [UIColor colorWithRed:55.0f/255.0f green:54.0f/255.0f blue:72.0f/255.0f alpha:1.0f]//添加自选列表标题背景颜色
#define priceAddCodeList_imgname_cellTitleRightBtn @"priceListNavBtn"//添加自选列表标题视图右边三角图片btn


#define priceAddCodeList_color_cellPriceText [UIColor whiteColor]//添加自选列表产品名字颜色
#define priceAddCodeList_color_cellPriceBackg [UIColor colorWithRed:46.0f/255.0f green:45.0f/255.0f blue:61.0f/255.0f alpha:1.0f]//添加自选列表cell背景颜色
#define priceAddCodeList_imgname_cellPriceRightBtn @"addcodeimgInCell"//添加自选列表cell右边添加图片btn
#define priceAddCodeList_color_cellPriceRightBtnText [UIColor colorWithRed:120.0f/255.0f green:126.0f/255.0f blue:156.0f/255.0f alpha:1.0f]//添加自选列表cell右边添加btn的文字颜色

/**************************编辑自选*******************/

#define priceEditList_color_cellTitleText [UIColor whiteColor]//列表标题颜色
#define priceEditList_color_cellTitleBackg [UIColor colorWithRed:46.0f/255.0f green:45.0f/255.0f blue:61.0f/255.0f alpha:1.0f]//列表标题背景颜色


#define priceEditList_color_cellText [UIColor whiteColor]//列表产品名字颜色
#define priceEditList_color_cellTextLittle [UIColor colorWithRed:120.0f/255.0f green:126.0f/255.0f blue:156.0f/255.0f alpha:1.0f]//品种名字下面的小字颜色
#define priceEditList_color_cellBackg [UIColor colorWithRed:46.0f/255.0f green:45.0f/255.0f blue:61.0f/255.0f alpha:1.0f]//列表背景颜色
#define priceEditList_color_cellSelectBackg [UIColor colorWithRed:37.0f/255.0f green:36.0f/255.0f blue:51.0f/255.0f alpha:1.0f]//列表选中的背景色

#define priceEditList_imgname_cellSelectBtn @"xuanzhong"//列表cell选中图片btn
#define priceEditList_imgname_cellUnSelectBtn @"weixuanzhong"//列表cell未选中图片btn
#define priceEditList_imgname_cellTopBtn @"zhiding"//列表cell置顶图片btn



#define priceEditList_color_BoomButtonTitle [UIColor whiteColor]//列表底部文字颜色
#define priceEditList_color_BoomButtonALLSelectBackg [UIColor colorWithRed:38.0f/255.0f green:40.0f/255.0f blue:52.0f/255.0f alpha:1.0f]//列表底部全部button背景
#define priceEditList_color_BoomButtonDeleBackg [UIColor colorWithRed:55.0f/255.0f green:54.0f/255.0f blue:72.0f/255.0f alpha:1.0f]//列表底部删除button背景




/*********************************************/

#endif /* GXPriceConst_h */

//
//  GXImgMsgParameter.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#ifndef GXImgMsgParameter_h
#define GXImgMsgParameter_h

//是否需要打印调试(Print log or not)
#define isDebug NO
//是否一次性加载全部页面或控制器(Load whole viewcontrollers or views)
#define LoadWholePage NO
//全屏宽和高大小(Full screen width and height)
#define FUll_VIEW_WIDTH     ([[UIScreen mainScreen] bounds].size.width)
#define FUll_VIEW_HEIGHT    ([[UIScreen mainScreen] bounds].size.height)
#define FUll_CONTENT_HEIGHT     FUll_VIEW_HEIGHT - 64 - 49  //如果您想创建的界面不需要减去Tabbar的高度，您可以将此参数的-49去掉即可(If you don't want to subtract Tabbar' height,you can clear away '-49')
//十六进制颜色值(hex ColorRGB)
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define PageBtn     40 //6s下高度40(您如果想改变上方TopTab的高度，请设置此值)(Height 40 in iphone 6s,if you wanna change TopTab's height,please set this parameter)
#define SliderHeight    PageBtn //默认滑块的高度(您如果想让高度与TopTab一致，请设置此参数为PageBtn)(Default height of sliderblock)
#define SliderY     (PageBtn - SliderHeight) / 2.0 //默认滑块的Y值(Default y of sliderblock)
#define TabbarHeight    49
#define More5LineWidth      FUll_VIEW_WIDTH / 5.0 //超过5个标题的宽度(Width of more than five titles)
#define SelectBottomLinePer     1 //您可以对此参数进行设置来改变下划线的长度，此参数代表的是选中的整体部分的占比，默认为1，您可以对此进行设置，但推荐您尽量不要设置在0.5以下(此参数设置在两种样式中均可使用)(You can set this parameter to change the length of bottomline,the percent of selected button,default is 1.Recommand to set above 0.5)
#define SelectBottomLineHeight      2 //您可以对此参数进行设置来改变下划线的高度，默认为2，若超过3，则默认为3(You can set this to change bottomline's height,default is 2,max height is 3)
#define SlideBlockCornerRadius      2.0 //滑块的layer.cornerRadius属性，默认的计算公式是(滑块宽度 / SlideBlockCornerRadius)，若您想要自定义调整，请修改此参数，如果不想要圆角，请设置此参数为0。(Sliderblock's layer.cornerRadius,if you don't want cornerRadius,please set this to 0)
#define NinaDefaultPageIndex    2


#endif /* GXImgMsgParameter_h */

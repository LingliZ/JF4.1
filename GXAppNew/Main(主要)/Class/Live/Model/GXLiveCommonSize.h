//
//  GXLiveCommonSize.h
//  GXAppNew
//
//  Created by zhudong on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#define KeyBoardHeight 44
#define BackgroundColor GXRGBColor(59, 62, 76)
#define KeyBoardInputViewHeight 216
#define TopBarHeight 40

#define TopViewHeight 54
#define BtnW 80
#define BtnH WidthScale_IOS6(34)
#define EmojiBtnW WidthScale_IOS6(50)
#define BtnWidth WidthScale_IOS6(75)
#define EmojiBtnNotifyName @"GXEmotionBtnDidClicked"
#define CloseTimerNotify @"CloseTimerNotify"
#define OpenTimerNotify @"OpenTimerNotify"
#define TextViewBeginNotify @"TextViewBeginNotify"
#define TextViewEndNotify @"TextViewEndNotify"
#define CurrentPageNotify @"CurrentPageNotify"
    
//其他子界面
#define PictureWidth (GXScreenWidth - WidthScale_IOS6(58) - WidthScale_IOS6(30) - 2 * imageMargin) / 3.0
#define AdviserBGColor [UIColor lightGrayColor]

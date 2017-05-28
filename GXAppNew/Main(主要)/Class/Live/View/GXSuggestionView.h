//
//  GXSuggestionView.h
//  GXAppNew
//
//  Created by zhudong on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LoginNotify @"LoginNotify"
#define GXVedioDetailBtnClickNotify @"GXVedioDetailBtnClickNotify"

@interface GXSuggestionView : UIView
@property (nonatomic,copy) void (^suggestionDelegate)(GXSuggestionView *view);
@end

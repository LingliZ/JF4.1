//
//  PriceNoSuggesView.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/8.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceSuggestionModel;
@class PriceTipSuggestionModel;
@class PriceNoSuggesView;
@class PriceMarketModel;



typedef NS_ENUM(NSInteger, SuggetionViewStatus){
    NeedToLogin,
    NeedOpenAcount,
    NeedBindRoom,
};



@protocol PriceNoSuggesViewDelegate <NSObject>

@optional;
- (void)PriceSuggestionViewBeginShow:(PriceNoSuggesView *)suggestionView;
- (void)PriceSuggestionViewDidHide:(PriceNoSuggesView *)suggestionView;
- (void)PriceSuggestionViewSkipController:(PriceNoSuggesView *)suggestionView;


@end


@interface PriceNoSuggesView : UIView



@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isDisplaySuggestion;
@property (nonatomic, strong) UIButton *stateButton;
@property (nonatomic, assign) SuggetionViewStatus buttonSatus;
@property (nonatomic, strong) UIView *contentView;



@property (nonatomic, assign) id<PriceNoSuggesViewDelegate>delegate;


- (void)setTipSuggestion:(PriceTipSuggestionModel *)tipModel;
- (void)setSuggesionViewButtonStatus:(SuggetionViewStatus)buttonSatus title:(NSString *)title;
- (void)showCodeSuggestionsListView:(PriceTipSuggestionModel *)tipModel markertMode:(PriceMarketModel *)marketModel;
- (void)setSelectExViewShow;



@end

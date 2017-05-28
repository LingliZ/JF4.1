//
//  GXBanAnaRemImpDetailController.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/14.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXHomeAdvertistsModel.h"
#import "GXHomeAnalystModel.h"
#import "GXHomeRemindRoomModel.h"
#import "GXHomeCountDownModel.h"
#import "GXHomeTextModel.h"
#import "GXHomeAudioModel.h"
#import "GXHomeVedioModel.h"
#import "GXAirAdModel.h"
#import "GXArticleDetailModel.h"
#import "GXHomeUrlBaseController.h"


@interface GXBanAnaRemImpDetailController : GXHomeUrlBaseController

//bannerModel
@property (nonatomic,strong)GXHomeAdvertistsModel *bannerModel;
//发现banner
@property (nonatomic,strong)GXHomeAdvertistsModel *disBannerModel;
//分析师
@property (nonatomic,strong)GXHomeAnalystModel *analystModel;

//推荐播间
@property (nonatomic,strong)GXHomeRemindRoomModel *remindModel;

//倒计时
@property (nonatomic,strong)GXHomeCountDownModel *countDownModel;
//文章Model
@property (nonatomic,strong)GXArticleDetailModel *model;


//推送浮窗广告model
@property (nonatomic,strong)GXAirAdModel *airModel;

@property (nonatomic,strong)NSString *webUrl;

@property (nonatomic,assign)BOOL isTheWebUrl;
//分享的标题,图片,链接
@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *shareImage;
@property (nonatomic,strong)NSString *shareUrl;
@property (nonatomic,strong)NSString *shareDesc;

@end

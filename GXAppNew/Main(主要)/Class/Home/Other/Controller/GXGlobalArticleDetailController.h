//
//  GXGlobalArticleDetailController.h
//  GXApp
//
//  Created by GXJF on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "GXInformationModel.h"
#import "GXHomeTextModel.h"
#import "GXHomeAudioModel.h"
#import "GXHomeVedioModel.h"
#import "GXHomeUrlBaseController.h"

@interface GXGlobalArticleDetailController : GXHomeUrlBaseController

@property (nonatomic,strong)WKWebView *wkWebView;

@property (nonatomic,strong)GXInformationModel *informationModel;

@property (nonatomic,strong)GXHomeTextModel *textModel;
@property (nonatomic,strong)GXHomeAudioModel *audioModel;
@property (nonatomic,strong)GXHomeVedioModel *vedioModel;

@end

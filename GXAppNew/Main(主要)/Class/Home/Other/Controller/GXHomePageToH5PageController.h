//
//  GXHomePageToH5PageController.h
//  GXAppNew
//
//  Created by 王振 on 2017/2/14.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXHomeUrlBaseController.h"

@interface GXHomePageToH5PageController : GXHomeUrlBaseController
@property (nonatomic,strong)NSString *secondTitle;
@property (nonatomic,strong)NSString *webUrl;

//分享的标题,图片,链接
@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *shareImage;
@property (nonatomic,strong)NSString *shareUrl;
@property (nonatomic,strong)NSString *shareDesc;

@end

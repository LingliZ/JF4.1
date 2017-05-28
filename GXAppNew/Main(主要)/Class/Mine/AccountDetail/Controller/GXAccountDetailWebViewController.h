//
//  GXGlobalArticleDetailController.h
//  GXApp
//
//  Created by GXJF on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GXInformationModel.h"
@interface GXAccountDetailWebViewController : UIViewController
////文章ID
//@property (nonatomic,strong)NSString *kindsOfIdentifier;
////分享图片url
//@property (nonatomic,strong)NSString *shareImgUrl;

@property (nonatomic,strong)UIWebView *detailWebView;


@property (nonatomic,strong)GXInformationModel *informationModel;
@property (nonatomic,strong)NSString *articleID;
@end

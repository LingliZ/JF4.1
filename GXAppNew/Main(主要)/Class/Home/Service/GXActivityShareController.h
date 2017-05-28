//
//  GXActivityShareController.h
//  GXApp
//
//  Created by 王振 on 2016/11/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXActivityShareController : UIViewController

//跳转的连接url
@property (nonatomic,strong)NSString *shareLinkUrl;

//分享的图片url
@property (nonatomic,strong)NSString *shareImgUrl;

//分享标题name
@property (nonatomic,strong)NSString *shareTitle;

//分享描述
@property (nonatomic,strong)NSString *shareDesc;

//跳转方法
-(void)shareActiviyLinkUrl:(NSString *)shareLinkUrl shareImage:(NSString *)shareImgUrl shareTitleName:(NSString *)shareTitle shareDiscribContent:(NSString *)simpleContentDesc;


@end

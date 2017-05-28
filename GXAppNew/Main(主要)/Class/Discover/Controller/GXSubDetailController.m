//
//  GXSubDetailController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSubDetailController.h"
#import "GXActionSheetView.h"
//#import "UMSocial.h"


@interface GXSubDetailController ()

@end

@implementation GXSubDetailController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"资讯详情";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share_pic"] style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)shareClick{
    if ([GXUserInfoTool isConnectToNetwork]) {
        NSArray *titlearr = @[@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间"];
        NSArray *imageArr = @[@"wechat_friends",@"circle_of_friends",@"qq_friends",@"qq_space_pic"];
        
        GXActionSheetView *actionsheet = [[GXActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsOneLineScrollowStyle];
        [actionsheet setBtnClick:^(NSInteger btnTag) {
            switch (btnTag) {
                case 0:
                {
                    //微信
                    //分享标题
                    //[UMSocialData defaultData].extConfig.wechatSessionData.title = self.titleStr;
                    //跳转链接
                    //[UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareDetailUrl;
                    //分享url图片
                    //                UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.shareImgUrl];
//                    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.describtionStr image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImgUrl]]] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
//                        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//                            NSLog(@"分享成功！");
//                            
//                        }
//                    }];
                }
                    break;
                case 1:
                {
                    //微信朋友圈
                    //标题
//                    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.titleStr;
//                    //预设跳转链接
//                    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareDetailUrl;
//                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.describtionStr image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
//                        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//                            NSLog(@"分享成功！");
//                        }
//                    }];
                    
                }
                    break;
                case 2:
                {
                    //QQ
                    //分享标题
//                    [UMSocialData defaultData].extConfig.qqData.title = self.titleStr;
//                    //跳转链接
//                    [UMSocialData defaultData].extConfig.qqData.url = self.shareDetailUrl;
//                    //分享url图片
//                    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.shareImgUrl];
//                    
//                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.describtionStr image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
//                        if (response.responseCode == UMSResponseCodeSuccess) {
//                            NSLog(@"分享成功！");
//                        }
//                    }];
                }
                    break;
                case 3:
                {
                    //QQ空间
                    //分享标题
//                    [UMSocialData defaultData].extConfig.qzoneData.title = self.titleStr;
//                    //跳转链接
//                    [UMSocialData defaultData].extConfig.qzoneData.url = self.shareDetailUrl;
//                    //分享url图片
//                    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.shareImgUrl];
//                    
//                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.describtionStr image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
//                        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//                            NSLog(@"分享成功！");
//                        }
//                    }];
                }
                    break;
                default:
                    break;
            }
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
    }else{
        [self.view showFailWithTitle:@"请确保网络连接后重试"];
    }

}
@end

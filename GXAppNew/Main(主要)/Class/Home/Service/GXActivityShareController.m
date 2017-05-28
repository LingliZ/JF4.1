//
//  GXActivityShareController.m
//  GXApp
//
//  Created by 王振 on 2016/11/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXActivityShareController.h"
#import "GXActionSheetView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "GXAdaptiveHeightTool.h"

@interface GXActivityShareController ()

@end

@implementation GXActivityShareController


-(void)shareActiviyLinkUrl:(NSString *)shareLinkUrl shareImage:(NSString *)shareImgUrl shareTitleName:(NSString *)shareTitle shareDiscribContent:(NSString *)simpleContentDesc{
    if (self.shareLinkUrl != shareLinkUrl) {
        self.shareLinkUrl = shareLinkUrl;
    }
    if (self.shareImgUrl != shareImgUrl) {
        self.shareImgUrl = shareImgUrl;
    }
    if (self.shareTitle != shareTitle) {
        self.shareTitle = shareTitle;
    }
    if (self.shareDesc != simpleContentDesc) {
        self.shareDesc = simpleContentDesc;
    }
    if ([GXUserInfoTool isConnectToNetwork]) {
        NSArray *titlearr = @[@"微信好友",@"微信朋友圈",@"QQ",@"QQ空间"];
        NSArray *imageArr = @[@"wechat_friends",@"circle_of_friends",@"qq_friends",@"qq_space_pic"];
        
        GXActionSheetView *actionsheet = [[GXActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"测试" and:ShowTypeIsOneLineScrollowStyle];
        [actionsheet setBtnClick:^(NSInteger btnTag) {
            switch (btnTag) {
                case 0:
                {//微信
                    //创建分享消息对象
                    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                    //创建网页内容对象
                    NSString* thumbURL =  self.shareImgUrl;
                    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:thumbURL];
                    //设置网页地址
                    shareObject.webpageUrl = self.shareLinkUrl;
                    //分享消息对象设置分享内容对象
                    messageObject.shareObject = shareObject;
                    //调用分享接口
                    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                        if (error) {
                            UMSocialLogInfo(@"************Share fail with error %@*********",error);
                        }else{
                            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                UMSocialShareResponse *resp = data;
                                //分享结果消息
                                UMSocialLogInfo(@"response message is %@",resp.message);
                                //第三方原始返回的数据
                                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                
                            }else{
                                UMSocialLogInfo(@"response data is %@",data);
                            }
                        }
                        [self alertWithError:error];
                    }];
                }
                    break;
                case 1:
                {//微信朋友圈
                    //创建分享消息对象
                    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                    //创建网页内容对象
                    NSString* thumbURL =  self.shareImgUrl;
                    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:thumbURL];
                    //设置网页地址
                    shareObject.webpageUrl = self.shareLinkUrl;
                    //分享消息对象设置分享内容对象
                    messageObject.shareObject = shareObject;
                    //调用分享接口
                    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                        if (error) {
                            UMSocialLogInfo(@"************Share fail with error %@*********",error);
                        }else{
                            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                UMSocialShareResponse *resp = data;
                                //分享结果消息
                                UMSocialLogInfo(@"response message is %@",resp.message);
                                //第三方原始返回的数据
                                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                
                            }else{
                                UMSocialLogInfo(@"response data is %@",data);
                            }
                        }
                        [self alertWithError:error];
                    }];
                }
                    break;
                case 2:
                {//QQ
                    //创建分享消息对象
                    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                    //创建网页内容对象
                    NSString* thumbURL =  self.shareImgUrl;
                    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:thumbURL];
                    //设置网页地址
                    shareObject.webpageUrl = self.shareLinkUrl;
                    //分享消息对象设置分享内容对象
                    messageObject.shareObject = shareObject;
                    //调用分享接口
                    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                        if (error) {
                            UMSocialLogInfo(@"************Share fail with error %@*********",error);
                        }else{
                            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                UMSocialShareResponse *resp = data;
                                //分享结果消息
                                UMSocialLogInfo(@"response message is %@",resp.message);
                                //第三方原始返回的数据
                                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                
                            }else{
                                UMSocialLogInfo(@"response data is %@",data);
                            }
                        }
                        [self alertWithError:error];
                    }];
                }
                    break;
                case 3:
                {//QQ空间
                    //创建分享消息对象
                    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                    //创建网页内容对象
                    NSString* thumbURL =  self.shareImgUrl;
                    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:thumbURL];
                    //设置网页地址
                    shareObject.webpageUrl = self.shareLinkUrl;
                    //分享消息对象设置分享内容对象
                    messageObject.shareObject = shareObject;
                    //调用分享接口
                    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                        if (error) {
                            UMSocialLogInfo(@"************Share fail with error %@*********",error);
                        }else{
                            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                UMSocialShareResponse *resp = data;
                                //分享结果消息
                                UMSocialLogInfo(@"response message is %@",resp.message);
                                //第三方原始返回的数据
                                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                
                            }else{
                                UMSocialLogInfo(@"response data is %@",data);
                            }
                        }
                        [self alertWithError:error];
                    }];

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
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功!"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
            if(error.code == 2008)
            {
                result =@"您的设备没有安装要分享的客户端";
            }
            if (error.code == 2009) {
                result = @"分享取消！";
            }
            
        }
        else{
            result = [NSString stringWithFormat:@"分享失败!"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

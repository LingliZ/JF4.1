//
//  GXConstants.h
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#ifndef GXConstants_h
#define GXConstants_h

#define IsShowOpenAccount @"isShowOpenAccount"
/**
 我的注册登录
 */
#define ISLOGIN @"isLogin" //用于设置用户登录状态
#define UserTocken @"userTocken"//登录成功后获取到
#define UserSeesionTocken @"UserSeesionTocken"//登录成功后获取到seesionToken
/*
 *是否接受消息
 */
#define IsReceiveMessage @"isReceiveMessage" //是否接收消息
#define IsReceiveAdviceMsg @"IsReceiveAdviceMsg" //是否接收即时建议消息
#define IsReceiveReplayMsg @"IsReceiveReplayMsg" //是否接收顾问回复消息
#define IsRecieveGuoXinMsg @"IsRecieveGuoXinMsg" //是否接收国鑫消息
#define IsReceivePriceWarnMsg @"IsReceivePriceWarnMsg" //是否接收报价提醒消息
#define suggestLocalMsg @"suggestLocalMsg" //即使建议本地存储
#define replyLocalMsg @"replyLocalMsg" //顾问回复本地存储
#define GXMessageLocalMsg @"GXMessageLocalMsg" //国鑫消息本地存储
#define priceAlarmLocalMsg @"priceAlarmLocalMsg" //报价提醒本地存储


/*
 *是否接收短信提醒
 */
#define IsRecieveShortMsg_Suggestion @"IsRecieveShortMsg_Suggestion"//是否接收即时建议短信提醒
#define IsRecieveShortMsg_Price @"IsRecieveShortMsg_Price" //是否接收报价提醒短信
#define IsFirstRun @"isFirstRun" //程序是否是首次运行

#define CustomerID @"customerId"//开户时获取到
#define UserID @"gxUserId"//登录成功后获取到的
#define PhoneNumber @"phoneNumber"//用户手机号
#define HeadImage @"headImage"//头像存储字段
#define NickNames @"nickName" //昵称
#define userNickName @"userNickName" //用户昵称
#define userHeadImage @"userHeadImage" // 用户头像url
#define LoginAccount @"loginAccounts"//登录账号
#define UserReallyName @"userReallyName" //用户真实姓名
#define UserIDCardNum @"userIDCardNum" //用户身份证号


#define UserDefineHeadImage @"mine_head_placeholder" // 用户默认头像
#define onlineCutemerHeadImage @"onlineCutemer" // 默认客服头像

#define AddCountFor @"addCountFor"//开户的类型
#define ForTianjin @"forTianjin"//开津贵所的户
#define ForQilu @"forQilu"//开齐鲁的户
#define ForShanxi @"forShanxi"//开陕西一带一路的户
#define ForGuanggui @"forGuanggui"//开广贵中心的户
#define AccountTypeQilu @"qiluce" //齐鲁交易所
#define AccountTypeTianjin @"tjpme" //天津贵金属交易所
#define AccountTypeShanxi @"sxbrme"//陕西一带一路
#define AccountTypeGuanggui @"gdpmec"//广贵中心

#define TitlesArrayForQilu @"titlesArrayForQilu"//存储齐鲁问卷调查题目的标题数组
#define ItemsArrayForQilu @"itemsArrayForQilu"//存储齐鲁问卷调查题目的选项和分值数组
#define ItemsOnlyArrayForQilu @"itemsOnlyArrayForQilu"//存储齐鲁问卷调查题目的选项的数组

#define TitlesArrayForTianjin @"titlesArrayTianjin"//存储津贵所问卷调查题目的标题数组
#define ItemsArrayTianjin     @"itemsArrayTianjin"//存储津贵所问卷调查题目的选项和分项数组
#define ItemsOnlyArrayTianjin @"itemsOnlyArrayTianjin"//存储津贵所问卷调查题目的选项数组

#define Color_btn_next_normal @"4082F4"//“下一步”按钮正常状态下的颜色
#define Color_btn_next_Highled @"DB7902"//“下一步”按钮高亮状态下的颜色
#define Color_btn_next_enabled @"7AD6FA"//“下一步”按钮禁用状态下的颜色

#define AddObserver_EditingState_changeBtnState [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editClick) name:UITextFieldTextDidChangeNotification object:nil]; //监听编辑状态来调整按钮的状态

#define AddCountParams @"addCountParams"//开户所提交的参数字典
#define GXPhoneNum @"4006999225"// 国鑫公司电话
#define AddCountSuccess @"addCountSuccess"//开户成功
#define AddCountFailed @"addCountFailed"//开户失败
#define NotConnectToNetworking @"无网络连接" //未连接到网
#define ISConnectToNetWorking @"isConnectToNetWork"//是否联网
#define Check_Name_Qualified @"check_name_qualified" //姓名格式符合
#define Check_Password_Qualified @"check_password_qualified" //密码格式符合
#define Check_NickName_Qualified @"check_nickname_qualified" //昵称格式符合
#define Check_ContactForFeedBack_Qualified @"check_contactForFeedBack_qualified" //意见反馈界面的联系方式校验格式合格
#define Check_DealPassword_Guanggui_Qualified @"Check_DealPassword_Guanggui_Qualified"//广贵交易密码格式符合

/*
 appdelegate相关
 */
#define GXOnlineServiceCountNotificationName @"GXOnlineServiceCountNotificationName" //在线客服提示数量
#define GXMineCountNotificationName @"GXMineCountNotificationName" //我的界面提示红点
#define GXHomeCountNotificationName @"GXHomeCountNotificationName" //主界面右上角通知


/*
 环信相关客服
 */
#define EaseMobAccount @"EaseMobAccount"
#define EaseMobPassword @"EaseMobPassword"
#define kMesssageExtWeChat @"weichat"
#define kMesssageExtWeChat_ctrlType @"ctrlType"
#define kMesssageExtWeChat_ctrlType_enquiry @"enquiry"
#define kMesssageExtWeChat_ctrlType_inviteEnquiry @"inviteEnquiry"
#define kMesssageExtWeChat_ctrlType_transferToKfHint  @"TransferToKfHint"
#define kMesssageExtWeChat_ctrlType_transferToKf_HasTransfer @"hasTransfer"
#define kMesssageExtWeChat_ctrlArgs @"ctrlArgs"
#define kMesssageExtWeChat_ctrlArgs_inviteId @"inviteId"
#define kMesssageExtWeChat_ctrlArgs_serviceSessionId @"serviceSessionId"
#define kMesssageExtWeChat_ctrlArgs_detail @"detail"
#define kMesssageExtWeChat_ctrlArgs_summary @"summary"
#define kMesssageExtWeChat_ctrlArgs_label @"label"



/*
 推送相关
 */
#define GXAppDevice_token @"GXAppDevice_token" // device_token
#define PriceAlarm @"GXPriceAlarm.plist"
#define priceAlarmNumber @"priceAlarmNumber" //报价提醒个数
#define replyNumber @"replyNumber" //顾问回复个数
#define suggestNumber @"suggestNumber" //即使建议个数
#define GXMessageNumber @"GXMessageNumber" //国鑫消息个数
#define cutomerNumber @"cutomerNumber" //客服消息个数

/*
 行情相关
 */
#import "GXPriceConst.h"
#define GXPersonSelectArrayNotificationName @"GXPersonSelectArrayNotificationName" // 行情自选通知名称
#define PersonSelectCodesKey @"PersonSelectCodesKey" // 自选行情的参数字符串
#define PersonSelectBtnStatus @"PersonSelectBtnStatus" // 自选行情btn的选择状态
#define PricePlatformKey @"PricePlatformKey"



/*
 视频直播相关
 */
#define GXIsFristLiveVideo @"GXIsFristLiveVideo"
#define GXVideoRoomId @"GXRoomId"
#define GXVisitorName @"GXVisitorName"
#define GXIsRealCustom @"GXIsRealCustom"
#define GXOpenRealAccountNotify @"GXOpenRealAccountNotify"
#define GXLoadAccount @"GXLoadAccount"
#define GXSuggestionId @"GXSuggestionId"
/**
 首页相关
 */
#define SearchHistory @"searchHistory"

#endif /* GXConstants_h */

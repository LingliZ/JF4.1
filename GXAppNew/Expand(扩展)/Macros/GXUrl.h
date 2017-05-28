//
//  GXUrl.h
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#ifndef GXUrl_h
#define GXUrl_h


// 首页
#define GXUrl_home @"/home" //主页
#define GXUrl_getSearchKeyword @"/search-keyword" //搜索:关键字
#define GXUrl_search @"/search" //搜索: keyword=银&page=1&number=3
#define GXUrl_articleTypeList @"/article-type-list" //文章类型：
#define GXUrl_articleList @"/article-list" //文章列表：cid=279&page=1&number=3
#define GXUrl_articleDetail @"/article-detail" //文章详情：id=12345
#define GXUrl_finance @"/dailyfx/day" //date时期格式yyyyMMdd
#define GXUrl_tradeDetail @"/trade-detail-list" //交易细则
#define GXUrl_profitList @"/profit-list"  //  盈利计算器规则
#define GXUrl_importList @"/import-news/list" //重要消息:page = 1,number = 10

#define FatherBeginScroll @"HomeBeginScroll"
#define SonBeginScroll @"SonBeginScroll"
#define SonEndScroll @"SonEndScroll"
#define HomeSeviceInfo @"HomeSeviceInfo"


//首页H5页面
#define GXUrl_Brand_Advantage [NSString stringWithFormat:@"%@/brand.html",GXUrl_H5BaseUrl]//品牌优势
#define GXUrl_Profit_ranking [NSString stringWithFormat:@"%@/rank.html",GXUrl_H5BaseUrl]//盈利排行
#define GXUrl_About_investment [NSString stringWithFormat:@"%@/know.html",GXUrl_H5BaseUrl]//快速了解现货投资
#define GXUrl_GuoXin_research_institute [NSString stringWithFormat:@"%@/research.html",GXUrl_H5BaseUrl]//国鑫研究院(为啥选择国鑫)
#define GXUrl_Threeminutes_open_account [NSString stringWithFormat:@"%@/quick.html",GXUrl_H5BaseUrl]//三分钟快速开户

//发现
#define GXUrl_findVideo @"/history-live-courses"  //精彩视频 ?page=1&number=5
#define GXUrl_findInvestSchool @"/study-list"  //?cid=1;投资学院 主列表
#define GXUrl_findInvestSchoolDetailsList @"/course-list"  //?pid=72;投资学院 详情列表
#define GXUrl_findInvestSchoolDetails @"/course-detail"  //?id=202;投资学院 详情

//行情
#define GXUrl_fetchPrice @"/customer-market/fetch" //获取行情自选列表
#define GXUrl_setPrice @"/customer-market/set" //上传行情自选列表:productCodes = ptv3
#define GXUrl_marketInfo    @"/market/query/marketInfo"   // 列表：platform=ios
#define GXUrl_timeline      @"/market/query/timeline"         //分时线：code=xagusd&period=1
#define GXUrl_kLineType     @"/market/query/kLineType"       //K线级别
#define GXUrl_kline         @"/market/query/kline"               //K线图 maxrecords=200&code=xagusd&level=1
#define GXUrl_quotation     @"/market/query/quotation"       //产品报价 交易所报价 code=xagusd excode=tjpme
#define GXUrl_QuotationReminderSet @"/quotation-reminder-set"       //  增加报价提醒  code产品代码 upperBound lowerBound bySms
#define GXUrl_QuotationReminderFetch @"/quotation-reminder-fetch"   // 根据code查询报价
#define GXUrl_SetReceiveCallStatus @"/set-receive-call-status"      //  设置我接收即时建议  参数：isReceiveCall
#define GXUrl_SetQuotationReminderSms @"/set-quotation-reminder-sms"   //  设置我的报价提醒  参数 bySms
#define GXUrl_GetReceiveCallStatus @"/get-receive-call-status"      //  获取我的即时建议
#define GXUrl_GetQuotationReminderSms @"/get-quotation-reminder-sms"   //  获取我的报价提醒
#define GXUrl_priceFinance  @"/dailyfx/week"                     // 获取行情财经日历
#define GXUrl_isBindRoom  @"/vip/market-call"                     // 获取行情及时建议绑定信息  isLater = 1  code  userStatus ：0 未登录，1 登录， 2 实盘用户， 3 没绑定，4 绑定用户
#define GXUrl_priceContrast  @"/trade/get-bs-deals"  //多空对比接口 只有交易所的才请求


//视频直播
#define GXUrl_liveSpeakMsg @"/get-live-speak"//视频消息
#define GXUrl_liveSpeakQ @"/live-speak"//发送消息
#define GXUrl_liveCall @"/live-call-ex" //直播即使建议
#define GXUrl_liveCourses @"/live-courses" //直播课程
#define GXUrl_liveValidTime @"/live-validTime"//体验时间
#define GXRoomId @"GXRoomId"

//顾问平台
#define GXUrl_isRealAccount @"/isRealAccount"//是否是实盘用户
#define GXUrl_getRooms  @"/vip/get-rooms"// 获取播间列表
#define GXUrl_getFullRooms  @"/vip/get-full-rooms"// 点击查看更多获取播间列表
#define GXUrl_getData @"/vip/getData" //获取播间数据  type=1&count=1&isLater=1&startId=0&roomId=1372412092890&isMore=0
#define GXUrl_getBulletins @"/vip/getBulletins" //公告列表  count=1&isLater=1&startId=0&roomId=1372412092890
#define GXUrl_myMessage @"/vip/myMessage" //消息 ：type=1&count=1&isLater=1&startId=0 1.建议 2回复 4 国鑫消息
#define GXUrl_newMyMessage @"/vip/gx-message"//count=10&baseId=0&isLater=1
#define GXUrl_ask @"/vip/ask" //问答 RoomID Content
#define GXUrl_speak @"/vip/speak" // 对谁ReplyTo Content RoomID
#define GXUrl_select_room @"/vip/select-room"  //绑定播间  roomId
#define GXUrl_cancel_room @"/vip/cancel-room"  //解绑播间  roomId


//会员
//#define GXUrl_login @"/secret/login" //登录：account=admin&password=admin
#define GXUrl_login @"/login" //登录：account=admin&password=admin

#define GXUrl_FreeLogin @"/secret/free-login" //免注册登录（手机验证登录） mobile,verCode,source
#define GXUrl_sendVerCode @"/send-verCode" //发送验证码 mobile=123   ///   /secret/send-verCode
#define GXUrl_vertyVerCode @"/mobile-verify" //验证验证码 mobile，verCode
#define GXUrl_register @"/register" //注册 mobile＝123&verCode＝123&password＝123&source＝ios
#define GXUrl_customerInfo @"/customer-info" //用户信息
#define GXUrl_updateNickname @"/update-nickname" //更新昵称 nickname＝111
#define GXUrl_updateRealName @"/secret/update-realName" //更新真实姓名 realName＝111‘
#define GXUrl_updateGender  @"/update-gender" //更改性别 gender=0秘密；1男；2女
#define GXUrl_updateBirthday @"/update-birthday"  // 更新生日
#define GXUrl_updatePassword @"/secret/update-password"  //更新密码：oldPassword=&newPassword=
#define GXUrl_forgetPassword  @"/secret/forget-password" //忘记密码：mobile=&verCode=&newPassword=
#define GXUrl_changeMobileVerify   @"/change-mobile-verify"//更新手机号(用于验证原手机号)：mobile＝&verCode＝
#define GXUrl_updateMobile   @"/update-mobile-without-password"//更新手机号(用于绑定新手机号)：mobile＝&verCode＝

#define GXUrl_updateEmail @"/update-email" //更新邮箱：email＝
#define GXUrl_updateAvatar @"/update-avatar/upload-full?serviceName=customer" //更新头像 avatar=头像
#define GXUrl_updateIDCard_front @"/upload-id-face/upload-full?serviceName=customer"//上传身份证正面
#define GXUrl_updateIDCard_behind @"/upload-id-rear/upload-full?serviceName=customer"//上传身份证背面
#define GXUrl_updateAddress @"/update-address" //更新地址 province=&city=&area=&address=
#define GXUrl_helpList @"/help-list" //帮助中心
#define GXUrl_feedBack @"/feed-back" //user content 意见反馈
#define GXUrl_customerAccount @"/customer-Account"

//开户
#define GXUrl_DeviceRegister @"/device/register" //设备注册
#define GXUrl_idfa @"/idfa/receiveIDFA"
#define GXUrl_registerIDFA @"/idfa/registerIDFA"
#define GXUrl_checkOpenAccount @"/secret/check-account" //验证用户 ?mobile=13811786788&verCode=945971&realName=%E7%8E%8B%E6%B7%BC&source=IOS
#define GXUrl_getSurvey @"/survey" //获取题目 type=qiluce，tjpme&customerId=
//#define GXUrl_openAccount @"/secret/open-account" //开户
#define GXUrl_openAccount @"/open-account" //开户
#define GXUrl_get_open_account @"/get-open-account" //开户验证
#define GXUrl_agree @"/agree" //获取协议 type
#define AgreeType_GUOXIN_SOFTWARE @"GUOXIN_SOFTWARE"// 国鑫软件服务协议
#define AgreeType_GUOXIN_REGISTER @"GUOXIN_REGISTER" //国鑫金服用户协议
#define AgreeType_TJPME_RISKWARNING @"TJPME_RISKWARNING" //津贵所风险揭示书
#define AgreeType_TJPME_COMMITMENTLETTER @"TJPME_COMMITMENTLETTER" //津贵所承诺保证书
#define AgreeType_QILU_RISKWARNING @"QILU_RISKWARNING" //齐鲁风险提示书
#define AgreeType_TJPME_RISKSPECIAlTIPS @"TJPME_RISKSPECIAlTIPS" //津贵所风险投资特别提示
#define AgreeType_QILU_CLIENTCONFIRM @"QILU_CLIENTCONFIRM" //齐鲁客户确认函
#define AgreeType_QILU_CLIENTAGREEMENT @"QILU_CLIENTAGREEMENT" //齐鲁客户协议书
#define AgreeType_TJPME_CLIENTAGREEMENT @"TJPME_CLIENTAGREEMENT" //津贵所客户协议书
#define AgreeType_QILU_QUESTION @"QILU_QUESTION" //齐鲁调查问卷
#define GXUrl_getInvestList  @"/qiluce-invest-list" //获取齐鲁投资类表 investYearList 投资年限 investPreferenceList 投资偏好
#define GXUrl_getBankList  @"/bank-list" //获取银行列表
#define GXUrl_Check_accountInfo @"/check-account-info"//广贵开户-身份证校验  idNumber，customerName，email
#define GXUrl_Bind_bankCard @"/bind-bank-card"//广贵开户-绑定银行卡  type，accountNumber，bankCode，bankAccountNo，phoneNo，province，city
#define GXUrl_Bind_bankCard_confirm @"/bind-bank-card-confirm"//广贵开户-绑定银行卡-确认

#endif /* GXUrl_h */

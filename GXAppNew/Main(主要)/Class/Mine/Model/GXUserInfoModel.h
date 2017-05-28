//
//  GXUserInfoModel.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/22.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseModel.h"

@interface GXUserInfoModel : GXMineBaseModel

@property(nonatomic,strong)NSString*area;
@property(nonatomic,strong)NSString*avatar;
@property(nonatomic,strong)NSString*city;
@property(nonatomic,strong)NSDictionary*contactInfo;
@property(nonatomic,strong)NSString*createTime;
@property(nonatomic,strong)NSArray*customerAccount;
@property(nonatomic,strong)NSString*customerId;
@property(nonatomic,strong)NSString*customerLevel;
@property(nonatomic,strong)NSString*customerLevelName;
@property(nonatomic,strong)NSNumber*emailIsVer;
@property(nonatomic,strong)NSNumber*gender;
@property(nonatomic,strong)NSDictionary*identity;
@property(nonatomic,strong)NSNumber*isDeleted;
@property(nonatomic,strong)NSString*liveNickname;
@property(nonatomic,strong)NSString*mobile;
@property(nonatomic,strong)NSNumber*mobileIsVer;
@property(nonatomic,strong)NSString*nickname;
@property(nonatomic,strong)NSString*province;
@property(nonatomic,strong)NSString*registerIp;
@property(nonatomic,strong)NSString*realName;
@property(nonatomic,strong)NSString*registerSource;
@property(nonatomic,strong)NSNumber*status;


@end

//
//  GXAccountDetailModel.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/22.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXAccountDetailModel : NSObject
@property(nonatomic,copy)NSString *account;
@property(nonatomic,copy)NSString *accountStatus;
@property(nonatomic,copy)NSString *bankCardStatus;
@property(nonatomic,copy)NSString *customerName;
@property(nonatomic,copy)NSString *idNumber;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *signHelpId;
@property(nonatomic,copy)NSString *depositHelpId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *offlineSignHelpId;
@property(nonatomic,copy)NSString *onlineSignHelpId;
@property(nonatomic,copy)NSString *requirement;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,copy)NSString *signRequirement;
@end

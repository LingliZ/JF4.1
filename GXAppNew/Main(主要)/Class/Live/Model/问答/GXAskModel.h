//
//  GXAskModel.h
//  GXAppNew
//
//  Created by maliang on 2016/12/14.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXAskModel : NSObject
@property (nonatomic, copy) NSString *askPics;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) NSArray *askPicsArray;
@property (nonatomic, copy) NSString *askerId;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *answerPics;

+ (instancetype)askModelWithDict: (NSDictionary *)dict;
- (instancetype)initWithDict: (NSDictionary *)dict;
@end

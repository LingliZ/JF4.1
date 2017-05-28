//
//  GXConsultantReplyModel.h
//  GXApp
//
//  Created by zhudong on 16/7/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXConsultantReplyModel : NSObject
@property(nonatomic, strong) NSString * StaffPic;
@property(nonatomic, strong) NSString * Content;
@property(nonatomic, strong) NSString * Teacher;
@property(nonatomic, strong) NSString * CreatedTime;
@property(nonatomic, strong) NSString * Answer;
@property(nonatomic, strong) NSString * AnswerName;
@property(nonatomic, strong) NSString * AnswerPic;
@property(nonatomic, strong) NSString * AnswerTime;
@property(nonatomic, strong) NSString * AskerPic;
@property(nonatomic, strong) NSMutableArray * AskerList;
@property(nonatomic, strong) NSString * Type;
@property(nonatomic, strong) NSString * ID;
@property(nonatomic, strong) NSString * Question;
@property(nonatomic, strong) NSString * NickName;
@property(nonatomic, strong) NSMutableArray * Imgs;
@property(nonatomic, assign) BOOL isRead;
@end

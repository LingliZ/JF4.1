//
//  GXMessagesModel.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXMessagesModel : NSObject
@property(nonatomic,strong)NSString * Content;
@property(nonatomic,strong)NSString * CreatedTime;
@property(nonatomic,strong)NSNumber * ID;
@property(nonatomic,strong)NSString *timeStr;
@property(nonatomic,assign)BOOL isRead;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)messageModelWithDict:(NSDictionary *)dict;

@end

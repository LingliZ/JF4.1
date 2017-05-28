//
//  PriceCanlendarBaseModel.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceCanlendarBaseModel : NSObject

@property (nonatomic,copy)NSString *country;
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *importance;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *type;

@property (nonatomic,assign)CGFloat cellHeight;


+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;


@end

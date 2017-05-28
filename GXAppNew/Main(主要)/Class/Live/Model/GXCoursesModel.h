//
//  GXCoursesModel.h
//  GXApp
//
//  Created by zhudong on 16/7/18.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXCoursesModel : NSObject
@property (nonatomic,copy) NSString *analysts;
@property (nonatomic,copy) NSArray *analystsArray;
@property (nonatomic,copy) NSString *stime;
@property (nonatomic,copy) NSString *etime;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *host;
+ (instancetype)courseWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

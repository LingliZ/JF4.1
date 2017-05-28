//
//  GXDiscoverModel.h
//  GXAppNew
//
//  Created by zhudong on 2016/12/9.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDiscoverModel : NSObject
@property (nonatomic,copy) NSString *iconName;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)dicoverWithDict: (NSDictionary *)dict;
+ (NSArray *)discoverModels;
@end

//
//  GXHomeImpMsgBaseModel.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXHomeImpMsgBaseModel : NSObject
//id
@property (nonatomic, strong) NSString *ID;
// 概要
@property (nonatomic, strong) NSString *metadesc;
// 发布日期
@property (nonatomic, strong) NSString *created;
// 类型
@property (nonatomic, strong) NSString *type;
// 标题
@property (nonatomic, strong) NSString *title;
//是否可点击
@property (nonatomic, assign) NSNumber *click;
//
@property (nonatomic, strong) NSString *tagName;
//图片
@property (nonatomic, strong) NSString *imgUrl;

+(instancetype)modelWithDictionary:(NSDictionary *)dictionary;


@end

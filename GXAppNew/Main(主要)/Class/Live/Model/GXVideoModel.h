//
//  GXVideoModel.h
//  GXAppNew
//
//  Created by maliang on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLiveBaseModel.h"

@interface GXVideoModel : GXLiveBaseModel

@property(nonatomic, strong) NSString * imageUrlApp;
@property(nonatomic, strong) NSString * imageUrl;
@property(nonatomic, strong) NSString * analyst;
@property(nonatomic, strong) NSString * bindCount;
@property(nonatomic, copy) NSString * id;
@property(nonatomic, strong) NSString * isBindRoom;
@property(nonatomic, strong) NSString * isVideoRoom;
@property(nonatomic, strong) NSString * isVip;
@property(nonatomic, assign) BOOL isLive;
@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSString * isTop;
@property(nonatomic, strong) NSString * roomTags;
@property(nonatomic, strong) NSString * slogan;
@property(nonatomic, strong) NSString * more;
@property(nonatomic, strong) NSDictionary * currentCourse;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,assign) BOOL isPlaying;
@property(nonatomic, strong) NSDate * sDate;
@property(nonatomic, strong) NSDate * eDate;
@property(nonatomic, copy) NSString *intro;


@end

//
//  GXSuggestionVc.h
//  GXAppNew
//
//  Created by maliang on 2016/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXChildBaseController.h"

@interface GXSuggestionVc : GXChildBaseController

@property(nonatomic, strong) NSString * liveRoomID;
@property(nonatomic, copy) NSString *isBindRoom;

- (instancetype)initWithBundleRoom: (NSString *)isBindRoom;
@end

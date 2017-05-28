//
//  GXMineBaseModel.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/16.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface GXMineBaseModel : NSObject
-(CGFloat)getHeightWithContent:(NSString*)content andFontSize:(int)fontSize andWidth:(double)width;
@end

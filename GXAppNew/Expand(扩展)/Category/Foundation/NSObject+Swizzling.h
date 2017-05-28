//
//  NSObject+Swizzling.h
//  Pods
//
//  Created by futang yang on 2016/11/8.
//
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"

@interface NSObject (Swizzling)

+(void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector;

@end

//
//  WKWebView+ImageArray.m
//  GXAppNew
//
//  Created by 王振 on 2017/1/23.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "WKWebView+ImageArray.h"

@implementation WKWebView (ImageArray)

static char imgUrlArrayKey;

- (void)setMethod:(NSArray *)imgUrlArray
{
    
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}



- (NSArray *)getImgUrlArray

{
    
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
    
}

@end

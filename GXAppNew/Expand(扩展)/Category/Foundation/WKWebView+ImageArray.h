//
//  WKWebView+ImageArray.h
//  GXAppNew
//
//  Created by 王振 on 2017/1/23.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (ImageArray)


- (void)setMethod:(NSArray *)imgUrlArray;
- (NSArray *)getImgUrlArray;


@end

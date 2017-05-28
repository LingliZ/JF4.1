//
//  UIImageView+SDWebImage.m
//  GXApp
//
//  Created by futang yang on 2016/11/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "UIImageView+SDWebImage.h"
#import "UIImageView+WebCache.h"
#import "NSObject+Swizzling.h"



@implementation UIImageView (SDWebImage)


+ (void)load {
    
    [self methodSwizzlingWithOriginalSelector:@selector(sd_setImageWithURL:placeholderImage:) bySwizzledSelector:@selector(gx_setImageWithURL:placeholderImage:)];
}


- (void)gx_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    
    if([url.absoluteString rangeOfString:@"http"].location == NSNotFound) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseImageUrl,url.absoluteString]];
    }
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

@end

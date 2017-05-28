//
//  GXHeadReduceTool.m
//  GXAppNew
//
//  Created by maliang on 2017/2/27.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXHeadReduceTool.h"

@implementation GXHeadReduceTool


+ (void)loadImageForImageView:(UIImageView *)imageView withUrlString:(NSString *)urlString placeHolderImageName:(NSString *)placeHolderImageName
{
    urlString = [NSString stringWithFormat:@"%@%@",baseImageUrl,urlString];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:placeHolderImageName] options:SDWebImageProgressiveDownload progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(error==nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect rect=CGRectMake(40, 20, 150, 150);
                CGImageRef imageRef=CGImageCreateWithImageInRect([imageView.image CGImage], rect);
                UIImage*image=[UIImage imageWithCGImage:imageRef];
                imageView.image=image;
                
            });
        }        
    }];
}


@end

//
//  GXImageSizeTool.h
//  GXApp
//
//  Created by 王振 on 16/8/13.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXImageSizeTool : NSObject
// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;

@end

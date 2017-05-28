//
//  SDWebImage.h
//  oser
//
//  Created by 沈启龙 on 14-5-7.
//
//

#ifndef oser_SDWebImage_h
#define oser_SDWebImage_h

//MKAnnotationView地图的注解View缓存
#import "MKAnnotationView+WebCache.h"

//判断NSData是否什么类型的图片(例如:jpg,png,gif)
#import "NSData+ImageContentType.h"

//是SDWebImage包的一部分
#import "SDImageCache.h"      //缓存相关
#import "SDWebImageCompat.h"  //组件相关
#import "SDWebImageDecoder.h" //解码相关

//图片下载以及下载管理器
#import "SDWebImageDownloader.h"
#import "SDWebImageDownloaderOperation.h"

//管理以及操作
#import "SDWebImageManager.h"
#import "SDWebImageOperation.h"

//UIButton类目
#import "UIButton+WebCache.h"

//gif类目
#import "UIImage+GIF.h"

//图片其他类目
#import "UIImage+MultiFormat.h"
#import "UIImage+WebP.h"
#import "UIImageView+WebCache.h"

#endif

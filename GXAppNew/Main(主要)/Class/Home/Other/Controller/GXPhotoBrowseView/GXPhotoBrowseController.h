//
//  GXPhotoBrowseController.h
//  GXApp
//
//  Created by 王振 on 16/8/13.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXPhotoBrowseController : UIViewController
//存储图片url的数组
@property (nonatomic,strong)NSMutableArray *imgUrlArray;
//点击的imgUrl
@property (nonatomic,strong)NSString *imgUrl;
@property (nonatomic, assign) NSInteger currentIndex;


@end

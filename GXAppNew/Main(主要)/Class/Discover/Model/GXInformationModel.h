//
//  GXInformationModel.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/14.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXInformationModel : NSObject
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *created;
@property (nonatomic,strong)NSString *imgurl;
@property (nonatomic,strong)NSString *author;
@property (nonatomic,copy)NSString *metadesc;
@property (nonatomic,assign)CGFloat cellHeight;

@end

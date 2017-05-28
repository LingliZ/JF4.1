//
//  GXAirView.h
//  GXApp
//
//  Created by 王振 on 16/8/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXAirView;

@protocol GXAirViewDelegate<NSObject>
//点击进入活动详情页代理
-(void)didClickGetInToAdViewAction;
//取消按钮代理

-(void)didClickCancelAirViewAction: (GXAirView *)airView;
@end



@interface GXAirView : UIView

@property (nonatomic,weak)id <GXAirViewDelegate>delegate;
//传入的图片
@property (nonatomic,strong)NSString *imgUrl;

@property (nonatomic,strong)UIView *airView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIView *lineView;
//初始化方法
- (id)initWithAirViewImageStr:(NSString *)imageStr;
-(void)show;



@end

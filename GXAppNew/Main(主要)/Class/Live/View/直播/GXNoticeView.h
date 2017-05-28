//
//  GXNoticeView.h
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXNoticeView;
@protocol GXNoticeViewDelegate <NSObject>

- (void)clickedNoticeView: (GXNoticeView *)noticeView;

@end

@interface GXNoticeView : UIView

@property(nonatomic, weak) id<GXNoticeViewDelegate> delegate;
@property(nonatomic, copy) NSString *roomID;
@property (nonatomic, strong) UILabel *titleLable;

- (instancetype)initWithFrame:(CGRect)frame withRoomId: (NSString *)roomId;

@end

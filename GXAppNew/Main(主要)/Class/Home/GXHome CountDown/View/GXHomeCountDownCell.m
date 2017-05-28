//
//  GXHomeCountDownCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeCountDownCell.h"


@interface GXHomeCountDownCell ()
{
    dispatch_source_t _timer;
}

@end

@implementation GXHomeCountDownCell

-(void)setModel:(GXHomeCountDownModel *)model{
    if (_model != model) {
        _model = model;
        [self.countDownImgView sd_setImageWithURL:[NSURL URLWithString:self.model.imgurl] placeholderImage:[UIImage imageNamed:@"home_newone_pic"]];
        self.titleLabel.text = self.model.title;
        self.contentLabel.text = self.model.desc;
        //时间倒计时
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *endDate = [dateFormatter dateFromString:self.model.stime];
        NSDate *endDate_fromServer = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:[endDate timeIntervalSinceReferenceDate]];
        NSDate *startDate = [NSDate date];
        NSTimeInterval timeInterval = [endDate_fromServer timeIntervalSinceDate:startDate];
        //NSLog(@"倒计时时间是:%f",timeInterval);
        //__weak typeof(self) weakSelf = self;
        if (_timer == nil) {
            __block int timeOut = timeInterval;//倒计时时间
            if (timeOut != 0) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
                dispatch_source_set_event_handler(_timer, ^{
                    if (timeOut <= 0) {
                        //倒计时结束,关闭
                        dispatch_source_cancel(_timer);
                        _timer = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.dayLabel.text = @"00";
                            self.hourLabel.text = @"00";
                            self.minuteLabel.text = @"00";
                            self.secondLabel.text = @"00";
                        });
                    }else{
                        int days = (int)(timeOut / (3600 * 24));
                        if (days == 0) {
                            self.dayLabel.text = @"00";
                        }
                        int hours = (int)((timeOut - days * 24 * 3600) / 3600);
                        int minute = (int)(timeOut - days * 24 * 3600 - hours * 3600) / 60;
                        int second = timeOut - days * 24 * 3600 - hours * 3600 - minute * 60;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (days == 0) {
                                self.dayLabel.text = @"00";
                            }else{
                                self.dayLabel.text = [NSString stringWithFormat:@"%d",days];
                            }
                            if (hours < 10) {
                                self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                            }else{
                                self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                            }
                            if (minute < 10) {
                                self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                            }else{
                                self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                            }
                            if (second < 10) {
                                self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                            }else{
                                self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                            }
                        });
                        timeOut--;
                    }
                });
                dispatch_resume(_timer);
            }
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewTopLine.constant = HeightScale_IOS6(10);
//    self.viewBottomLine.constant = HeightScale_IOS6(10);
    self.imgViewTopLine.constant = HeightScale_IOS6(10);
    self.titleTopLine.constant = HeightScale_IOS6(10);
    self.juliTopLine.constant = HeightScale_IOS6(10);
    self.dayTopLine.constant = HeightScale_IOS6(10);
    self.day1TopLine.constant = HeightScale_IOS6(10);
    self.hourTopLine.constant = HeightScale_IOS6(10);
    self.hour1TopLine.constant = HeightScale_IOS6(10);
    self.minuteTopLine.constant = HeightScale_IOS6(10);
    self.minute1TopLine.constant = HeightScale_IOS6(10);
    self.secondsTopLine.constant = HeightScale_IOS6(10);
    self.seconds1TopLine.constant = HeightScale_IOS6(10);
}

@end

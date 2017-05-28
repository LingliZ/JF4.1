//
//  GXsxbrmeSignHeadView.m
//  GXAppNew
//
//  Created by shenqilong on 17/2/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXsxbrmeSignHeadView.h"
#import "GXAccountDetailModel.h"
@implementation GXsxbrmeSignHeadView
{
    UIScrollView *imageScrollView;
    UIImageView *imageView;
    
    UIImageView *headImageView;

    
    UILabel *lb_tit;
    UILabel *lb_acc;
    
    
}

#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static CGFloat kParallaxDeltaFactor = 0.5f;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (id)parallaxHeaderViewWithCGSize:(CGSize)headerSize accountModel:(GXAccountDetailModel *)model
{
    GXsxbrmeSignHeadView *headerView = [[GXsxbrmeSignHeadView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    
    headerView.accountModel=model;
    
    [headerView initialSetup];
    
    return headerView;
}


- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    DLog(@"%f",offset.y);
    CGRect frame = imageScrollView.frame;
    
    if (offset.y > 0)
    {
        frame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
        imageScrollView.frame = frame;
        
        self.clipsToBounds = YES;
    }
    else
    {
        CGRect rect = kDefaultHeaderFrame;
        
        CGFloat delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        
        imageScrollView.frame = rect;
        self.clipsToBounds = NO;
        
    }
}

#pragma mark - Private

- (void)initialSetup
{
    GXAccountDetailModel *aModel=self.accountModel;
    
    if(!imageScrollView)
    {
        imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:imageScrollView];
        
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageScrollView addSubview:imageView];
        imageView.backgroundColor=RGBACOLOR(83, 142, 235, 1);

    }

    if(!headImageView)
    {
        headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 54, 54)];
        headImageView.image=[UIImage imageNamed:@"mine_head_placeholder"];
        [imageScrollView addSubview:headImageView];
    }
    
    
    if(!lb_tit)
    {
        lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(84, 20, 100, 20)];
        lb_tit.font=GXFONT_PingFangSC_Regular(13);
        lb_tit.textAlignment=NSTextAlignmentLeft;
        lb_tit.textColor=RGBACOLOR(197, 216, 249, 1);
        [imageScrollView addSubview:lb_tit];
    }
    lb_tit.text=@"您的交易帐号：";
    
    
    
    if(!lb_acc)
    {
        lb_acc=[[UILabel alloc]initWithFrame:CGRectMake(84, 42, GXScreenWidth-100, 20)];
        lb_acc.font=GXFONT_PingFangSC_Regular(20);
        lb_acc.textAlignment=NSTextAlignmentLeft;
        lb_acc.textColor=[UIColor whiteColor];
        [imageScrollView addSubview:lb_acc];
    }
    lb_acc.text=[NSString stringWithFormat:@"%@",aModel.account];
    
    
}


@end

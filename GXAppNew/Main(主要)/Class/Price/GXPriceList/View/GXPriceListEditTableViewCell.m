//
//  GXPriceListEditTableViewCell.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/18.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceListEditTableViewCell.h"
#import "GXPriceConst.h"
#import "GXPriceListScrollView.h"
@implementation GXPriceListEditTableViewCell
{
    UIImageView *m_checkImageView;
    BOOL m_checked;
    
    UIButton *editBackg;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor=[UIColor clearColor];
    self.backgroundColor=[UIColor clearColor];

    
    
    //创建滑动视图,把所有控件移到滑动视图
    self.rootScr=[[GXPriceListScrollView alloc]init];
    self.rootScr.bounces=NO;
    self.rootScr.showsHorizontalScrollIndicator=NO;
    self.rootScr.delegate=(id)self;
    self.rootScr.delegateCustom=(id)self;
    [self addSubview:self.rootScr];
    
    //创建删除button
    self.deleButton=[[UIButton alloc]init];
    [self.deleButton setBackgroundColor:[UIColor colorWithRed:213.0f/255.0f green:0 blue:0 alpha:1.0f]];
    [self.deleButton setImage:[UIImage imageNamed:@"Trash"] forState:UIControlStateNormal];
    [self.rootScr addSubview:self.deleButton];
    

    
    
    [self.topButton setImage:[UIImage imageNamed:priceEditList_imgname_cellTopBtn] forState:UIControlStateNormal];
    
    self.codename.textColor=priceEditList_color_cellText;
    self.codename.font=GXFONT_PingFangSC_Regular(15);
    
    self.exname.textColor=priceEditList_color_cellTextLittle;
    self.exname.font=GXFONT_PingFangSC_Regular(10);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.2 animations:^{
            m_checkImageView.center = pt;
            m_checkImageView.alpha = alpha;
        }];
    }
    else
    {
        m_checkImageView.center = pt;
        m_checkImageView.alpha = alpha;
    }
}

- (void)setEditing:(BOOL)editting animated:(BOOL)animated
{
    [super setEditing:editting animated:animated];
    
    if (editting)
    {
        if (!m_checkImageView)
        {
            m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:priceEditList_imgname_cellUnSelectBtn]];
            [self addSubview:m_checkImageView];
        }
        
        [self setChecked:m_checked];
        m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,CGRectGetHeight(self.bounds) * 0.5);
        m_checkImageView.alpha = 0.0;
        [self setCheckImageViewCenter:CGPointMake(25, CGRectGetHeight(self.bounds) * 0.5) alpha:1.0 animated:animated];
    }
    else
    {
        m_checked = NO;
        
        if (m_checkImageView)
        {
            [self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,CGRectGetHeight(self.bounds) * 0.5) alpha:0.0 animated:animated];
        }
    }
    
    
    
    // 更新scroll大小
    self.rootScr.frame=CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    if (editting)
    {
        self.rootScr.contentSize=CGSizeMake(CGRectGetWidth(self.bounds)+60, CGRectGetHeight(self.bounds));
    }else
    {
        self.rootScr.contentSize=CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    
    //更新删除按钮位置
    self.deleButton.frame=CGRectMake( CGRectGetWidth(self.bounds), 0, 60, CGRectGetHeight(self.bounds));
    
    for (id view in [self subviews]) {
        if(view!=self.rootScr && view!=self.deleButton)
        [self.rootScr addSubview:view];
    }
    
}

- (void)setChecked:(BOOL)checked
{
    if (checked)
    {
        m_checkImageView.image = [UIImage imageNamed:priceEditList_imgname_cellSelectBtn];
        self.rootScr.backgroundColor=priceEditList_color_cellSelectBackg;
    }
    else
    {
        m_checkImageView.image = [UIImage imageNamed:priceEditList_imgname_cellUnSelectBtn];
        self.rootScr.backgroundColor=[UIColor clearColor];
    }
    m_checked = checked;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self changeScrollViewOffset:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self changeScrollViewOffset:scrollView];
}
-(void)changeScrollViewOffset:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x>=30)
    {
        [scrollView setContentOffset:CGPointMake(60, 0) animated:YES];
    }else
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    //创建假删除
    if(editBackg)
    {
        [editBackg removeFromSuperview];
        editBackg=nil;
    }
    if(scrollView.contentOffset.x>=30)
    {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        
        editBackg=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
        editBackg.backgroundColor=[UIColor clearColor];
        [editBackg addTarget:self action:@selector(editBackgClick) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:editBackg];
        
        
        CGRect f=[editBackg convertRect:self.deleButton.frame fromView:self.deleButton.superview];
        if(f.origin.x+f.size.width>GXScreenWidth)
            f.origin.x-=f.origin.x+f.size.width-GXScreenWidth;
        
        UIButton *editBackg_deleButton=[[UIButton alloc]initWithFrame:f];
        [editBackg_deleButton setBackgroundColor:[UIColor clearColor]];
        [editBackg_deleButton addTarget:self action:@selector(editBackg_deleButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [editBackg addSubview:editBackg_deleButton];
    }
}

-(void)editBackgClick
{
    [self.rootScr setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [editBackg removeFromSuperview];
    editBackg=nil;
}

-(void)editBackg_deleButtonClick
{
    [_delegate tapDeleButton:self.deleButton];
    
    [self.rootScr setContentOffset:CGPointMake(0, 0) animated:NO];
    
    [editBackg removeFromSuperview];
    editBackg=nil;
}

-(void)listScrollvTouchEnd:(id)view touch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_delegate tapRootScr:view];
}


- (IBAction)topButtonClick:(id)sender {
    [_delegate tapTopButton:sender];
}


@end

//
//  GXPriceListTableView.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/13.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceListTableView.h"
#import "GXPriceConst.h"
#import "GXPriceListTableViewCell.h"

@implementation GXPriceListTableView
{
    UIScrollView *titleScroll;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        self.leftTitAr=[[NSMutableArray alloc]init];
        self.rightTitAr=[[NSMutableArray alloc]init];
        
        self.titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), priceList_height_tableviewTitle)];
        self.titleView.backgroundColor=priceList_color_tableViewTitleBackg;
        
        titleScroll=[[UIScrollView alloc]init];
        titleScroll.showsVerticalScrollIndicator=NO;
        titleScroll.showsHorizontalScrollIndicator=NO;
        titleScroll.scrollEnabled=NO;
        [self.titleView addSubview:titleScroll];
        

    }
    return self;
}


-(void)addLeftTitle:(NSString *)tit width:(NSString *)titWidth
{
    [self.leftTitAr setObject:@{@"title":tit,@"width":titWidth} atIndexedSubscript:0];
    
    titleScroll.frame=CGRectMake([titWidth intValue], 0, CGRectGetWidth(self.frame)-[titWidth intValue], priceList_height_tableviewTitle);
    
    UILabel *lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, [titWidth intValue]-15, priceList_height_tableviewTitle)];
    lb_tit.font=GXFONT_PingFangSC_Regular(14);
    lb_tit.textColor=priceList_color_tableViewTitleText;
    lb_tit.text=tit;
    [self.titleView addSubview:lb_tit];
}

-(void)addRightTitleAndTitleWidth:(NSString *)obj,...
{
    va_list params;
    va_start(params, obj);
    NSString *arg;
    
    int width=0;
    
    if (obj) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        
        id prev = obj;
        [dic setObject:prev forKey:@"title"];
        
        int indexa=0;
        while ((arg = va_arg(params, NSString *))) {
            if (arg) {
                if(indexa%2==0)
                {
                    [dic setObject:arg forKey:@"width"];
                    
                    [self.rightTitAr addObject:dic];
                    
                    
                    UILabel *lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(width, 0, [arg intValue], priceList_height_tableviewTitle)];
                    lb_tit.font=GXFONT_PingFangSC_Regular(14);
                    lb_tit.textColor=priceList_color_tableViewTitleText;
                    lb_tit.textAlignment=NSTextAlignmentCenter;
                    lb_tit.text=[dic objectForKey:@"title"];
                    [titleScroll addSubview:lb_tit];
                    
                    
                    width+=[arg intValue];
                }
                else
                {
                    dic=[[NSMutableDictionary alloc]init];
                    [dic setObject:arg forKey:@"title"];
                }
                indexa++;
            }
        }
        va_end(params);
    }
    
    titleScroll.contentSize=CGSizeMake(width, priceList_height_tableviewTitle);
}

@end

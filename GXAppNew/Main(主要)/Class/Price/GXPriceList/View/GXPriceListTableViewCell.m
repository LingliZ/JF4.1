//
//  GXPriceListTableViewCell.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/14.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceListTableViewCell.h"
#import "GXPriceConst.h"
#import "PriceMarketModel.h"
#import "GXPriceListTableView.h"
#import "GXPriceListScrollView.h"

#define tag_rightLb 161214000
#define tag_rightScroll 161214500
@implementation GXPriceListTableViewCell
{
    //列表名字
    UILabel *lb_name;
    //小明子
    UILabel *lb_name_little;
    
    //cell选中背景
    UIImageView *cellSelectBackg;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(GXPriceListTableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Identifier = @"Identifier";
    GXPriceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[GXPriceListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = priceList_color_tableViewBackg;
    
    cell.indexRow=indexPath.row;

    cell.gxtableView=tableView;
    
    return cell;
}

- (void)setMarketModel:(PriceMarketModel *)marketModel {

    if(!cellSelectBackg)
    {
        cellSelectBackg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, priceList_height_tableviewCell)];
        cellSelectBackg.backgroundColor = priceList_color_cellBackg;
        cellSelectBackg.hidden=YES;
        [self.contentView addSubview:cellSelectBackg];
    }
    
    int leftWidth= [[[self.gxtableView.leftTitAr firstObject] objectForKey:@"width"] intValue];
    
    if(!lb_name)
    {
        lb_name=[[UILabel alloc]init];
        lb_name.font = GXFONT_PingFangSC_Regular(15);
        lb_name.textColor = priceList_color_tableViewCellNameText;
        [self.contentView addSubview:lb_name];
    }
    lb_name.text = [NSString stringWithFormat:@"%@",marketModel.name];
    [lb_name sizeToFit];
    lb_name.frame=CGRectMake(15, 0, lb_name.bounds.size.width, priceList_height_tableviewCell);
    
    
    
    
    if(!lb_name_little)
    {
        lb_name_little=[[UILabel alloc]init];
        lb_name_little.font = GXFONT_PingFangSC_Regular(10);
        lb_name_little.textColor = priceList_color_tableViewCellNameTextLittle;
        [self.contentView addSubview:lb_name_little];
    }
    lb_name_little.text =marketModel.shortName;
    [lb_name_little sizeToFit];
    lb_name_little.frame=CGRectMake(lb_name.frame.origin.x + lb_name.frame.size.width+6, 0, leftWidth-lb_name.frame.origin.x - lb_name.frame.size.width-6, priceList_height_tableviewCell);
    
    
    if(!self.rightTableScoll)
    {
        
        self.rightTableScoll=[[GXPriceListScrollView alloc]initWithFrame:CGRectMake(leftWidth, -1, GXScreenWidth-leftWidth, priceList_height_tableviewCell+2)];
        self.rightTableScoll.backgroundColor=[UIColor clearColor];
        self.rightTableScoll.delegate=(id)self;
        self.rightTableScoll.showsVerticalScrollIndicator=NO;
        self.rightTableScoll.showsHorizontalScrollIndicator=NO;
        self.rightTableScoll.delegateCustom=(id)self;
        [self.contentView addSubview:self.rightTableScoll];
        
        int totalWidth=0;
        for (int i=0; i<[self.gxtableView.rightTitAr count]; i++) {
            
            int rightWidth=[[[self.gxtableView.rightTitAr objectAtIndex:i] objectForKey:@"width"] intValue];
            
            
            UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(totalWidth, (priceList_height_tableviewCell-24)/2.0, rightWidth, 24)];
            lb.font = GXFONT_PingFangSC_Regular(18);
            lb.textAlignment=NSTextAlignmentCenter;
            lb.tag=tag_rightLb+i;
            [self.rightTableScoll addSubview:lb];
            
            
            totalWidth+=rightWidth;
            [self.rightTableScoll setContentSize:CGSizeMake(totalWidth, self.rightTableScoll.bounds.size.height)];
        }
    }
    
    //更新tag
    self.rightTableScoll.tag=tag_rightScroll+self.indexRow;
    //更新offset
    [self.rightTableScoll setContentOffset:self.gxtableView.titViewScorllp];
    
    
    for (int i=0; i<[self.gxtableView.rightTitAr count]; i++) {
     
        UILabel *lb=[self viewWithTag:tag_rightLb+i];
        
        switch (i) {
            case 0:
            {
                lb.textColor=marketModel.lastColor;
                lb.text=marketModel.last;
                
                if(marketModel.lastBackgColor)
                lb.backgroundColor=marketModel.lastBackgColor;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    marketModel.lastBackgColor=nil;
                    lb.backgroundColor=[UIColor clearColor];
                });
            }
                break;
            case 1:
            {
                lb.textColor=marketModel.increaseBackColor;
                lb.text=marketModel.increasePercentage;
            }
                break;
            case 2:
            {
                lb.textColor=marketModel.increaseBackColor;
                lb.text=marketModel.increase;
            }
                break;
            case 3:
            {
                lb.textColor=marketModel.highColor;
                lb.text=marketModel.high;
            }
                break;
            case 4:
            {
                lb.textColor=marketModel.lowColor;
                lb.text=marketModel.low;
            }
                break;
            case 5:
            {
                lb.textColor=marketModel.openColor;
                lb.text=marketModel.open;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *ar=[self.gxtableView visibleCells];
    
    for (GXPriceListTableViewCell *cell in ar) {
         [cell.rightTableScoll setContentOffset:CGPointMake(scrollView.contentOffset.x,0)];
    }
    
    UIScrollView *titScroll=[self.gxtableView.titleView subviews][0];
    [titScroll setContentOffset:CGPointMake(scrollView.contentOffset.x,0)];
    
    
    self.gxtableView.titViewScorllp=scrollView.contentOffset;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self listScrollvTouchBegan:touches withEvent:event];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellSelectBackg.hidden=YES;
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"priceListCellScrollTag" object:[NSNumber numberWithInteger:self.indexRow] userInfo:nil];
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self listScrollvTouchCancel:touches withEvent:event];
}
#pragma mark - GXPriceListScrollViewDelegate

-(void)listScrollvTouchBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    cellSelectBackg.hidden=NO;

}
-(void)listScrollvTouchCancel:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellSelectBackg.hidden=YES;
    });
}
-(void)listScrollvTouchEnd:(id)view touch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellSelectBackg.hidden=YES;
    });
    
    GXPriceListScrollView *vvv=view;
    NSInteger t=vvv.tag - tag_rightScroll;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"priceListCellScrollTag" object:[NSNumber numberWithInteger:t] userInfo:nil];
}

@end

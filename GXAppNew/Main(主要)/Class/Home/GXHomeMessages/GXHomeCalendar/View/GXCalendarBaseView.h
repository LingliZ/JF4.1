//
//  GXCalendarBaseView.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXCalendarBaseView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger currentPage; /**<  页码   **/
@property (strong, nonatomic) UIScrollView *topTab; /**<  顶部tab   **/
@property (strong, nonatomic) NSArray *titleArray; /**<  标题   **/
@property (assign, nonatomic) CGFloat titleScale; /**< 标题缩放比例 **/
@property (assign, nonatomic) CGFloat customBottomLinePer; /**<  下划线自定义长度   **/
@property (nonatomic,strong) UIButton *nextPageBtn;
@property (nonatomic,strong) UIButton *previousPageBtn;

/**
 *  Init Method.
 *
 *  @param frame          NinaBaseView frame.
 *  @param selectColor    Toptab button's select color.
 *  @param unselectColor  Toptab button's unselect color.
 *  @param underlineColor Toptab underline color.
 *  @param topTabColor    Toptab background color.
 *  @param topTabNum      Toptab styles.
 *
 */
- (instancetype)initWithFrame:(CGRect)frame WithSelectColor:(UIColor *)selectColor WithUnselectorColor:(UIColor *)unselectColor WithUnderLineColor:(UIColor *)underlineColor WithtopTabColor:(UIColor *)topTabColor WithTopTabType:(NSInteger)topTabNum WithNinaDefaultPageIndex:(NSInteger)ninaDefaultPageIndex;
//带标题字号大小初始化
- (instancetype)initWithFrame:(CGRect)frame WithSelectColor:(UIColor *)selectColor WithUnselectorColor:(UIColor *)unselectColor WithUnderLineColor:(UIColor *)underlineColor WithtopTabColor:(UIColor *)topTabColor WithTopTabType:(NSInteger)topTabNum WithNinaDefaultPageIndex:(NSInteger)ninaDefaultPageIndex WithNinaTitleFontSize:(NSInteger)fontSize;



@end

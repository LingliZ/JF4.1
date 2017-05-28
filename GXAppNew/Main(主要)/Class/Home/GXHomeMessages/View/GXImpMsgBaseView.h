//
//  GXImpMsgBaseView.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXImpMsgBaseView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) NSInteger currentPage; /**<  页码   **/
@property (strong, nonatomic) UIScrollView *topTab; /**<  顶部tab   **/
@property (strong, nonatomic) NSArray *titleArray; /**<  标题   **/
@property (assign, nonatomic) CGFloat titleScale; /**< 标题缩放比例 **/
@property (assign, nonatomic) CGFloat customBottomLinePer; /**<  下划线自定义长度   **/
//标题图片数组
@property (nonatomic,strong) NSArray *selectTitleImgArray;
@property (nonatomic,strong) NSArray *unselectTitleImgArray;





- (instancetype)initWithFrame:(CGRect)frame WithSelectColor:(UIColor *)selectColor WithUnselectorColor:(UIColor *)unselectColor WithUnderLineColor:(UIColor *)underlineColor WithtopTabColor:(UIColor *)topTabColor WithTopTabType:(NSInteger)topTabNum WithNinaDefaultPageIndex:(NSInteger)ninaDefaultPageIndex;
//带标题字号大小初始化
- (instancetype)initWithFrame:(CGRect)frame WithSelectColor:(UIColor *)selectColor WithUnselectorColor:(UIColor *)unselectColor WithUnderLineColor:(UIColor *)underlineColor WithtopTabColor:(UIColor *)topTabColor WithTopTabType:(NSInteger)topTabNum WithNinaDefaultPageIndex:(NSInteger)ninaDefaultPageIndex WithNinaTitleFontSize:(NSInteger)fontSize;
@end

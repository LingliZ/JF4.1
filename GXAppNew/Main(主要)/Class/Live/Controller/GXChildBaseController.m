//
//  GXChildBaseController.m
//  GXAppNew
//
//  Created by maliang on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXChildBaseController.h"
#import "NinaPagerView.h"

@interface GXChildBaseController ()
@property (nonatomic, weak) UIScrollView *scrollerView;
@end

@implementation GXChildBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - KVO监听父视图

- (void)willMoveToParentViewController:(UIViewController *)parent{
    [super willMoveToParentViewController:parent];
    UIView *view = parent.view;
    
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NinaPagerView class]]) {
            if ([view.subviews[0].subviews[0].subviews[1] isKindOfClass:[UIScrollView class]]) {
                if (!self.scrollerView) {
                    UIScrollView *scrollerView = (UIScrollView *)view.subviews[0].subviews[0].subviews[1];
                    [scrollerView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:@"scrollView"];
                    self.scrollerView = scrollerView;
                }
            }
        }
    }];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.scrollerView) {
        [self.scrollerView removeObserver:self forKeyPath:@"contentOffset"];
        self.scrollerView = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self.scrollerView endEditing:YES];
    }
}
@end

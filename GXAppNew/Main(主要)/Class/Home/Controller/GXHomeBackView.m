//
//  GXHomeBackView.m
//  GXAppNew
//
//  Created by zhudong on 2017/1/17.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXHomeBackView.h"

@implementation GXHomeBackView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

@end

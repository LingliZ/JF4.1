//
//  UIView+GXVIewController.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "UIView+GXVIewController.h"

@implementation UIView (GXVIewController)

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }while (next != nil);
    return nil;
}

- (UINavigationController *)navVC{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
        }
        next = next.nextResponder;
    }while (next != nil);
    return nil;
}
@end

//
//  UIView+UIViewController.m
//  Installment
//
//  Created by Apple on 15/11/20.
//  Copyright © 2015年 熊彬. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
    
}

- (UINavigationController *)navigationController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
            
        }
        next = next.nextResponder;
    } while (next);
    return nil;
    
}
- (UITabBarController *)tabBarController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}
@end

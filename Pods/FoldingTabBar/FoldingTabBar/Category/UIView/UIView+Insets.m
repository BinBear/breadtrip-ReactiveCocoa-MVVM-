//
//  UIView+Insets.m
//  FoldingTabBar
//
//  Created by Sergey on 11/22/17.
//  Copyright © 2017 Sergey Butenko. All rights reserved.
//

#import "UIView+Insets.h"

UIEdgeInsets edgeInsets() {
    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
    }
    UIEdgeInsets returnInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")] && isPhoneX) {
        UIEdgeInsets inset = [[keyWindow valueForKeyPath:@"safeAreaInsets"] UIEdgeInsetsValue];
        returnInsets = inset;
    }
    return returnInsets;
}

@implementation UIView (Insets)

-(CGFloat)bottomInset {
    UIEdgeInsets returnInsets = edgeInsets();
    return returnInsets.bottom;
}

@end

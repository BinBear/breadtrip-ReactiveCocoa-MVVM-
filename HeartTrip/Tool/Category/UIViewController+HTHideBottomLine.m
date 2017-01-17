//
//  UIViewController+HTHideBottomLine.m
//  HeartTrip
//
//  Created by 熊彬 on 17/1/17.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "UIViewController+HTHideBottomLine.h"

@implementation UIViewController (HTHideBottomLine)
- (void)HT_hideBottomLineInView:(UIView *)view
{
    UIImageView *navBarLineImageView = [self findLineImageViewUnder:view];
    navBarLineImageView.hidden = YES;
}
- (void)HT_showBottomLineInView:(UIView *)view
{
    UIImageView *navBarLineImageView = [self findLineImageViewUnder:view];
    navBarLineImageView.hidden = NO;
}
- (UIImageView *)findLineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findLineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end

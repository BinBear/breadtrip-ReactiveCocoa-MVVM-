//
//  HTTableView.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/15.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTTableView.h"

@implementation HTTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
    // 移除点击延迟 (since iOS 8)
    UIView *wrapView = self.subviews.firstObject;
    
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                gesture.enabled = NO;
                break;
            }
        }
    }
    
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end

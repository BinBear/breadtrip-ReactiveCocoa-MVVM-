//
//  UIView+Forbearance.m
//  WexWeiCaiFu
//
//  Created by 星星 on 16/8/9.
//  Copyright © 2016年 SinaPay. All rights reserved.
//

#import "UIView+Forbearance.h"

@implementation UIView (Forbearance)

- (UILayoutPriority)horizontalHuggingPriority {
    return [self contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal];
}
- (void)setHorizontalHuggingPriority:(UILayoutPriority)horizontalHuggingPriority {
    [self setContentHuggingPriority:horizontalHuggingPriority forAxis:UILayoutConstraintAxisHorizontal];
}

- (UILayoutPriority)horizontalCompressionResistancePriority {
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal];
}
- (void)setHorizontalCompressionResistancePriority:(UILayoutPriority)horizontalCompressionResistancePriority {
    [self setContentCompressionResistancePriority:horizontalCompressionResistancePriority forAxis:UILayoutConstraintAxisHorizontal];
}

- (UILayoutPriority)verticalHuggingPriority {
    return [self contentHuggingPriorityForAxis:(UILayoutConstraintAxisVertical)];
}
- (void)setVerticalHuggingPriority:(UILayoutPriority)verticalHuggingPriority {
    [self setContentHuggingPriority:verticalHuggingPriority forAxis:UILayoutConstraintAxisVertical];
}

- (UILayoutPriority)verticalCompressionResistancePriority {
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical];
}
- (void)setVerticalCompressionResistancePriority:(UILayoutPriority)verticalCompressionResistancePriority {
    [self setContentCompressionResistancePriority:verticalCompressionResistancePriority forAxis:UILayoutConstraintAxisVertical];
}

@end

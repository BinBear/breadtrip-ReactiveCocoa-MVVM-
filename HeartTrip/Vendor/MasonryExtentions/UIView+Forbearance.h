//
//  UIView+Forbearance.h
//  WexWeiCaiFu
//
//  Created by 星星 on 16/8/9.
//  Copyright © 2016年 SinaPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Forbearance)

@property (nonatomic, assign) UILayoutPriority horizontalHuggingPriority;
@property (nonatomic, assign) UILayoutPriority horizontalCompressionResistancePriority;
@property (nonatomic, assign) UILayoutPriority verticalHuggingPriority;
@property (nonatomic, assign) UILayoutPriority verticalCompressionResistancePriority;

@end

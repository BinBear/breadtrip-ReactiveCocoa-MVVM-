//
//  UISearchBar+HTAdd.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/28.
//  Copyright © 2016年 BinBear. All rights reserved.
//


#import "UISearchBar+HTAdd.h"

#define IS_IOS9 [[UIDevice currentDevice].systemVersion doubleValue] >= 9

@implementation UISearchBar (HTAdd)
- (void)HT_setTextFont:(UIFont *)font {
    if (IS_IOS9) {
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].font = font;
    }else {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:font];
    }
}

- (void)HT_setTextColor:(UIColor *)textColor {
    if (IS_IOS9) {
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].textColor = textColor;
    }else {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:textColor];
    }
}

- (void)HT_setCancelButtonTitle:(NSString *)title {
    if (IS_IOS9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:title];
    }
}

- (void)HT_setCancelButtonFont:(UIFont *)font {
    NSDictionary *textAttr = @{NSFontAttributeName : font};
    if (IS_IOS9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    }
}
@end

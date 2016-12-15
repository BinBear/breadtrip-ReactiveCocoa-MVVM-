//
//  HTCustomTabBarButton.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTCustomTabBarButton.h"
#import "HTCustomTabBarController.h"


CGFloat HTCustomButtonWidth = 0.0f;
UIButton<HTCustomTabBarButtonDelegate> *HTExternCustomButton = nil;
UIViewController *HTCustomChildViewController = nil;

@implementation HTCustomTabBarButton

+ (void)registerSubclass
{
    if (![self conformsToProtocol:@protocol(HTCustomTabBarButtonDelegate)]) {
        return;
    }
    Class<HTCustomTabBarButtonDelegate> class = self;
    UIButton<HTCustomTabBarButtonDelegate> *customButton = [class customButton];
    HTExternCustomButton = customButton;
    HTCustomButtonWidth = customButton.frame.size.width;
    if ([[self class] respondsToSelector:@selector(customChildViewController)]) {
        HTCustomChildViewController = [class customChildViewController];
        [[self class] addSelectViewControllerTarget:customButton];
        if ([[self class] respondsToSelector:@selector(indexOfCustomButtonInTabBar)]) {
            HTCustomButtonIndex = [[self class] indexOfCustomButtonInTabBar];
        } else {
            [NSException raise:@"HTCustomTabBarController" format:@"如果想使用customChildViewController样式，必须同时在自定义的customButton中实现 `+indexOfCustomButtonInTabBar`，来指定customButton的位置"];
        }
    }
    
}
+ (void)addSelectViewControllerTarget:(UIButton<HTCustomTabBarButtonDelegate> *)customButton {
    id target = self;
    NSArray<NSString *> *selectorNamesArray = [customButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    if (selectorNamesArray.count == 0) {
        target = customButton;
        selectorNamesArray = [customButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    }
    [selectorNamesArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL selector =  NSSelectorFromString(obj);
        [customButton removeTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }];
    [customButton addTarget:customButton action:@selector(customChildViewControllerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)customChildViewControllerButtonClicked:(UIButton<HTCustomTabBarButtonDelegate> *)sender
{
    sender.selected = YES;
    [self HT_tabBarController].selectedIndex = HTCustomButtonIndex;
}

@end

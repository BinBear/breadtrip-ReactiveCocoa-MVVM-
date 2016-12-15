//
//  HTCustomTabBarButton.h
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTCustomTabBar,HTCustomTabBarButton;

@protocol HTCustomTabBarButtonDelegate 

@required
/**
 *  自定义按钮
 *
 */
+ (id)customButton;

@optional
/*!
 用来自定义加号按钮的位置，如果不实现默认居中，但是如果 tabbar 的个数是奇数则必须实现该方法，否则 HTTabBarController 会抛出 exception 来进行提示。
 
 @return CGFloat 用来自定义加号按钮在tabbar中的位置
 *
 */
+ (NSUInteger)indexOfCustomButtonInTabBar;

/*!
 调整自定义按钮中心点Y轴方向的位置，在按钮超出了 tabbar 的边界时实现该方法。
 
 @return CGFloat 返回值是自定义按钮中心点Y轴方向的坐标除以 tabbar 的高度，如果不实现，会自动进行比对，预设一个较为合适的位置，如果实现了该方法，预设的逻辑将失效。
 *
 */
+ (CGFloat)multiplerInCenterY;

/*!
 实现该方法后，能让 customButton 的点击效果与跟点击其他 UITabBarButton 效果一样，跳转到该方法指定的 UIViewController 。
 @attention 必须同时实现 `+indexOfCustomButtonInTabBar` 来指定 customButton 的位置。
 @return UIViewController 指定 customButton 点击后跳转的 UIViewController。
 *
 */
+ (UIViewController *)customChildViewController;

@end

@interface HTCustomTabBarButton : UIButton
FOUNDATION_EXTERN UIButton<HTCustomTabBarButtonDelegate> *HTExternCustomButton;
FOUNDATION_EXTERN UIViewController *HTCustomChildViewController;

/**
 *  在load方法里面调用，注册自定义的按钮
 */
+ (void)registerSubclass;

/**
 *  如果想按钮跟其他item一样跳转，实现该方法
 *
 */
- (void)customChildViewControllerButtonClicked:(UIButton<HTCustomTabBarButtonDelegate> *)sender;
@end

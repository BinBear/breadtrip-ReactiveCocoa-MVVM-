//
//  HTCustomTabBarController.h
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const HTTabBarItemTitle;
FOUNDATION_EXTERN NSString *const HTTabBarItemImage;
FOUNDATION_EXTERN NSString *const HTTabBarItemSelectedImage;
FOUNDATION_EXTERN NSString *const HTTabBarItemWidthDidChangeNotification;
FOUNDATION_EXTERN NSUInteger HTTabbarItemsCount;
FOUNDATION_EXTERN NSUInteger HTCustomButtonIndex;
FOUNDATION_EXTERN CGFloat HTCustomButtonWidth;
FOUNDATION_EXTERN CGFloat HTTabBarItemWidth;

@interface HTCustomTabBarController : UITabBarController

/*!
 *  显示在tabBarController上面的子控制器数组
 */
@property (nonatomic, readwrite, strong) NSArray<UIViewController *> *tarBarViewControllers;

/*!
 *  tabBarItem的属性数组
 */
@property (nonatomic, readwrite, strong) NSArray<NSDictionary *> *tabBarItemsAttributes;

/*!
 *  自定义tabar的高度
 */
@property (nonatomic, assign) CGFloat tabBarHeight;

/*!
 *  设置tabbar中图片的位置. 默认是UIEdgeInsetsZero.
 */
@property (nonatomic, readwrite, assign) UIEdgeInsets                   imageInsets;

/*!
 *  设置tabbar中文字的位置
 *
 */
@property (nonatomic, readwrite, assign) UIOffset                       titlePositionAdjustment;

/*!
 *  是否加了中间的按钮
 */
+ (BOOL)haveCustomButton;

/*!
 *  tabBar上面所有的item的数量
 */
+ (NSUInteger)allItemsInTabBarCount;

/*!
 *  返回appDelegate对象
 *
 */
- (id<UIApplicationDelegate>)appDelegate;

/*!
 *  返回当前根窗口
 *
 */
- (UIWindow *)rootWindow;

// 初始化tabBarController
- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;

@end

@interface NSObject (HTCustomTabBarController)

/**
 *  如果self为UIViewController的时候，返回tabBarController控制器上最顶的控制器
 *  如果self不为UIViewController的时候，返回rootViewController（设置了HTCustomTabBarViewController才是），否则返回nil
 */
@property (nonatomic, readonly, strong) HTCustomTabBarController *HT_tabBarController;

@end

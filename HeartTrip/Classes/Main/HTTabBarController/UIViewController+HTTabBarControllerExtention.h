//
//  UIViewController+HTTabBarControllerExtention.h
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HTPopSelectTabBarChildViewControllerCompletion)(__kindof UIViewController *selectedTabBarChildViewController);

@interface UIViewController (HTTabBarControllerExtention)

/*
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 * @param index  需要选择的控制器在 `TabBar` 中的 index。
 * @return       最终被选择的控制器。
 */
- (UIViewController *)HT_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index;

/*
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器在 `Block` 回调中返回。
 * @param index 需要选择的控制器在 `TabBar` 中的 index。
 */
- (void)HT_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                           completion:(HTPopSelectTabBarChildViewControllerCompletion)completion;

/*
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 * @param classType 需要选择的控制器所属的类。
 * @return          最终被选择的控制器。
 */
- (UIViewController *)HT_popSelectTabBarChildViewControllerForClassType:(Class)classType;

/*
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器在 `Block` 回调中返回。
 * @param classType 需要选择的控制器所属的类。
 */
- (void)HT_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                                completion:(HTPopSelectTabBarChildViewControllerCompletion)completion;

@end

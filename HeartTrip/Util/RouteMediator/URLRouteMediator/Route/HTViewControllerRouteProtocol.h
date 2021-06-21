//
//  HTViewControllerRouteProtocol.h
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HTViewControllerProtocol;
@protocol HTViewControllerRouteProtocol <NSObject>

@optional

#pragma mark - Push
/// Push
/// @param controllerName 控制器名称
/// @param viewModelName viewModel名称
/// @param parameter viewModel参数
/// @param flag 是否需要动画
+ (void)pushViewControllerWithName:(NSString *_Nullable)controllerName
                     viewModelName:(NSString *_Nullable)viewModelName
                         parameter:(id _Nullable)parameter
                          animated:(BOOL)flag;
/// Push 远程路由
/// @param url 远程路由URL
+ (void)pushViewControllerWithURL:(NSString *_Nullable)url;


#pragma mark - Present
/// Present
/// @param controllerName present控制器
/// @param viewModelName viewModel名称
/// @param parameter viewModel参数
/// @param navController 导航控制器，如果为 nil 则不需要导航控制器
/// @param flag 是否需要动画
+ (void)presentViewControllerWithName:(NSString *_Nullable)controllerName
                        viewModelName:(NSString * _Nullable)viewModelName
                            parameter:(id _Nullable)parameter
                        navController:(Class  _Nullable)navController
                             animated:(BOOL)flag;
/// Present 远程路由
/// @param url 远程路由URL
+ (void)presentViewControllerWithURL:(NSString *_Nullable)url;


#pragma mark - Pop
/// Pop
/// @param viewController pop目标控制器
/// @param parameter 回传参数
/// @param flag 是否需要动画
+ (void)popViewController:(UIViewController<HTViewControllerProtocol> *)viewController
                parameter:(id _Nullable)parameter
                 animated:(BOOL)flag;

/// Pop
/// @param controllerName pop目标控制器名称
/// @param parameter 回传参数
/// @param flag 是否需要动画
+ (void)popViewControllerWithName:(NSString * _Nullable)controllerName
                        parameter:(id _Nullable)parameter
                         animated:(BOOL)flag;

/// Pop
/// @param fromIndex pop栈底的控制器下标
/// @param parameter 回传参数
/// @param flag 是否需要动画
+ (void)popViewControllerWithFromIndex:(NSInteger)fromIndex
                             parameter:(id _Nullable)parameter
                              animated:(BOOL)flag;

/// Pop
/// @param ToIndex pop栈顶的控制器下标
/// @param parameter 回传参数
/// @param flag 是否需要动画
+ (void)popViewControllerWithToIndex:(NSInteger)toIndex
                           parameter:(id _Nullable)parameter
                            animated:(BOOL)flag;
/// Pop 远程路由
/// @param url 远程路由URL
+ (void)popViewControllerWithURL:(NSString *_Nullable)url;

#pragma mark - Dismiss
/// Dismiss
/// @param parameter 回传数据
/// @param flag 是否需要动画
/// @param completion Dismiss完成回调
+ (void)dismissViewControllerWithParameter:(id _Nullable)parameter
                                  animated:(BOOL)flag
                                completion:(void(^_Nullable)(void))completion;
/// Dismiss 远程路由
/// @param url 远程路由URL
+ (void)dismissViewControllerWithURL:(NSString *_Nullable)url;

@end

NS_ASSUME_NONNULL_END

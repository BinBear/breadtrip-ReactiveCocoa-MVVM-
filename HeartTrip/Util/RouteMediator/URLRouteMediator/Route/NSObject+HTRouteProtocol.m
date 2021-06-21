//
//  NSObject+HTRouteProtocol.m
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "NSObject+HTRouteProtocol.h"
#import "HTViewControllerProtocol.h"
#import "HTBaseViewController.h"
#import "HTURLRouteAction.h"
#import "HTURLRouteParser.h"

@implementation NSObject (HTRouteProtocol)

#pragma mark - Push
/// Push
/// @param controllerName 控制器名称
/// @param viewModelName viewModel名称
/// @param parameter viewModel参数
/// @param flag 是否需要动画
+ (void)pushViewControllerWithName:(NSString *_Nullable)controllerName
                     viewModelName:(NSString *_Nullable)viewModelName
                         parameter:(id _Nullable)parameter
                          animated:(BOOL)flag {
    Class controllerClass = nil;
    if (!controllerName.length) {
        controllerClass = [self ht_createDifferClass];
    } else {
        const char *controllerNameChar = [controllerName cStringUsingEncoding:NSASCIIStringEncoding];
        controllerClass = objc_getClass(controllerNameChar);
        if (!controllerClass) {
            objc_registerClassPair(objc_allocateClassPair(HTBaseViewController.class, controllerNameChar, 0));
            controllerClass = objc_getClass(controllerNameChar);
        }
    }
    
    UIViewController<HTViewControllerProtocol> *controller = [controllerClass viewControllerWithViewModelName:viewModelName parameter:parameter];
    UIViewController *currentController = UIViewController.vv_currentViewController;
    
    [currentController.navigationController pushViewController:controller animated:flag];
}
/// Push 远程路由
/// @param url 远程路由URL
+ (void)pushViewControllerWithURL:(NSString *_Nullable)url {
    
    if (![url isKindOfClass:NSString.class] || ![url isNotBlank]) {
        UIViewController *currentController = UIViewController.vv_currentViewController;
        [currentController.navigationController pushViewController:[self ht_createDifferVC] animated:true];
        return;
    }
    HTURLRouteParser *urlParser = [HTURLRouteParser urlRoutePaeserWithURL:url];
    if (urlParser.isRouteURL) {
        [self pushViewControllerWithName:urlParser.ctrName
                           viewModelName:urlParser.vmName
                               parameter:urlParser.parameter
                                animated:true];
    }
}


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
                        navController:(Class _Nullable)navController
                             animated:(BOOL)flag {
    Class controllerClass = nil;
    if (!controllerName.length) {
        controllerClass = [self ht_createDifferClass];
    } else {
        const char *controllerNameChar = [controllerName cStringUsingEncoding:NSASCIIStringEncoding];
        controllerClass = objc_getClass(controllerNameChar);
        if (!controllerClass) {
            objc_registerClassPair(objc_allocateClassPair(HTBaseViewController.class, controllerNameChar, 0));
            controllerClass = objc_getClass(controllerNameChar);
        }
    }
    
    UIViewController<HTViewControllerProtocol> *controller = [controllerClass viewControllerWithViewModelName:viewModelName parameter:parameter];
    UIViewController *currentController = UIViewController.vv_currentViewController;
    if (navController && [navController isKindOfClass:UINavigationController.class]) {
        UINavigationController *nav = [[navController alloc] initWithRootViewController:controller];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [currentController presentViewController:nav animated:flag completion:nil];
    }else{
        [currentController presentViewController:controller animated:flag completion:nil];
    }
}
/// Present 远程路由
/// @param url 远程路由URL
+ (void)presentViewControllerWithURL:(NSString *_Nullable)url {
    
    if (![url isKindOfClass:NSString.class] || ![url isNotBlank]) {
        UIViewController *currentController = UIViewController.vv_currentViewController;
        [currentController presentViewController:[self ht_createDifferVC] animated:true completion:nil];
        return;
    }
    HTURLRouteParser *urlParser = [HTURLRouteParser urlRoutePaeserWithURL:url];
    if (urlParser.isRouteURL) {
        [self presentViewControllerWithName:urlParser.ctrName
                              viewModelName:urlParser.vmName
                                  parameter:urlParser.parameter
                              navController:nil
                                   animated:true];
    }
}


#pragma mark - Pop
/// Pop
/// @param viewController pop目标控制器
/// @param parameter 回传参数
/// @param flag 是否需要动画
+ (void)popViewController:(UIViewController<HTViewControllerProtocol> *)viewController
                parameter:(id _Nullable)parameter
                 animated:(BOOL)flag {
    UIViewController<HTViewControllerProtocol> *currentController = (UIViewController<HTViewControllerProtocol> *)UIViewController.vv_currentViewController;
    NSString *controllerName = NSStringFromClass(currentController.class);
    if (ht_ProtocolAndSelector(viewController, @protocol(HTViewControllerProtocol), @selector(popFromViewController:parameter:))) {
        [viewController popFromViewController:controllerName parameter:parameter];
    }
    [currentController.navigationController popToViewController:viewController animated:flag];
}

/// Pop
/// @param controllerName pop目标控制器名称
/// @param parameter 回传参数
/// @param flag 是否需要动画
+ (void)popViewControllerWithName:(NSString * _Nullable)controllerName
                        parameter:(id _Nullable)parameter
                         animated:(BOOL)flag {
    UIViewController<HTViewControllerProtocol> *currentController = (UIViewController<HTViewControllerProtocol> *)UIViewController.vv_currentViewController;
    UIViewController<HTViewControllerProtocol> *popController = (UIViewController<HTViewControllerProtocol> *)([currentController.navigationController vv_viewControllerToIndex:1]);
    if (controllerName.length) {
        popController = (UIViewController<HTViewControllerProtocol> *)([currentController.navigationController vv_viewControllerWithName:controllerName]);
    }
    [self popViewController:popController parameter:parameter animated:flag];
}

/// Pop
/// @param fromIndex pop栈底的控制器下标
/// @param parameter 回传参数
/// @param flag 是否需要动画
+ (void)popViewControllerWithFromIndex:(NSInteger)fromIndex
                             parameter:(id _Nullable)parameter
                              animated:(BOOL)flag {
    UIViewController<HTViewControllerProtocol> *currentController = (UIViewController<HTViewControllerProtocol> *)UIViewController.vv_currentViewController;
    UIViewController<HTViewControllerProtocol> *popController = (UIViewController<HTViewControllerProtocol> *)([currentController.navigationController vv_viewControllerFromIndex:fromIndex]);
    [self popViewController:popController parameter:parameter animated:flag];
}

/// Pop
/// @param ToIndex pop栈顶的控制器下标
/// @param parameter 回传参数
/// @param flag 是否需要动画
+ (void)popViewControllerWithToIndex:(NSInteger)toIndex
                           parameter:(id _Nullable)parameter
                            animated:(BOOL)flag {
    UIViewController<HTViewControllerProtocol> *currentController = (UIViewController<HTViewControllerProtocol> *)UIViewController.vv_currentViewController;
    UIViewController<HTViewControllerProtocol> *popController = (UIViewController<HTViewControllerProtocol> *)([currentController.navigationController vv_viewControllerToIndex:toIndex]);
    [self popViewController:popController parameter:parameter animated:flag];
}

/// Pop 远程路由
/// @param url 远程路由URL
+ (void)popViewControllerWithURL:(NSString *_Nullable)url {
    if (![url isKindOfClass:NSString.class] || ![url isNotBlank]) {
        UIViewController *currentController = UIViewController.vv_currentViewController;
        [currentController.navigationController popToViewController:[self ht_createDifferVC] animated:true];
        return;
    }
    HTURLRouteParser *urlParser = [HTURLRouteParser urlRoutePaeserWithURL:url];
    if (urlParser.isRouteURL) {
        [self popViewControllerWithName:urlParser.ctrName
                              parameter:urlParser.parameter
                               animated:true];
    }
}


#pragma mark - Dismiss
/// Dismiss
/// @param parameter 回传数据
/// @param flag 是否需要动画
/// @param completion Dismiss完成回调
+ (void)dismissViewControllerWithParameter:(id _Nullable)parameter
                                  animated:(BOOL)flag
                                completion:(void(^_Nullable)(void))completion {
    UIViewController<HTViewControllerProtocol> *currentController = (UIViewController<HTViewControllerProtocol> *)UIViewController.vv_currentViewController;
    NSString *controllerName = NSStringFromClass(currentController.class);
    UIViewController<HTViewControllerProtocol> *presentedViewController = (UIViewController<HTViewControllerProtocol> *)currentController.presentedViewController;
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (presentedViewController) {
        __block void(^block)(void) = completion;
        @weakify(presentedViewController);
        [currentController dismissViewControllerAnimated:flag completion:^{
            @strongify(presentedViewController);
            if (ht_ProtocolAndSelector(presentedViewController, @protocol(HTViewControllerProtocol), @selector(dismissFromViewController:parameter:))) {
                [presentedViewController dismissFromViewController:controllerName parameter:parameter];
            }
            !block ?: block();
            block = NULL;
        }];
    }else{
        [rootVC dismissViewControllerAnimated:flag completion:completion];
    }
}
/// Dismiss 远程路由
/// @param url 远程路由URL
+ (void)dismissViewControllerWithURL:(NSString *_Nullable)url {
    
    if (![url isKindOfClass:NSString.class] || ![url isNotBlank]) {
        UIViewController *currentController = UIViewController.vv_currentViewController;
        [currentController dismissViewControllerAnimated:[self ht_createDifferVC] completion:nil];
        return;
    }
    HTURLRouteParser *urlParser = [HTURLRouteParser urlRoutePaeserWithURL:url];
    if (urlParser.isRouteURL) {
        [self dismissViewControllerWithParameter:urlParser.parameter
                                        animated:true
                                      completion:nil];
    }
}


#pragma mark - Method
+ (Class)ht_createDifferClass {
    
    NSString *perNameString = @"HTBaseViewController";
    NSString *customClassName = [NSString stringWithFormat:@"%@_%u",perNameString, arc4random()%1000000];
    const char *className = [customClassName cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        objc_registerClassPair(objc_allocateClassPair(HTBaseViewController.class, className, 0));
        return objc_getClass(className);
    }
    return [self ht_createDifferClass];
}
+ (UIViewController<HTViewControllerProtocol> *)ht_createDifferVC {
    UIViewController<HTViewControllerProtocol> *controller = [[self ht_createDifferClass] viewControllerWithViewModelName:nil parameter:nil];
    return controller;
}
@end

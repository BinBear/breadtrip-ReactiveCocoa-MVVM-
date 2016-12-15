//
//  UIViewController+HTTabBarControllerExtention.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "UIViewController+HTTabBarControllerExtention.h"
#import "HTCustomTabBarController.h"

@implementation UIViewController (HTTabBarControllerExtention)

- (UIViewController *)HT_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index {
    [self checkTabBarChildControllerValidityAtIndex:index];
    [self.navigationController popToRootViewControllerAnimated:NO];
    HTCustomTabBarController *tabBarController = [self HT_tabBarController];
    tabBarController.selectedIndex = index;
    UIViewController *selectedTabBarChildViewController = tabBarController.selectedViewController;
    BOOL isNavigationController = [[selectedTabBarChildViewController class] isSubclassOfClass:[UINavigationController class]];
    if (isNavigationController) {
        return ((UINavigationController *)selectedTabBarChildViewController).viewControllers[0];
    }
    return selectedTabBarChildViewController;
}

- (void)HT_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                           completion:(HTPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self HT_popSelectTabBarChildViewControllerAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}

- (UIViewController *)HT_popSelectTabBarChildViewControllerForClassType:(Class)classType {
    HTCustomTabBarController *tabBarController = [self HT_tabBarController];
    __block NSInteger atIndex = NSNotFound;
    [tabBarController.viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id obj_ = nil;
        BOOL isNavigationController = [[tabBarController.viewControllers[idx] class] isSubclassOfClass:[UINavigationController class]];
        if (isNavigationController) {
            obj_ = ((UINavigationController *)obj).viewControllers[0];
        } else {
            obj_ = obj;
        }
        if ([obj_ isKindOfClass:classType]) {
            atIndex = idx;
            *stop = YES;
            return;
        }
    }];
    
    return [self HT_popSelectTabBarChildViewControllerAtIndex:atIndex];
}

- (void)HT_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                                completion:(HTPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self HT_popSelectTabBarChildViewControllerForClassType:classType];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}

- (void)checkTabBarChildControllerValidityAtIndex:(NSUInteger)index {
    HTCustomTabBarController *tabBarController = [self HT_tabBarController];
    @try {
        UIViewController *viewController;
        viewController = tabBarController.viewControllers[index];
    } @catch (NSException *exception) {
        NSString *formatString = @"\n\n\
        ------ BEGIN NSException Log ---------------------------------------------------------------------\n \
        class name: %@                                                                                    \n \
        ------line: %@                                                                                    \n \
        ----reason: 使用pop回去的方法不是HTCustomTabBarController的item控制器 \n \
        ------ END ---------------------------------------------------------------------------------------\n\n";
        NSString *reason = [NSString stringWithFormat:formatString,
                            @(__PRETTY_FUNCTION__),
                            @(__LINE__)];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
    }
}

@end

//
//  HTMediatorAction.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/9.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTMediatorAction.h"
#import "VKURLAction.h"

@implementation HTMediatorAction

#pragma mark - Public Methods
+ (instancetype)sharedInstance
{
    static HTMediatorAction *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[HTMediatorAction alloc] init];
    });
    return mediator;
}

- (void)performActionWithUrl:(NSString *)url animated:(BOOL)animated
{
    id vc = [[VKURLAction sharedInstance] doActionWithUrlString:url];
    UIViewController *currentVC = [self currentViewController];
    if ([vc isKindOfClass:[UIViewController class]]) {
        [currentVC.navigationController pushViewController:vc animated:animated];
    }
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName
{
    /*
     这里只返回当前控制器，具体的route由相应的分类实现
     */
    UIViewController *currentVC = [self currentViewController];
    
    return currentVC;
}
#pragma mark - Private Methods
// 获取当前控制器
-(UIViewController *)currentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    
    return currVC;
}
@end

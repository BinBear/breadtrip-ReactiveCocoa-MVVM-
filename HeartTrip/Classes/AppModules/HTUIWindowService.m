//
//  HTUIWindowService.m
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTUIWindowService.h"
#import "HTFoldingTabBarControllerConfig.h"

QTAppModuleRegister(HTUIWindowService, QTAppEventPriorityDefault)

@interface HTUIWindowService ()<QTAppModule>
@end


@implementation HTUIWindowService
#pragma mark - QTAppModule
+ (instancetype)sharedData{
    static HTUIWindowService *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[HTUIWindowService alloc] init];
        [_shared initConfig];
    });
    return _shared;
}
+ (id<QTAppModule>)moduleInstance{
    return [HTUIWindowService sharedData];
}

- (void)appDidFinishLaunch:(QTAppDidLaunchEvent *)event{
    // 配置Window
    [self configBaseWindow:event];
    // 设置跟控制器
    [self setRootViewController:event];
}
#pragma mark - Config
- (void)initConfig{
    
}
- (void)configBaseWindow:(QTAppDidLaunchEvent *)event{

    HT_APPDelegate.window = [[UIWindow alloc] init];
    HT_APPDelegate.window.frame = [UIScreen mainScreen].bounds;
    [HT_APPDelegate.window makeKeyAndVisible];
}

- (void)setRootViewController:(QTAppDidLaunchEvent *)event{
    
    HTFoldingTabBarControllerConfig *tabBarControllerConfig = [[HTFoldingTabBarControllerConfig alloc] init];
    [HT_APPDelegate.window setRootViewController:tabBarControllerConfig.flodingTabBarController];
}
@end

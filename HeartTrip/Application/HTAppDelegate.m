//
//  HTAppDelegate.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTAppDelegate.h"
#import "HTTabBarControllerConfig.h"
#import "HTServerConfig.h"
#import <IQKeyboardManager.h>
#import "HTLBSManager.h"

@interface HTAppDelegate ()<HTLBSManagerDelegate>
@property (strong, nonatomic) HTLBSManager *lbs;
@end

@implementation HTAppDelegate
#pragma mark -
#pragma mark - Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 设置跟控制器
    [self setRootController];
    // 设置服务器环境
    [HTServerConfig setHTConfigEnv:@"01"];
    // 配置IQKeyboardManager
    [self configurationIQKeyboard];
    // 获取定位信息
    self.lbs = [HTLBSManager startGetLBSWithDelegate:self];
    
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

#pragma mark -
#pragma mark - Private Methods
//// 配置Scheme和Host
//- (void)configurationAppSchemeAndHost
//{
//    [VKURLAction setupScheme:@"HeartTrip" andHost:@"NativeOpenUrl"];
//    [VKURLAction enableSignCheck:@"BinBear"];
//}
// 设置根控制器
- (void)setRootController
{
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    HTTabBarControllerConfig *tabBarControllerConfig = [[HTTabBarControllerConfig alloc] init];
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [self.window makeKeyAndVisible];
}
// 配置IQKeyboardManager
- (void)configurationIQKeyboard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}
@end

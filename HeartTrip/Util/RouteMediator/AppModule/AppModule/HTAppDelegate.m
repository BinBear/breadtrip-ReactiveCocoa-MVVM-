//
//  HTAppDelegate.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTAppDelegate.h"
#import "QTAppEvents.h"
#import "QTEventBus.h"
#import "QTAppModuleManager.h"

#ifndef __IPHONE_12_0
#define __IPHONE_12_0 120000
#endif

#define __LIFE_CIRCLE_IMPLEMENT(_name_) QTAppLifeCircleEvent * event = [[QTAppLifeCircleEvent alloc] init];\
    event.type = QTAppLifeCircleEvent._name_;\
    [self _sendEvent:event sel:@selector(appLifeCircleChanged:)];


@interface HTAppDelegate ()
@end

@implementation HTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    QTAppDidLaunchEvent * event = [[QTAppDidLaunchEvent alloc] init];
    event.launchOptions = launchOptions;
    [self _sendEvent:event sel:@selector(appDidFinishLaunch:)];
    QTAppAllModuleInitEvent * initEvent = [[QTAppAllModuleInitEvent alloc] init];
    [self _sendEvent:initEvent sel:@selector(appAllModuleInit:)];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    __LIFE_CIRCLE_IMPLEMENT(didBecomeActive);
}

- (void)applicationWillResignActive:(UIApplication *)application{
    __LIFE_CIRCLE_IMPLEMENT(willResignActive);
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    __LIFE_CIRCLE_IMPLEMENT(willEnterForeground);
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    __LIFE_CIRCLE_IMPLEMENT(didEnterBackground);
}

- (void)applicationWillTerminate:(UIApplication *)application{
    __LIFE_CIRCLE_IMPLEMENT(willTerminate);
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application{
    QTAppProtectedDataEvent * event = [[QTAppProtectedDataEvent alloc] init];
    event.type = QTAppProtectedDataEvent.didBecomeAvailable;
    [self _sendEvent:event sel:@selector(appProtectedDataChanged:)];
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application{
    QTAppProtectedDataEvent * event = [[QTAppProtectedDataEvent alloc] init];
    event.type = QTAppProtectedDataEvent.willBecomeUnavailable;
    [self _sendEvent:event sel:@selector(appProtectedDataChanged:)];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    QTAppDidReceiveMemoryWarningEvent * event = [[QTAppDidReceiveMemoryWarningEvent alloc] init];
    [self _sendEvent:event sel:@selector(appDidReceiveMemoryWarningEvent:)];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application{
    QTAppSignificantTimeChangeEvent * event = [[QTAppSignificantTimeChangeEvent alloc] init];
    [self _sendEvent:event sel:@selector(appSignificantTimeChange:)];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
    QTAppHandleBackgroundSessionEvent *event = [[QTAppHandleBackgroundSessionEvent alloc] init];
    event.identifier = identifier;
    event.completionHander = completionHandler;
    [self _sendEvent:event sel:@selector(appHandleBackgroundSession:)];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    QTAppDidRegisterRemoteNotificationEvent * event = [[QTAppDidRegisterRemoteNotificationEvent alloc] init];
    event.deviceToken = deviceToken;
    [self _sendEvent:event sel:@selector(appDidRegisterRemoteNotification:)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    QTAppDidRegisterRemoteNotificationEvent * event = [[QTAppDidRegisterRemoteNotificationEvent alloc] init];
    event.error = error;
    [self _sendEvent:event sel:@selector(appDidRegisterRemoteNotification:)];
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType{
    QTAppWillContinueUserActivityEvent * event = [[QTAppWillContinueUserActivityEvent alloc] init];
    event.userActivityType = userActivityType;
    [self _sendEvent:event sel:@selector(appWillContinueUserActivity:)];
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_12_0
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
#else
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler{
#endif
    QTAppContinueUserActivityEvent * event = [[QTAppContinueUserActivityEvent alloc] init];
    event.userActivity = userActivity;
    event.restorationHandler = restorationHandler;
    [self _sendEvent:event sel:@selector(appContinueUserActivity:)];
    return YES;
}

- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity{
    QTAppDidUpdateUserActivityEvent * event = [[QTAppDidUpdateUserActivityEvent alloc] init];
    event.userActivity = userActivity;
    [self _sendEvent:event sel:@selector(appDidUpdateUserActivity:)];
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error{
    QTAppDidFailToContinueUserActivityEvent * event = [[QTAppDidFailToContinueUserActivityEvent alloc] init];
    event.userActivityType = userActivityType;
    event.error = error;
    [self _sendEvent:event sel:@selector(appDidFailToContinueUserActivity:)];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler API_AVAILABLE(ios(9.0)){
    QTAppPerformActionForShortcutItemEvent * event = [[QTAppPerformActionForShortcutItemEvent alloc] init];
    event.shortcutItem = shortcutItem;
    event.completionHandler = completionHandler;
    [self _sendEvent:event sel:@selector(appPerformActionForShortcutItem:)];
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary * _Nullable))reply API_AVAILABLE(ios(8.2)){
    QTAppHandleWatchKitExtensionRequestEvent * event = [[QTAppHandleWatchKitExtensionRequestEvent alloc] init];
    event.userInfo = userInfo;
    event.reply = reply;
    [self _sendEvent:event sel:@selector(appHandleWatchKitExtensionRequest:)];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options NS_AVAILABLE_IOS(9_0){
    QTAppOpenURLEvent * event = [[QTAppOpenURLEvent alloc] init];
    event.url = url;
    event.options = options;
    [self _sendEvent:event sel:@selector(appOpenURL:)];
    return YES;
}

- (void)application:(UIApplication *)application handleIntent:(INIntent *)intent completionHandler:(void (^)(INIntentResponse * _Nonnull))completionHandler API_AVAILABLE(ios(10.0)){
    QTAppHandleIntentEvent * event = [[QTAppHandleIntentEvent alloc] init];
    event.intent = intent;
    event.completionHandler = completionHandler;
    [self _sendEvent:event sel:@selector(appHandleIntent:)];
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    // 禁止第三方键盘
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
            return NO;
    }
    return YES;
}
    
#pragma mark  - Private

- (void)_sendEvent:(id<QTEvent>)event sel:(SEL)sel{
    [[QTAppModuleManager shared] enumerateModulesUsingBlock:^(__unsafe_unretained Class<QTAppModule> module) {
        id<QTAppModule> instance = [module moduleInstance];
        if ([instance respondsToSelector:sel]) {
            CFTimeInterval beginTime = CACurrentMediaTime();
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [instance performSelector:sel withObject:event];
            CFTimeInterval endTime = CACurrentMediaTime();
            if ([self shouldModuleMetrics]) {
                NSMutableString * message = [[NSMutableString alloc] init];
                [message appendString:@"Bus: "];
                [message appendString:NSStringFromClass(module.class)];
                [message appendFormat:@" execute %@ ",NSStringFromSelector(sel)];
                [message appendFormat:@"cost %fms", endTime - beginTime];
                DDLogDebug(@"%@",message);
            }
#pragma clang diagnostic pop
        }
    }];
    [[QTEventBus shared] dispatch:event];
}

- (BOOL)shouldModuleMetrics{
#ifdef DEBUG
    return YES;
#endif
    return NO;
}

@end

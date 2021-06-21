//
//  HTApplicationService.m
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTApplicationService.h"
#import <Bugly/Bugly.h>
#import <MMKV/MMKV.h>
#import "HTLogFormatter.h"

QTAppModuleRegister(HTApplicationService, QTAppEventPriorityHigh)


@interface HTApplicationService ()<QTAppModule>
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign, readwrite) NetworkStatus networkStatus;
@end

@implementation HTApplicationService

#pragma mark - QTAppModule
+ (instancetype)sharedData{
    static HTApplicationService *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[HTApplicationService alloc] init];
        [_shared initConfig];
    });
    return _shared;
}

+ (id<QTAppModule>)moduleInstance {
    return [HTApplicationService sharedData];
}

#pragma mark - Config
// 初始化设置
- (void)initConfig{

    [self configurationMMKV];
    [self configurationDDLog];
    [self configurationIQKeyboard];
    [self configurationNetWorkStatus];
    [self configurationDarkMode];
    [self configurationBugly];
}
// 配置MMKV
- (void)configurationMMKV{
    // 关闭MMKV的Log
    [MMKV initializeMMKV:nil logLevel:MMKVLogNone];
}
// 配置Log
- (void)configurationDDLog{
    
    // 添加DDASLLogger，日志语句将被发送到Xcode控制台
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    // 添加DDTTYLogger，日志语句将被发送到Console.app
    //    [DDLog addLogger:[DDASLLogger sharedInstance]];

    HTLogFormatter *formatter = [[HTLogFormatter alloc] init];
    for (id<DDLogger> log in [[DDLog sharedInstance] allLoggers]) {
        log.logFormatter = formatter;
    }
    // 产生Log
    DDLogVerbose(@"=========DDLog Verbose=========");
    DDLogDebug(@"=========DDLog Debug=========");
    DDLogInfo(@"=========DDLog Info=========");
    DDLogWarn(@"=========DDLog Warn=========");
    DDLogError(@"=========DDLog Error=========");
}
// 监听网络状态
- (void)configurationNetWorkStatus{
    
    self.reachability = Reachability.reachabilityForInternetConnection;
    RAC(self, networkStatus) = [[[[[NSNotificationCenter defaultCenter]
                                   rac_addObserverForName:kReachabilityChangedNotification object:nil]
                                  map:^(NSNotification *notification) {
                                      return @([notification.object currentReachabilityStatus]);
                                  }]
                                 startWith:@(self.reachability.currentReachabilityStatus)]
                                distinctUntilChanged];
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self)
        [self.reachability startNotifier];
    });
}
// 配置IQKeyboardManager
- (void)configurationIQKeyboard{

    [[SDWebImageDownloader sharedDownloader] setValue:@"iPhone" forHTTPHeaderField:@"User-Agent"];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
}
// 配置DarkMode
- (void)configurationDarkMode{

    HTDarkModeInit *darkMode = [[HTDarkModeInit alloc] init];
    [darkMode toInit];
}
// 配置Bugly
- (void)configurationBugly{
    [Bugly startWithAppId:BuglyAppKey];
}
@end

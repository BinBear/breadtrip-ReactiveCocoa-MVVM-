//
//  NSObject+QTEventBus.h
//  QTEventBus
//
//  Created by Leo on 2018/6/1.
//  Copyright © 2018年 Leo Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTEventTypes.h"

@class QTEventBus;
@class QTJsonEvent;
@interface NSObject (QTEventBus)

/// 在EventBus单例shared上监听指定类型的事件，并且跟随self一起取消监听
- (QTEventSubscriberMaker *)subscribeSharedBus:(Class)eventClass;

/// 在EventBus单例子监听指定字符串事件
- (QTEventSubscriberMaker<NSString *> *)subscribeSharedBusOfName:(NSString *)eventName;

/// 在bus上监听指定类型的事件，并且跟随self一起取消监听
- (QTEventSubscriberMaker *)subscribe:(Class)eventClass on:(QTEventBus *)bus;

/// 在bus上监听指定字符串时间
- (QTEventSubscriberMaker<NSString *> *)subscribeName:(NSString *)eventName on:(QTEventBus *)bus;

@end

@interface NSObject(EventBus_JSON)

/// 监听一个JSONEvent，并且self释放的时候自动取消订阅
- (QTEventSubscriberMaker<QTJsonEvent *> *)subscribeSharedBusOfJSON:(NSString *)name;

@end

@interface NSObject(EventBus_Notification)

/// 监听通知
- (QTEventSubscriberMaker<NSNotification *> *)subscribeNotification:(NSString *)name;

/// 监听活跃
- (QTEventSubscriberMaker<NSNotification *> *)subscribeAppDidBecomeActive;

/// 监听进入后台
- (QTEventSubscriberMaker<NSNotification *> *)subscribeAppDidEnterBackground;

/// 监听收到内存警告
- (QTEventSubscriberMaker<NSNotification *> *)subscribeAppDidReceiveMemoryWarning;

/// 监听用户截屏
- (QTEventSubscriberMaker<NSNotification *> *)subscribeUserDidTakeScreenshot;

/// 监听进入前台
- (QTEventSubscriberMaker<NSNotification *> *)subscribeAppWillEnterForground;

/// 监听应用即将退出活动状态
- (QTEventSubscriberMaker<NSNotification *> *)subscribeAppWillResignActive;

/// 监听应用杀死
- (QTEventSubscriberMaker<NSNotification *> *)subscribeAppWillTerminate;

@end

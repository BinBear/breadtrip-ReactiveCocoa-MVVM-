//
//  NSNotificationCenter+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (BinAdd)
/**
 *  在主线程发通知。（如果现在不在主线程，则异步发送通知）
 *
 *  @param notification NSNotification对象
 */
- (void)postNotificationOnMainThread:(NSNotification *)notification;
/**
 *  在主线程发通知。（如果现在不在主线程，wait 为 YES 则阻塞主线程发送通知）
 *
 *  @param notification NSNotification对象
 *  @param wait         是否阻塞主线程
 */
- (void)postNotificationOnMainThread:(NSNotification *)notification
                       waitUntilDone:(BOOL)wait;

/**
 *  在主线程创建一个通知发送。（如果现在不在主线程，则异步创建发送通知）
 *
 *  @param aName    用来生成新通知的通知名称
 *  @param anObject 通知携带的对象
 */
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(nullable id)object;
/**
 *  在主线程创建一个通知发送。（如果现在不在主线程，则异步创建发送通知）
 *
 *  @param aName     用来生成新通知的通知名称
 *  @param anObject  通知携带的对象
 *  @param aUserInfo 通知携带的用户信息
 */
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(nullable id)object
                                    userInfo:(nullable NSDictionary *)userInfo;
/**
 *  在主线程创建一个通知发送。（如果现在不在主线程，wait 为 YES 则阻塞主线程去发通知）
 *
 *  @param name     用来生成新通知的通知名称
 *  @param object   通知携带的对象
 *  @param userInfo 通知携带的用户信息
 *  @param wait     是否阻塞主线程
 */
- (void)postNotificationOnMainThreadWithName:(NSString *)name
                                      object:(nullable id)object
                                    userInfo:(nullable NSDictionary *)userInfo
                               waitUntilDone:(BOOL)wait;

@end

NS_ASSUME_NONNULL_END
//
//  RACSignal+Request.h
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "HTRequestList.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^requestSignalBlock)(id response, id<RACSubscriber> subscriber);

@interface RACSignal (Request)

/**
 signal的get请求,可配置请求体
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalGetAuth:(NSString * _Nullable)url
                       params:(id  _Nullable)params
                    configure:(HTRequestConfigure _Nullable)configure
                 handleSignal:(requestSignalBlock _Nullable)handleSignal;

/**
 signal的post请求
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalPostAuth:(NSString * _Nullable)url
                        params:(id _Nullable)params
                     configure:(HTRequestConfigure _Nullable)configure
                  handleSignal:(requestSignalBlock _Nullable)handleSignal;

@end

NS_ASSUME_NONNULL_END

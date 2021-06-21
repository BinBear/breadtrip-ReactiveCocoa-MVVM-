//
//  RACCommand+Request.h
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "RACSignal+Request.h"

NS_ASSUME_NONNULL_BEGIN

// 处理执行command的block
typedef void (^requestCommandBlock)(id input, id response,  id<RACSubscriber> subscriber);

// 处理执行command的input来改变请求参数的paramsblock
typedef id _Nullable (^requestParamsBlock)(id input);

// 处理执行command的input来改变请求Url
typedef id _Nullable (^requestUrlBlock)(id input);


@interface RACCommand (Request)

#pragma mark - Post请求
/**
 post请求(不根据command的input来改变请求Url)
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandPost:(NSString * _Nullable)url
                     params:(requestParamsBlock _Nullable)params
                  configure:(HTRequestConfigure _Nullable)configure
              handleCommand:(requestCommandBlock _Nullable)handleCommand;
/**
 post请求(根据command的input来改变请求Url)
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandPostBlockUrl:(requestUrlBlock _Nullable)url
                             params:(requestParamsBlock _Nullable)params
                          configure:(HTRequestConfigure _Nullable)configure
                      handleCommand:(requestCommandBlock _Nullable)handleCommand;


#pragma mark - Get请求
/**
 get请求(不根据command的input来改变请求Url)
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandGet:(NSString * _Nullable)url
                    params:(requestParamsBlock _Nullable)params
                 configure:(HTRequestConfigure _Nullable)configure
             handleCommand:(requestCommandBlock _Nullable)handleCommand;
/**
 get请求(根据command的input来改变请求Url)
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandGetBlockUrl:(requestUrlBlock _Nullable)url
                            params:(requestParamsBlock _Nullable)params
                         configure:(HTRequestConfigure _Nullable)configure
                     handleCommand:(requestCommandBlock _Nullable)handleCommand;



@end

NS_ASSUME_NONNULL_END

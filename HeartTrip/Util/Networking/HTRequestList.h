//
//  HTRequestList.h
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VinBaseComponents/HTNetworkManager.h>
#import <VinBaseComponents/HTJSON.h>

NS_ASSUME_NONNULL_BEGIN

/// 请求服务
#define HTRequestServer_Check(make) \
make(HTRequestServer_Main, = 1, api.breadtrip.com) \

DECLARE_ENUM(HTRequestServer, HTRequestServer_Check)

typedef void(^HTRequestConfigure)(HTRequestListConfigure *configure);

@interface HTRequestList : NSObject

/**
 post请求
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (HTURLSessionTask *)requestPost:(NSString * _Nullable)url
                           params:(id _Nullable)params
                        configure:(HTRequestConfigure _Nullable)configure
                          success:(HTResponseSuccess _Nullable)success
                             fail:(HTResponseFail _Nullable)fail;

/**
 get请求
 
 @param url 请求地址
 @param params 参数
 @param configure 其他配置
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+ (HTURLSessionTask *)requestGet:(NSString * _Nullable)url
                          params:(id _Nullable)params
                       configure:(HTRequestConfigure _Nullable)configure
                         success:(HTResponseSuccess _Nullable)success
                            fail:(HTResponseFail _Nullable)fail;

@end

NS_ASSUME_NONNULL_END

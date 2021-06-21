//
//  HTRequestList.m
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTRequestList.h"


DEFINE_ENUM(HTRequestServer, HTRequestServer_Check)

@implementation HTRequestList

+ (HTURLSessionTask *)requestPost:(NSString * _Nullable)url
                           params:(id _Nullable)params
                        configure:(HTRequestConfigure _Nullable)configure
                          success:(HTResponseSuccess _Nullable)success
                             fail:(HTResponseFail _Nullable)fail {
    HTRequestListConfigure *requestConfigure = [HTRequestListConfigure defaultConfigure];
    requestConfigure.requestMethodType(kHTNetworRequestTypePost);
    !configure ?: configure(requestConfigure);
    [self showHUD:requestConfigure];
    HTURLSessionTask *session =
    [HTNetworkManager.network requestConfigure:requestConfigure
                                           url:[self handelServiceUrl:url serverName:requestConfigure]
                                     parameter:params
                                 formDataBlock:nil
                                 progressBlock:nil
                                  successBlock:^(id  _Nullable response, NSURLSessionDataTask * _Nullable task) {
        [self dealResponse:response success:success fail:fail configure:requestConfigure];
    }
                                  failureBlock:^(NSError * _Nullable error, NSURLSessionDataTask * _Nullable task) {
        [self dealFail:error fail:fail configure:requestConfigure];
    }];
    
    
    return session;
}


+ (HTURLSessionTask *)requestGet:(NSString * _Nullable)url
                          params:(id _Nullable)params
                       configure:(HTRequestConfigure _Nullable)configure
                         success:(HTResponseSuccess _Nullable)success
                            fail:(HTResponseFail _Nullable)fail {
    HTRequestListConfigure *requestConfigure = [HTRequestListConfigure defaultConfigure];
    requestConfigure.requestMethodType(kHTNetworRequestTypeGet);
    !configure ?: configure(requestConfigure);
    [self showHUD:requestConfigure];
    HTURLSessionTask *session =
    [HTNetworkManager.network requestConfigure:requestConfigure
                                           url:[self handelServiceUrl:url serverName:requestConfigure]
                                     parameter:params
                                 formDataBlock:nil
                                 progressBlock:nil
                                  successBlock:^(id  _Nullable response, NSURLSessionDataTask * _Nullable task) {
        [self dealResponse:response success:success fail:fail configure:requestConfigure];
    }
                                  failureBlock:^(NSError * _Nullable error, NSURLSessionDataTask * _Nullable task) {
        [self dealFail:error fail:fail configure:requestConfigure];
    }];
    
    
    return session;
}

#pragma mark - 初步处理返回的结果
+ (void)dealResponse:(id)response
             success:(HTResponseSuccess)success
                fail:(HTResponseFail)failError
           configure:(HTRequestListConfigure *)configure {
    [self dissMissHUD];
    // 根据业务做相应处理
    if (response && response != [NSNull null]) {
        if ([response isKindOfClass:NSDictionary.class] ||
            [response isKindOfClass:NSMutableDictionary.class]) {
            
            NSInteger status = HTJSONMake(response)[@"status"].integerValue;
            NSString *message = HTJSONMake(response)[@"message"].string;
            if (status == 0) {
                !success?:success(response,nil);
            }else{
                [HTShowTipsView showTips:message];
                !failError?:failError(nil,nil);
            }
        }else{
            !failError?:failError(nil,nil);
        }
        
    }else{
        !failError?:failError(nil,nil);
    }
}

+ (void)dealFail:(NSError *)error
            fail:(HTResponseFail)failError
       configure:(HTRequestListConfigure *)configure {
    [self dissMissHUD];
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSString *errorStr = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    
    !failError?:failError(error,nil);
    if (error.code == -999) {
        // 请求取消
    }else{
        if (configure.isShowError) {
            [HTShowTipsView showTips:errorStr];
        }
    }
}

#pragma mark - 根据服务名称跟请求地址获取完整链接
+ (NSString *)handelServiceUrl:(NSString *)url
                    serverName:(HTRequestListConfigure *)configure {
    NSString *urlStr = @"";
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        urlStr = url;
    } else {
        if (configure.getServerName) {
            // 有多个服务，根据服务名称拼接URL
            NSString *serverName = DescriptionFromHTRequestServer([configure.getServerName integerValue]);
            urlStr = [NSString vv_stringWithFormat:@"http://%@%@",serverName,url];
        }
    }
    return urlStr;
}

#pragma mark - HUD
+ (void)showHUD:(HTRequestListConfigure *)configure {
    if (configure.isShowHUD) {
        [HTHUD loadingViewInKeyWindow];
    }
}

+ (void)dissMissHUD {
    [HTHUD dismiss];
}
@end

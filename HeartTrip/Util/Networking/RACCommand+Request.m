//
//  RACCommand+Request.m
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "RACCommand+Request.h"

// command 订阅函数
requestSignalBlock requestCommand(id input, requestCommandBlock handleCommand) {
    return !handleCommand  ? nil :
    ^(id response, id<RACSubscriber> subscriber) {
        handleCommand(input, response, subscriber);
    };
}

// 处理参数函数
id requestParams(id input, requestParamsBlock params) {
   return params ? params(input) : input;
}

// 处理Url函数
id requestUrl(id input, requestUrlBlock url) {
    return url ? url(input) : @"";
}


@implementation RACCommand (Request)

#pragma mark - Get请求
+ (instancetype)commandGet:(NSString *)url
                    params:(requestParamsBlock)params
                 configure:(HTRequestConfigure)configure
             handleCommand:(requestCommandBlock)handleCommand{
    return ht_commandWithSignal(^RACSignal * _Nonnull(id  _Nonnull input) {
        return [RACSignal signalGetAuth:url
                                 params:requestParams(input, params)
                              configure:configure
                           handleSignal:requestCommand(input, handleCommand)];
    });
}
+ (instancetype)commandGetBlockUrl:(requestUrlBlock)url
                            params:(requestParamsBlock)params
                         configure:(HTRequestConfigure)configure
                     handleCommand:(requestCommandBlock)handleCommand{
    return ht_commandWithSignal(^RACSignal * _Nonnull(id  _Nonnull input) {
        return [RACSignal signalGetAuth:requestUrl(input, url)
                                 params:requestParams(input, params)
                              configure:configure
                           handleSignal:requestCommand(input, handleCommand)];
    });
}

#pragma mark - Post请求
+ (instancetype)commandPost:(NSString *)url
                     params:(requestParamsBlock)params
                  configure:(HTRequestConfigure)configure
              handleCommand:(requestCommandBlock)handleCommand{
    return ht_commandWithSignal(^RACSignal * _Nonnull(id  _Nonnull input) {
        return [RACSignal signalPostAuth:url
                                  params:requestParams(input, params)
                               configure:configure
                            handleSignal:requestCommand(input, handleCommand)];
    });
}
+ (instancetype)commandPostBlockUrl:(requestUrlBlock)url
                             params:(requestParamsBlock)params
                          configure:(HTRequestConfigure)configure
                      handleCommand:(requestCommandBlock)handleCommand{
    return ht_commandWithSignal(^RACSignal * _Nonnull(id  _Nonnull input) {
        return [RACSignal signalPostAuth:requestUrl(input, url)
                                  params:requestParams(input, params)
                               configure:configure
                            handleSignal:requestCommand(input, handleCommand)];
    });
}

@end

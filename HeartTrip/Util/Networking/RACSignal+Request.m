//
//  RACSignal+Request.m
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "RACSignal+Request.h"

// 请求成功订阅函数
typedef void (^successBlock)(id response, NSURLSessionTask *task);
successBlock subscribSuccesss(id<RACSubscriber> subscriber,  requestSignalBlock signalBlock) {
    
    return ^(id response, NSURLSessionTask *task) {
        signalBlock ?
        signalBlock(response, subscriber) :
        ({
            
            [subscriber sendNext:response];
            [subscriber sendCompleted];
        });
    };
}

// 请求失败订阅函数
typedef void (^failBlock)(NSError *error, NSURLSessionTask *task);
failBlock subscribfail(id<RACSubscriber>  _Nonnull subscriber) {
    
    return ^(NSError *error, NSURLSessionTask *task) {
        [subscriber sendError:error];
    };
}

// disposableBlock 函数
typedef void(^disposableBlock)(void);
disposableBlock taskDisposableBlock(HTURLSessionTask *task) {
    
    return ^{
        if (task.state != NSURLSessionTaskStateCanceling &&
            task.state != NSURLSessionTaskStateCompleted) {
            [task cancel];
        }
    };
}


@implementation RACSignal (Request)

+ (instancetype)signalGetAuth:(NSString *)url
                       params:(id)params
                    configure:(HTRequestConfigure)configure
                 handleSignal:(requestSignalBlock)handleSignal{
    return ht_createSignal(^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([HTRequestList requestGet:url
                                    params:params
                                 configure:configure
                                   success:subscribSuccesss(subscriber, handleSignal)
                                      fail:subscribfail(subscriber)])];
    });
}
+ (instancetype)signalPostAuth:(NSString *)url
                        params:(id)params
                     configure:(HTRequestConfigure)configure
                  handleSignal:(requestSignalBlock)handleSignal{
    return ht_createSignal(^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([HTRequestList requestPost:url
                                     params:params
                                  configure:configure
                                    success:subscribSuccesss(subscriber, handleSignal)
                                       fail:subscribfail(subscriber)])];
    });
}

@end

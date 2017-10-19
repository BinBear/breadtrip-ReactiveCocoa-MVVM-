//
//  HTCityTravelDetailProtocolImpl.m
//  HeartTrip
//
//  Created by 熊彬 on 2017/10/13.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTCityTravelDetailProtocolImpl.h"

@interface HTCityTravelDetailProtocolImpl()


@end

@implementation HTCityTravelDetailProtocolImpl
- (RACSignal *)requestCityTravelDetailDataSignal:(NSString *)requestUrl
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        HTURLSessionTask *task = [HTNetWorking getWithUrl:requestUrl refreshCache:YES showHUD:@"loading..." success:^(id response) {
            
            NSDictionary *responseDic = response;
            
            
            [subscriber sendNext:@""];
            [subscriber sendCompleted];
            
        } fail:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];
}
@end

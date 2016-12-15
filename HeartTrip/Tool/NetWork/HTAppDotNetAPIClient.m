//
//  HTAppDotNetAPIClient.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/23.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTAppDotNetAPIClient.h"

@implementation HTAppDotNetAPIClient

+ (instancetype)sharedClient {
    static HTAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HTAppDotNetAPIClient alloc] init];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end

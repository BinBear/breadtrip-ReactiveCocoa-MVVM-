//
//  HTAppDotNetAPIClient.h
//  HeartTrip
//
//  Created by 熊彬 on 16/9/23.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface HTAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

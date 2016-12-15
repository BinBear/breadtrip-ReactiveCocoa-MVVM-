//
//  HTCityTravelProtocol.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/21.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTCityTravelProtocol <NSObject>

// 加载首页数据
- (RACSignal *)requestCityTravelDataSignal:(NSString *)requestUrl;

// 加载首页更多数据
- (RACSignal *)requestCityTravelMoreDataSignal:(NSString *)requestUrl;

@end

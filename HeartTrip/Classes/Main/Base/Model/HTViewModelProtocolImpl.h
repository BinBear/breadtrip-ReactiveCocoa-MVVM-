//
//  HTViewModelProtocolImpl.h
//  HeartTrip
//
//  Created by 熊彬 on 2017/3/31.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTViewModelProtocolImpl <NSObject>

@optional
// 加载首页数据
- (RACSignal *)requestCityTravelDataSignal:(NSString *)requestUrl;

// 加载首页更多数据
- (RACSignal *)requestCityTravelMoreDataSignal:(NSString *)requestUrl;

// 加载首页详情数据
- (RACSignal *)requestCityTravelDetailDataSignal:(NSString *)requestUrl;

// 加载发现数据
- (RACSignal *)requestFindDataSignal:(NSString *)requestUrl;

// 加载发现更多数据
- (RACSignal *)requestFindMoreDataSignal:(NSString *)requestUrl;

// 加载探索视频数据
- (RACSignal *)requestExploreVideosDataSignal:(NSString *)requestUrl;

// 加载探索视频更多数据
- (RACSignal *)requestExploreVideosMoreDataSignal:(NSString *)requestUrl;

@end

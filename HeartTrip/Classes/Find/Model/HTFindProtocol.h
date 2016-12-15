//
//  HTFindProtocol.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/30.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTFindProtocol <NSObject>

// 加载发现数据
- (RACSignal *)requestFindDataSignal:(NSString *)requestUrl;

// 加载发现更多数据
- (RACSignal *)requestFindMoreDataSignal:(NSString *)requestUrl;

@end

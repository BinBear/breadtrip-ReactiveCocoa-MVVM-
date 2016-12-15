//
//  HTServerConfig.h
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTServerConfig : NSObject

// env: 环境参数 00: 测试环境 01: 生产环境
+ (void)setHTConfigEnv:(NSString *)value;

// 返回环境参数 00: 测试环境 01: 生产环境
+ (NSString *)HTConfigEnv;

// 获取服务器地址
+ (NSString *)getHTServerAddr;

@end

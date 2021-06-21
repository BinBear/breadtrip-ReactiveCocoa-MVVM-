//
//  HTApplicationService.h
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

NS_ASSUME_NONNULL_BEGIN

/// 启动时候需要初始化的配置服务，优先级比较高
@interface HTApplicationService : NSObject

/// 网络状态
@property (nonatomic, assign, readonly) NetworkStatus networkStatus;

/// 获取Data实例
+ (instancetype)sharedData;

@end

NS_ASSUME_NONNULL_END

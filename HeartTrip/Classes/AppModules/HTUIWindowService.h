//
//  HTUIWindowService.h
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 启动时候需要初始化的根控制器服务，优先级比较低
@interface HTUIWindowService : UIResponder

// 获取Data实例
+ (instancetype)sharedData;

@end

NS_ASSUME_NONNULL_END

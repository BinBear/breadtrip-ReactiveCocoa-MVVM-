//
//  HTViewModel.h
//  HeartTrip
//
//  Created by 熊彬 on 17/2/28.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTViewModel : NSObject
/**
 *  数据请求
 */
@property (strong, nonatomic) RACCommand *requestDataCommand;
/**
 *  网络状态
 */
@property (assign , nonatomic) ReachabilityStatus  netWorkStatus;
@end

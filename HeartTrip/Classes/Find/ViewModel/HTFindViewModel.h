//
//  HTFindViewModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/30.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTViewModelService.h"

@interface HTFindViewModel : NSObject

/**
 *  数据请求
 */
@property (strong, nonatomic) RACCommand *feedDataCommand;
/**
 *  错误信号
 */
@property (strong, nonatomic) RACSignal *feedConnectionErrors;
/**
 *  更多数据请求
 */
@property (strong, nonatomic) RACCommand *feedMoreDataCommand;
/**
 *  更多数据错误信号
 */
@property (strong, nonatomic) RACSignal *feedMoreConnectionErrors;
/**
 *  feed详情
 */
@property (strong, nonatomic) RACCommand *feedDetailCommand;
/**
 *  活动流数组
 */
@property (strong, nonatomic) NSArray *feedData;
/**
 *  视频数组
 */
@property (strong, nonatomic) NSArray *videoData;

- (instancetype)initWithServices:(id<HTViewModelService>)services;

@end

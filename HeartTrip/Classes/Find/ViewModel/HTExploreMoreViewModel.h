//
//  HTExploreMoreViewModel.h
//  HeartTrip
//
//  Created by 熊彬 on 17/1/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTViewModel.h"

@interface HTExploreMoreViewModel : HTViewModel

/**
 *  错误信号
 */
@property (strong, nonatomic) RACSignal *exploreConnectionErrors;
/**
 *  探索视频加载更多数据请求
 */
@property (strong, nonatomic) RACCommand *exploreMoreDataCommand;
/**
 *  探索视频加载更多错误信号
 */
@property (strong, nonatomic) RACSignal *exploreMoreConnectionErrors;
/**
 *  视频播放详情
 */
@property (strong, nonatomic) RACCommand *videoPlayerCommand;
/**
 *  活动详情
 */
@property (strong, nonatomic) RACCommand *productDetailCommand;
/**
 *  视频数组
 */
@property (strong, nonatomic) NSArray *videosData;


@end

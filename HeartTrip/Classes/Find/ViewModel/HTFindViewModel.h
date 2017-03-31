//
//  HTFindViewModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/30.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTViewModel.h"

@interface HTFindViewModel : HTViewModel

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
 *  评论详情
 */
@property (strong, nonatomic) RACCommand *commentLinkCommand;
/**
 *  活动流数组
 */
@property (strong, nonatomic) NSArray *feedData;
/**
 *  视频数组
 */
@property (strong, nonatomic) NSArray *videoData;



@end

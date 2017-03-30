//
//  HTCityTravelViewModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/16.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTViewModel.h"

@interface HTCityTravelViewModel : HTViewModel

/**
 *  错误信号
 */
@property (strong, nonatomic) RACSignal *travelConnectionErrors;
/**
 *  更多数据请求
 */
@property (strong, nonatomic) RACCommand *travelMoreDataCommand;
/**
 *  更多错误信号
 */
@property (strong, nonatomic) RACSignal *travelMoreConnectionErrors;
/**
 *  导航栏rightBar
 */
@property (strong, nonatomic) RACCommand *rightBarButtonItemCommand;
/**
 *  游记详情
 */
@property (strong, nonatomic) RACCommand *travelDetailCommand;
/**
 *  游记数据
 */
@property (strong, nonatomic) NSArray *travelData;
/**
 *  banner数据
 */
@property (strong, nonatomic) NSArray *bannerData;
/**
 *  是否为搜索
 */
@property (assign , nonatomic) BOOL  isSearch;



@end

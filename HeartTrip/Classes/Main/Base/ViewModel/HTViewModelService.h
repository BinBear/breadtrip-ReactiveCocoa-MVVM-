//
//  HTViewModelService.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/21.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTViewModelProtocolImpl.h"


@protocol HTViewModelService <NSObject>

// 获取首页服务
- (id<HTViewModelProtocolImpl>) getCityTravelService;
// 获取首页详情服务
- (id<HTViewModelProtocolImpl>) getCityTravelDetailService;

// 获取发现服务
- (id<HTViewModelProtocolImpl>) getFindService;
// 获取探索视频服务
- (id<HTViewModelProtocolImpl>) getExploreMoreService;

// 获取目的地服务


// 获取我的服务

// 获得web服务
- (id<HTViewModelProtocolImpl>)getWebService;
@end

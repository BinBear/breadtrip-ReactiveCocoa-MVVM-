//
//  HTViewModelService.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/21.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCityTravelProtocol.h"
#import "HTFindProtocol.h"
#import "HTWebProtocol.h"

@protocol HTViewModelService <NSObject>

// 获取首页服务
- (id<HTCityTravelProtocol>) getCityTravelService;

// 获取发现服务
- (id<HTFindProtocol>) getFindService;

// 获取目的地服务


// 获取我的服务

// 获得web服务
- (id<HTWebProtocol>)getWebService;
@end

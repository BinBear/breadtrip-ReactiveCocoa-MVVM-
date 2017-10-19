//
//  HTViewModelServicesImpl.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/21.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTViewModelServicesImpl.h"
#import "HTCityTravelProtocolImpl.h"
#import "HTFindProtocolImpl.h"
#import "HTWebProtocolImpl.h"
#import "HTExploreMoreImpl.h"
#import "HTCityTravelDetailProtocolImpl.h"

@interface HTViewModelServicesImpl ()
/**
 *  首页数据服务
 */
@property (strong, nonatomic) HTCityTravelProtocolImpl *cityTravelService;
/**
 *  首页详情数据服务
 */
@property (strong, nonatomic) HTCityTravelDetailProtocolImpl *cityTravelDetailService;
/**
 *  发现数据服务
 */
@property (strong, nonatomic) HTFindProtocolImpl *findService;
/**
 *  探索视频服务
 */
@property (strong, nonatomic) HTExploreMoreImpl *exploreService;
/**
 *  web服务
 */
@property (strong, nonatomic) HTWebProtocolImpl *wedService;
@end

@implementation HTViewModelServicesImpl
- (instancetype)initModelServiceImpl
{
    if (self = [super init]) {
        
        _cityTravelService = [HTCityTravelProtocolImpl new];
        _cityTravelDetailService = [HTCityTravelDetailProtocolImpl new];
        _findService = [HTFindProtocolImpl new];
        _exploreService = [HTExploreMoreImpl new];
        _wedService = [HTWebProtocolImpl new];
        
    }
    return self;
}
- (id<HTViewModelProtocolImpl>)getCityTravelService
{
    return self.cityTravelService;
}
- (id<HTViewModelProtocolImpl>)getCityTravelDetailService
{
    return self.cityTravelDetailService;
}
- (id<HTViewModelProtocolImpl>)getFindService
{
    return self.findService;
}
- (id<HTViewModelProtocolImpl>)getExploreMoreService
{
    return self.exploreService;
}
- (id<HTViewModelProtocolImpl>)getWebService
{
    return self.wedService;
}
@end

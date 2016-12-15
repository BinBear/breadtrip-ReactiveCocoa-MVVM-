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

@interface HTViewModelServicesImpl ()
/**
 *  首页数据服务
 */
@property (strong, nonatomic) HTCityTravelProtocolImpl *cityTravelService;
/**
 *  发现数据服务
 */
@property (strong, nonatomic) HTFindProtocolImpl *findService;
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
        _findService = [HTFindProtocolImpl new];
        _wedService = [HTWebProtocolImpl new];
    }
    return self;
}
- (id<HTCityTravelProtocol>)getCityTravelService
{
    return self.cityTravelService;
}
- (id<HTFindProtocol>)getFindService
{
    return self.findService;
}
- (id<HTWebProtocol>)getWebService
{
    return self.wedService;
}
@end

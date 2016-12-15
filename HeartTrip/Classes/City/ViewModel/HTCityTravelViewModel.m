//
//  HTCityTravelViewModel.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/16.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTCityTravelViewModel.h"
#import "HTBannerModel.h"
#import "HTCityTravelItemModel.h"

@interface HTCityTravelViewModel ()
@property (strong , nonatomic) id<HTViewModelService> services;
@end

@implementation HTCityTravelViewModel
- (instancetype)initWithServices:(id<HTViewModelService>)services
{
    if (self = [super init]) {
        
        _services = services;
        
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    _travelData = [NSArray new];
    _bannerData = [NSArray new];
    _isSearch = NO;
    
    RACSignal *visibleStateChanged = [RACObserve(self, isSearch) skip:1];
    

    [visibleStateChanged subscribeNext:^(NSNumber *visible) {
        
        _isSearch = visible.boolValue;
    }];
    
    _travelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[[_services getCityTravelService] requestCityTravelDataSignal:CityTravel_URL] doNext:^(id  _Nullable result) {
            
            self.bannerData = [NSArray arrayWithArray:result[BannerDatakey]];
            self.travelData = [NSArray arrayWithArray:result[TravelDatakey]];
            
        }];
    }];
    
    _travelMoreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[[_services getCityTravelService] requestCityTravelMoreDataSignal:CityTravel_URL] doNext:^(id  _Nullable result) {
            
            self.travelData = [NSArray arrayWithArray:result[TravelDatakey]];
            
        }];
    }];
    
    _rightBarButtonItemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSNumber numberWithBool:self.isSearch]];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    _travelConnectionErrors = _travelCommand.errors;
    _travelMoreConnectionErrors = _travelMoreDataCommand.errors;
}
@end

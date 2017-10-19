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
#import "HTMediatorAction+HTCityTravelDetailController.h"
#import "HTViewModelServicesImpl.h"
#import "HTCityTravelDetialViewModel.h"

@interface HTCityTravelViewModel ()

@end

@implementation HTCityTravelViewModel
- (instancetype)initWithServices:(id<HTViewModelService>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        
        _travelData = [NSArray new];
        _bannerData = [NSArray new];
        _isSearch = NO;
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    
    RACSignal *visibleStateChanged = [RACObserve(self, isSearch) skip:1];
    

    [visibleStateChanged subscribeNext:^(NSNumber *visible) {
        
        _isSearch = visible.boolValue;
    }];
    @weakify(self);
    _travelMoreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        @strongify(self);
        return [[[self.services getCityTravelService] requestCityTravelMoreDataSignal:CityTravel_URL] doNext:^(id  _Nullable result) {
            
            self.travelData = result[TravelDatakey];
            
        }];
    }];
    
    _rightBarButtonItemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSNumber numberWithBool:self.isSearch]];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    _travelDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        HTCityTravelItemModel *itemViewModel = input;
        NSString *requestURL = [NSString stringWithFormat:@"http://api.breadtrip.com/trips/%@/waypoints/?gallery_mode=1",itemViewModel.travelID];
        HTViewModelServicesImpl *servicesImpl = [[HTViewModelServicesImpl alloc] initModelServiceImpl];
        HTCityTravelDetialViewModel *viewModel = [[HTCityTravelDetialViewModel alloc] initWithServices:servicesImpl params:@{RequestURLkey:requestURL,NavBarStyleTypekey:@(kNavBarStyleNomal)}];
        [[HTMediatorAction sharedInstance] pushCityTravelDetailControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    _travelMoreConnectionErrors = _travelMoreDataCommand.errors;
}
- (RACSignal *)executeRequestDataSignal:(id)input
{
    if ([input integerValue] == RealStatusNotReachable) {
        
        self.netWorkStatus = RealStatusNotReachable;
        return [RACSignal empty];
        
    }else{
        
        @weakify(self);
        return [[[self.services getCityTravelService] requestCityTravelDataSignal:CityTravel_URL] doNext:^(id  _Nullable result) {
            @strongify(self);
            self.bannerData = result[BannerDatakey];
            self.travelData = result[TravelDatakey];
            
        }];
    }
}
@end

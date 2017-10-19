//
//  HTCityTravelDetialViewModel.m
//  HeartTrip
//
//  Created by 熊彬 on 17/3/30.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTCityTravelDetialViewModel.h"

@interface HTCityTravelDetialViewModel ()
/**
 *  详情地址
 */
@property (copy, nonatomic) NSString *requestURL;
@end

@implementation HTCityTravelDetialViewModel
- (instancetype)initWithServices:(id<HTViewModelService>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        
        _requestURL = params[RequestURLkey];
    }
    return self;
}
- (void)initialize
{
    [super initialize];
}
- (RACSignal *)executeRequestDataSignal:(id)input
{
    if ([input integerValue] == RealStatusNotReachable) {
        
        self.netWorkStatus = RealStatusNotReachable;
        return [RACSignal empty];
        
    }else{
        
        return [[[self.services getCityTravelDetailService] requestCityTravelDetailDataSignal:_requestURL] doNext:^(id  _Nullable result) {
            
        }];
    }
}
@end

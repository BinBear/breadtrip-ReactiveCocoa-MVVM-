//
//  HTExploreMoreViewModel.m
//  HeartTrip
//
//  Created by 熊彬 on 17/1/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTExploreMoreViewModel.h"
#import "HTFindVideosModel.h"

@interface HTExploreMoreViewModel ()

@property (strong , nonatomic) id<HTViewModelService> services;

@end

@implementation HTExploreMoreViewModel

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
    _exploreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[[_services getExploreMoreService] requestExploreVideosDataSignal:ExploreMore_URL] doNext:^(id  _Nullable result) {
            
            self.videosData = [NSArray arrayWithArray:result];
            
        }];
    }];
    
    _exploreMoreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[[_services getExploreMoreService] requestExploreVideosMoreDataSignal:ExploreMore_URL] doNext:^(id  _Nullable result) {
            
            self.videosData = [NSArray arrayWithArray:result];
            
        }];
    }];
    
    _exploreConnectionErrors = _exploreDataCommand.errors;
    _exploreMoreConnectionErrors = _exploreMoreDataCommand.errors;
}

@end

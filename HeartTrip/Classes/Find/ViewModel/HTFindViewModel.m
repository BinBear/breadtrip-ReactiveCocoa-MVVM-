//
//  HTFindViewModel.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/30.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTFindViewModel.h"
#import "HTFindFeedModel.h"
#import "HTWebViewModel.h"
#import "HTWebProtocolImpl.h"
#import "HTMediatorAction+HTWebViewController.h"

@interface HTFindViewModel ()
@property (strong , nonatomic) id<HTViewModelService> services;
@end

@implementation HTFindViewModel
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
    _feedDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[[_services getFindService] requestFindDataSignal:Find_URL] doNext:^(id  _Nullable result) {
            
            self.videoData = [NSArray arrayWithArray:result[FindVideoDatakey]];
            self.feedData = [NSArray arrayWithArray:result[FindFeedDatakey]];
            
        }];
    }];
    
    _feedMoreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[[_services getFindService] requestFindMoreDataSignal:Find_URL] doNext:^(id  _Nullable result) {
            
            self.feedData = [NSArray arrayWithArray:result[FindFeedDatakey]];
            
        }];
    }];
    _feedDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        HTFindFeedModel *feedModel = input;
        
        NSString *requestURL = [NSString stringWithFormat:@"http://web.breadtrip.com/hunter/product/%@/?bts=app_discover_share",feedModel.product_id];
        
        HTWebViewModel *viewModel = [[HTWebViewModel alloc] initWithServices:_services params:@{WebTitlekey:@"活动详情",RequestURLkey:requestURL}];
        
        [[HTMediatorAction sharedInstance] pushWebViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    _feedConnectionErrors = _feedDataCommand.errors;
    _feedMoreConnectionErrors = _feedMoreDataCommand.errors;
}

@end

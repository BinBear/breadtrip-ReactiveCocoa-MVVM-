//
//  HTExploreMoreViewModel.m
//  HeartTrip
//
//  Created by 熊彬 on 17/1/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTExploreMoreViewModel.h"
#import "HTFindVideosModel.h"
#import "HTWebViewModel.h"
#import "HTWebProtocolImpl.h"
#import "HTMediatorAction+HTWebViewController.h"

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
    
    _videoPlayerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(HTFindVideosModel *videoModel) {
        
        
        HTWebViewModel *viewModel = [[HTWebViewModel alloc] initWithServices:_services params:@{WebTitlekey:@"",RequestURLkey:videoModel.show_url,WebNavBarStyleTypekey:@(kWebNavBarStyleHidden)}];
        [[HTMediatorAction sharedInstance] pushWebViewControllerWithViewModel:viewModel];
        return [RACSignal empty];
    }];
    
    _productDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *product_id) {
        
        
        NSString *requestURL = [NSString stringWithFormat:@"http://web.breadtrip.com/hunter/product/%@/?bts=app_discover_video",product_id];
        
        HTWebViewModel *viewModel = [[HTWebViewModel alloc] initWithServices:_services params:@{WebTitlekey:@"活动详情",RequestURLkey:requestURL,WebNavBarStyleTypekey:@(kWebNavBarStyleNomal),WebViewTypekey:@(kWebFindDetailType)}];
        
        [[HTMediatorAction sharedInstance] pushWebViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    _exploreConnectionErrors = _exploreDataCommand.errors;
    _exploreMoreConnectionErrors = _exploreMoreDataCommand.errors;
}

@end

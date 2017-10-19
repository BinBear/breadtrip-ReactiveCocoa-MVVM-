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


@end

@implementation HTExploreMoreViewModel

- (instancetype)initWithServices:(id<HTViewModelService>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        
        _videosData = [NSArray new];
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    @weakify(self);
    _exploreMoreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [[[self.services getExploreMoreService] requestExploreVideosMoreDataSignal:ExploreMore_URL] doNext:^(id  _Nullable result) {
            
            self.videosData = result;
            
        }];
    }];
    
    _videoPlayerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(HTFindVideosModel *videoModel) {
        
        @strongify(self);
        HTWebViewModel *viewModel = [[HTWebViewModel alloc] initWithServices:self.services params:@{ViewTitlekey:@"",RequestURLkey:videoModel.show_url,NavBarStyleTypekey:@(kNavBarStyleHidden)}];
        [[HTMediatorAction sharedInstance] pushWebViewControllerWithViewModel:viewModel];
        return [RACSignal empty];
    }];
    
    _productDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSNumber *product_id) {
        
        @strongify(self);
        NSString *requestURL = [NSString stringWithFormat:@"http://web.breadtrip.com/hunter/product/%@/?bts=app_discover_video",product_id];
        
        HTWebViewModel *viewModel = [[HTWebViewModel alloc] initWithServices:self.services params:@{ViewTitlekey:@"活动详情",RequestURLkey:requestURL,NavBarStyleTypekey:@(kNavBarStyleNomal),WebViewTypekey:@(kWebFindDetailType)}];
        
        [[HTMediatorAction sharedInstance] pushWebViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    
    _exploreMoreConnectionErrors = _exploreMoreDataCommand.errors;
}
- (RACSignal *)executeRequestDataSignal:(id)input
{
    @weakify(self);
    return [[[self.services getExploreMoreService] requestExploreVideosDataSignal:ExploreMore_URL] doNext:^(id  _Nullable result) {
        @strongify(self);
        self.videosData = result;
        
    }];
}
@end

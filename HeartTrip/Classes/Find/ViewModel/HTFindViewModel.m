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

@end

@implementation HTFindViewModel
- (instancetype)initWithServices:(id<HTViewModelService>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        
        _feedData = [NSArray new];
        _videoData = [NSArray new];
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    @weakify(self);
    _feedMoreDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        @strongify(self);
        return [[[self.services getFindService] requestFindMoreDataSignal:Find_URL] doNext:^(id  _Nullable result) {
            
            self.feedData = result[FindFeedDatakey];
            
        }];
    }];
    
    _feedDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        HTFindFeedModel *feedModel = input;
        
        NSString *requestURL = [NSString stringWithFormat:@"http://web.breadtrip.com/hunter/product/%@/?bts=app_discover_share",feedModel.product_id];
        
        HTWebViewModel *viewModel = [[HTWebViewModel alloc] initWithServices:self.services params:@{ViewTitlekey:@"活动详情",RequestURLkey:requestURL,NavBarStyleTypekey:@(kNavBarStyleNomal),WebViewTypekey:@(kWebFindDetailType)}];
        
        [[HTMediatorAction sharedInstance] pushWebViewControllerWithViewModel:viewModel];
        
        return [RACSignal empty];
    }];
    
    _commentLinkCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *product_id) {
        
        @strongify(self);
        NSString *requestURL = [NSString stringWithFormat:@"http://web.breadtrip.com/hunter/product/%@/comments/",product_id];
        HTWebViewModel *viewModel = [[HTWebViewModel alloc] initWithServices:self.services params:@{ViewTitlekey:@"全部评价",RequestURLkey:requestURL,NavBarStyleTypekey:@(kNavBarStyleNomal)}];
        
        [[HTMediatorAction sharedInstance] pushWebViewControllerWithViewModel:viewModel];
        return [RACSignal empty];
    }];
    
    _feedMoreConnectionErrors = _feedMoreDataCommand.errors;
}
- (RACSignal *)executeRequestDataSignal:(id)input
{
    @weakify(self);
    return [[[self.services getFindService] requestFindDataSignal:Find_URL] doNext:^(id  _Nullable result) {
        @strongify(self);
        self.videoData = result[FindVideoDatakey];
        self.feedData = result[FindFeedDatakey];
        
    }];
}
@end

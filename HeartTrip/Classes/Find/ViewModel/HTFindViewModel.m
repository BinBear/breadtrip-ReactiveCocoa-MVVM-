//
//  HTFindViewModel.m
//  HeartTrip
//
//  Created by vin on 2021/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTFindViewModel.h"

@interface HTFindViewModel ()
/// 加载更多
@property (copy,  nonatomic, nullable) NSString *next_start;
@end

@implementation HTFindViewModel

- (void)viewModelLoad {
    [super viewModelLoad];
    
    self.next_start = @"0";

}

- (RACCommand *)commandForKey:(NSString *)key {
    @weakify(self);
    // 加载列表
    if (isKey(@"list")) {
        return [RACCommand commandGet:Find_URL
                               params:^id _Nullable(id  _Nonnull input) {
            NSMutableDictionary *para = @{}.mutableCopy;
            para[@"start"] = [input integerValue] == HTRefreshActionType_LoadMore ? self.next_start : @"0";
            para[@"count"] = @20;
            para[@"video_count"] = @10;
            return para;
        }
                            configure:^(HTRequestListConfigure * _Nonnull configure) {
            configure.serverName(@(HTRequestServer_Main));
        }
                        handleCommand:^(id  _Nonnull input, id  _Nonnull response, id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            // 加载更多参数值
            self.next_start = HTJSONMake(response)[HT_Data][@"next_start"].string;
            if ([input integerValue] == HTRefreshActionType_Refresh) {
                [self.feedData removeAllObjects];
                [self.videoData removeAllObjects];
            }
            // 处理feed数据
            NSArray *feeds = HTJSONMake(response)[HT_Data][@"feeds"].array;
            NSArray *feedData = [NSArray yy_modelArrayWithClass:HTFindFeedModel.class json:feeds];
            [self.feedData addObjectsFromArray:feedData];
            // 处理video数据
            NSArray *videos = HTJSONMake(response)[HT_Data][@"videos"].array;
            NSArray *videoData = [NSArray yy_modelArrayWithClass:HTFindVideosModel.class json:videos];
            [self.videoData addObjectsFromArray:videoData];
            if (self.videoData.count) {
                self.refreshSignal(@"1").send(self.videoData);
            }
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
    }
    return [super commandForKey:key];
}

#pragma mark - Getter
- (NSMutableArray *)feedData {
    return HT_LAZY(_feedData, @[].mutableCopy);
}
- (NSMutableArray *)videoData {
    return HT_LAZY(_videoData, @[].mutableCopy);
}
@end

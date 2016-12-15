//
//  HTFindProtocolImpl.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/30.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTFindProtocolImpl.h"
#import "HTFindFeedModel.h"
#import "HTFindVideosModel.h"

@interface HTFindProtocolImpl ()
/**
 *  下一页
 */
@property (copy, nonatomic) NSString *next_start;
/**
 *  feed数组
 */
@property (strong, nonatomic) NSMutableArray *feedsData;
/**
 *  video数组
 */
@property (strong, nonatomic) NSMutableArray *videoData;
/**
 *  发现  model数据
 */
@property (strong, nonatomic) NSMutableDictionary *findData;

@end

@implementation HTFindProtocolImpl

- (RACSignal *)requestFindDataSignal:(NSString *)requestUrl
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSString *lng = [CommonUtils getStrValueInUDWithKey:Longitudekey];
        NSString *lat = [CommonUtils getStrValueInUDWithKey:Latitudekey];
        NSDictionary *params = @{@"count":@"20",
                                 @"lat":lat ? lat : @"22.53512980326447",
                                 @"lng":lng ? lng : @"114.0598045463555",
                                 @"start":@"0",
                                 @"video_count":@"2"};
        
        HTURLSessionTask *task = [HTNetWorking getWithUrl:requestUrl refreshCache:YES showHUD:@"loading..." params:params success:^(id response) {
            
            [self.feedsData removeAllObjects];
            [self.videoData removeAllObjects];
            
            NSDictionary *responseDic = response;
            NSArray *feedsArr = responseDic[@"data"][@"feeds"];
            NSArray *videosArr = responseDic[@"data"][@"videos"];
            self.next_start = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"next_start"]];
            // feed数据
            [feedsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj[@"product"] count] > 0) {
                    
                    HTFindFeedModel *feedModel = [HTFindFeedModel mj_objectWithKeyValues:obj];
                    [self.feedsData addObject:feedModel];
                }

            }];
            // video数据
            [videosArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                HTFindVideosModel *videoModel = [HTFindVideosModel mj_objectWithKeyValues:obj];
                [self.videoData addObject:videoModel];
            }];
            
            [self.findData setValue:self.feedsData forKey:FindFeedDatakey];
            [self.findData setValue:self.videoData forKey:FindVideoDatakey];
            
            [subscriber sendNext:self.findData];
            [subscriber sendCompleted];
            
        } fail:^(NSError *error) {
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];
}
// 加载更多
- (RACSignal *)requestFindMoreDataSignal:(NSString *)requestUrl
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSString *lng = [CommonUtils getStrValueInUDWithKey:Longitudekey];
        NSString *lat = [CommonUtils getStrValueInUDWithKey:Latitudekey];
        NSDictionary *params = @{@"count":@"20",
                                 @"lat":lat ? lat : @"22.53512980326447",
                                 @"lng":lng ? lng : @"114.0598045463555",
                                 @"start":(self.next_start ? self.next_start : @"0"),
                                 @"video_count":@"2"};
        
        HTURLSessionTask *task = [HTNetWorking getWithUrl:requestUrl refreshCache:YES showHUD:@"loading..." params:params success:^(id response) {
            
            NSDictionary *responseDic = response;
            NSArray *feedsArr = responseDic[@"data"][@"feeds"];
            
            self.next_start = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"next_start"]];
            // feed数据
            [feedsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj[@"product"] count] > 0) {
                    
                    HTFindFeedModel *feedModel = [HTFindFeedModel mj_objectWithKeyValues:obj];
                    [self.feedsData addObject:feedModel];
                }
                
            }];
            
            [self.findData setValue:self.feedsData forKey:FindFeedDatakey];
            
            [subscriber sendNext:self.findData];
            [subscriber sendCompleted];
            
        } fail:^(NSError *error) {
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];
}
#pragma mark - getter
- (NSMutableArray *)feedsData
{
    return HT_LAZY(_feedsData, @[].mutableCopy);
}
- (NSMutableArray *)videoData
{
    return HT_LAZY(_videoData, @[].mutableCopy);
}
- (NSMutableDictionary *)findData
{
    return HT_LAZY(_findData, @{}.mutableCopy);
}
@end

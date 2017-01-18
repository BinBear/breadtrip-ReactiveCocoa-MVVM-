//
//  HTExploreMoreImpl.m
//  HeartTrip
//
//  Created by 熊彬 on 17/1/17.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTExploreMoreImpl.h"
#import "HTFindVideosModel.h"

@interface HTExploreMoreImpl ()

/**
 *  下一页
 */
@property (copy, nonatomic) NSString *next_start;
/**
 *  videos数组
 */
@property (strong, nonatomic) NSMutableArray *videosData;


@end

@implementation HTExploreMoreImpl

- (RACSignal *)requestExploreVideosDataSignal:(NSString *)requestUrl
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSString *lng = [CommonUtils getStrValueInUDWithKey:Longitudekey];
        NSString *lat = [CommonUtils getStrValueInUDWithKey:Latitudekey];
        NSDictionary *params = @{@"count":@"20",
                                 @"lat":lat ? lat : @"22.53512980326447",
                                 @"lng":lng ? lng : @"114.0598045463555",
                                 @"start":@"0"
                                 };
        
        HTURLSessionTask *task = [HTNetWorking getWithUrl:requestUrl refreshCache:YES showHUD:@"loading..." params:params success:^(id response) {
            
            [self.videosData removeAllObjects];
            
            NSDictionary *responseDic = response;
            NSArray *videosArr = responseDic[@"data"][@"videos"];
            self.next_start = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"next_start"]];
            
            // video数据
            [videosArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                HTFindVideosModel *videoModel = [HTFindVideosModel mj_objectWithKeyValues:obj];
                [self.videosData addObject:videoModel];
            }];
            
            [subscriber sendNext:self.videosData];
            [subscriber sendCompleted];
            
        } fail:^(NSError *error) {
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];
}
- (RACSignal *)requestExploreVideosMoreDataSignal:(NSString *)requestUrl
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSString *lng = [CommonUtils getStrValueInUDWithKey:Longitudekey];
        NSString *lat = [CommonUtils getStrValueInUDWithKey:Latitudekey];
        NSDictionary *params = @{@"count":@"20",
                                 @"lat":lat ? lat : @"22.53512980326447",
                                 @"lng":lng ? lng : @"114.0598045463555",
                                 @"start":(self.next_start ? self.next_start : @"0")
                                 };
        
        HTURLSessionTask *task = [HTNetWorking getWithUrl:requestUrl refreshCache:YES showHUD:@"loading..." params:params success:^(id response) {
            
            NSDictionary *responseDic = response;
            NSArray *videosArr = responseDic[@"data"][@"videos"];
            self.next_start = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"next_start"]];
            
            // video数据
            [videosArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                HTFindVideosModel *videoModel = [HTFindVideosModel mj_objectWithKeyValues:obj];
                [self.videosData addObject:videoModel];
            }];
            
            [subscriber sendNext:self.videosData];
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
- (NSMutableArray *)videosData
{
    return HT_LAZY(_videosData, @[].mutableCopy);
}
@end

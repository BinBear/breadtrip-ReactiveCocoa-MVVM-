//
//  HTCityTravelProtocolImpl.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/21.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTCityTravelProtocolImpl.h"
#import "HTBannerModel.h"
#import "HTCityTravelItemModel.h"

@interface HTCityTravelProtocolImpl ()
/**
 *   banner数组
 */
@property (strong, nonatomic) NSMutableArray *bannerData;
/**
 *  item数组
 */
@property (strong, nonatomic) NSMutableArray *itemData;
/**
 *  首页model数据
 */
@property (strong, nonatomic) NSMutableDictionary *travelData;
/**
 *  加载更多
 */
@property (copy, nonatomic) NSString *next_start;
@end

@implementation HTCityTravelProtocolImpl

- (RACSignal *)requestCityTravelDataSignal:(NSString *)requestUrl
{
    
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        HTURLSessionTask *task = [HTNetWorking getWithUrl:requestUrl refreshCache:YES showHUD:@"loading..." success:^(id response) {
            
            [self.bannerData removeAllObjects];
            [self.itemData removeAllObjects];
            
            NSDictionary *responseDic = response;
            NSArray *responseArr = responseDic[@"data"][@"elements"];
//            NSArray *searchArr = responseDic[@"data"][@"search_data"];
            self.next_start = [NSString stringWithFormat:@"%@",response[@"data"][@"next_start"]];
           
            [responseArr enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([data[@"type"] integerValue] == 1) {// 广告数据
                    
                    [data[@"data"][0] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        HTBannerModel *bannerModel = [HTBannerModel mj_objectWithKeyValues:obj];
                        [self.bannerData addObject:bannerModel];
                    }];
                    
                }else if ([data[@"type"] integerValue] == 4){// item数据
                    
                    [data[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        HTCityTravelItemModel *bannerModel = [HTCityTravelItemModel mj_objectWithKeyValues:obj];
                        [self.itemData addObject:bannerModel];
                    }];
                }
            }];
            
            [self.travelData setValue:self.bannerData forKey:BannerDatakey];
            [self.travelData setValue:self.itemData forKey:TravelDatakey];
            
            [subscriber sendNext:self.travelData];
            [subscriber sendCompleted];
        } fail:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            
            [task cancel];
        }];
    }];
}
- (RACSignal *)requestCityTravelMoreDataSignal:(NSString *)requestUrl
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        @strongify(self);
        NSDictionary *params = @{@"next_start":(self.next_start ? self.next_start : @"1")};
        
        HTURLSessionTask *task = [HTNetWorking getWithUrl:requestUrl refreshCache:YES showHUD:@"loading..." params:params success:^(id response) {
            
            NSDictionary *responseDic = response;
            NSArray *responseArr = responseDic[@"data"][@"elements"];
            self.next_start = [NSString stringWithFormat:@"%@",response[@"data"][@"next_start"]];
            
            [responseArr enumerateObjectsUsingBlock:^(NSDictionary *data, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([data[@"type"] integerValue] == 4){// item数据
                    
                    [data[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        HTCityTravelItemModel *bannerModel = [HTCityTravelItemModel mj_objectWithKeyValues:obj];
                        [self.itemData addObject:bannerModel];
                    }];
                }
                
            }];
            
            [self.travelData setValue:self.itemData forKey:TravelDatakey];
            
            [subscriber sendNext:self.travelData];
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
- (NSMutableArray *)bannerData
{
    return HT_LAZY(_bannerData, @[].mutableCopy);
}
- (NSMutableArray *)itemData
{
    return HT_LAZY(_itemData, @[].mutableCopy);
}
- (NSMutableDictionary *)travelData
{
    return HT_LAZY(_travelData, @{}.mutableCopy);
}
@end

//
//  HTCityTravelNotesViewModel.m
//  HeartTrip
//
//  Created by vin on 2021/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTCityTravelNotesViewModel.h"

@interface HTCityTravelNotesViewModel ()
/// 加载更多
@property (copy,  nonatomic, nullable) NSString *next_start;
@end

@implementation HTCityTravelNotesViewModel

- (void)viewModelLoad {
    [super viewModelLoad];

}

- (RACCommand *)commandForKey:(NSString *)key {
    @weakify(self);
    // 加载列表
    if (isKey(@"list")) {
        return [RACCommand commandGet:CityTravel_URL
                               params:^id _Nullable(id  _Nonnull input) {
            NSMutableDictionary *para = @{}.mutableCopy;
            para[@"next_start"] = self.next_start;
            return [input integerValue] == HTRefreshActionType_LoadMore ? para : nil;
        }
                            configure:^(HTRequestListConfigure * _Nonnull configure) {
            configure.serverName(@(HTRequestServer_Main));
        }
                        handleCommand:^(id  _Nonnull input, id  _Nonnull response, id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            NSArray *elements = HTJSONMake(response)[HT_Data][@"elements"].array;
            // 加载更多参数值
            self.next_start = HTJSONMake(response)[HT_Data][@"next_start"].string ;
            if ([input integerValue] == HTRefreshActionType_Refresh) {
                [self.bannerData removeAllObjects];
                [self.listData removeAllObjects];
            }
            // 处理banner数据、列表数据
            elements.rac_sequence.signal.filter(^BOOL(id  _Nonnull value) {
                NSInteger type = HTJSONMake(value)[@"type"].integerValue;
                return type == 1 || type == 4 || type == 12;
            }).map(^id _Nonnull(id  _Nonnull value) {
                NSInteger type = HTJSONMake(value)[@"type"].integerValue;
                NSArray *data = HTJSONMake(value)[@"data"].array;
                return RACTuplePack(@(type),type == 1?data.firstObject:data);
            }).subscribeAll(^(RACTuple *value) {
                @strongify(self);
                [value.second enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([value.first integerValue] == 1) {
                        HTBannerModel *bannerModel = [HTBannerModel yy_modelWithDictionary:obj];
                        [self.bannerData addObject:bannerModel];
                    }else{
                        HTCityTravelItemModel *listModel = [HTCityTravelItemModel yy_modelWithDictionary:obj];
                        listModel.type = [value.first integerValue];
                        [self.listData addObject:listModel];
                    }
                }];
                //            DDLogDebug(@"%@ %@",self.bannerData,self.listData);
            }, ^(NSError * _Nonnull error) {
                
            }, ^{
                @strongify(self);
                if (self.bannerData.count) {
                    self.refreshSignal(@"1").send(self.bannerData);
                }
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            });
        }];
    }else if (isKey(@"push")) {
        return ht_commandWithSignal(^RACSignal * _Nonnull(id  _Nonnull input) {
            return ht_pushSignal(@"HTCityTravelDetailController", @"HTCityTravelDetailViewModel", @{@"listItem":input}, true);
        });
    }
    
    return [super commandForKey:key];
}


#pragma mark - Getter
- (NSMutableArray *)bannerData {
    return HT_LAZY(_bannerData, @[].mutableCopy);
}
- (NSMutableArray *)listData {
    return HT_LAZY(_listData, @[].mutableCopy);
}
@end

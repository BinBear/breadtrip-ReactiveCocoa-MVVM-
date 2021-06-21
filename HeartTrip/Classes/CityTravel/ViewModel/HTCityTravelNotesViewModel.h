//
//  HTCityTravelNotesViewModel.h
//  HeartTrip
//
//  Created by vin on 2021/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTBaseViewModel.h"
#import "HTBannerModel.h"
#import "HTCityTravelItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTCityTravelNotesViewModel : HTBaseViewModel

/// banner数据
@property (strong, nonatomic) NSMutableArray *bannerData;
/// 列表数据
@property (strong, nonatomic) NSMutableArray *listData;

@end

NS_ASSUME_NONNULL_END

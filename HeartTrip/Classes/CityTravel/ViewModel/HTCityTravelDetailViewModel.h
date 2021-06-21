//
//  HTCityTravelDetailViewModel.h
//  HeartTrip
//
//  Created by vin on 2021/6/21.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTBaseViewModel.h"
#import "HTCityTravelItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTCityTravelDetailViewModel : HTBaseViewModel
/// 相应游记信息
@property (strong, nonatomic) HTCityTravelItemModel *listItem;
@end

NS_ASSUME_NONNULL_END

//
//  HTCityTravelItemModel.m
//  HeartTrip
//
//  Created by vin on 2021/5/20.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTCityTravelItemModel.h"

@implementation HTUserModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID"  : @"id"};
}
@end

@implementation HTCityTravelItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"travelID"  : @"id"};
}
@end

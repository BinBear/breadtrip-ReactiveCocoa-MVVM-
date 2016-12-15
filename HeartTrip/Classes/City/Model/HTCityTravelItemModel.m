//
//  HTCityTravelItemModel.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/21.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTCityTravelItemModel.h"

@implementation HTCityTravelItemModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"travelID" : @"id"};
}
@end

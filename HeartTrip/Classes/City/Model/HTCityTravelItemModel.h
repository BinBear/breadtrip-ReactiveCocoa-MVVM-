//
//  HTCityTravelItemModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/21.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTUserModel;

@interface HTCityTravelItemModel : NSObject
/**
 *  item背景
 */
@property (copy, nonatomic) NSString *cover_image;
/**
 *  游记标题
 */
@property (copy, nonatomic) NSString *name;
/**
 *  创建时间
 */
@property (copy, nonatomic) NSString *first_day;
/**
 *  游记地点
 */
@property (copy, nonatomic) NSString *popular_place_str;
/**
 *  游记天数
 */
@property (strong, nonatomic) NSNumber *day_count;
/**
 *  浏览人数
 */
@property (strong, nonatomic) NSNumber *view_count;
/**
 *  游记id
 */
@property (strong, nonatomic) NSNumber *travelID;
/**
 *  用户model
 */
@property (strong, nonatomic) HTUserModel *user;
@end

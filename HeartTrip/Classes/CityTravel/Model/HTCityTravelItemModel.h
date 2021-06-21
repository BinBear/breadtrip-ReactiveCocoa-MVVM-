//
//  HTCityTravelItemModel.h
//  HeartTrip
//
//  Created by vin on 2021/5/20.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTUserModel : HTBaseModel

/// 用户头像
@property (copy, nonatomic) NSString *avatar_m;
/// 用户名
@property (copy, nonatomic) NSString *name;
/// 用户id
@property (strong, nonatomic) NSNumber *userID;

@end

@interface HTCityTravelItemModel : HTBaseModel

/// 游记类别
@property (assign, nonatomic) NSInteger  type;
/// item背景
@property (copy, nonatomic) NSString *cover_image;
/// 游记标题
@property (copy, nonatomic) NSString *name;
/// 创建时间
@property (copy, nonatomic) NSString *first_day;
/// 游记地点
@property (copy, nonatomic) NSString *popular_place_str;
/// 游记天数
@property (copy, nonatomic) NSString *day_count;
/// 故事数
@property (copy, nonatomic) NSString *spot_count;
/// 浏览人数
@property (copy, nonatomic) NSString *view_count;
/// 游记id
@property (strong, nonatomic) NSNumber *travelID;
/// 用户model
@property (strong, nonatomic) HTUserModel *user;

@end

NS_ASSUME_NONNULL_END

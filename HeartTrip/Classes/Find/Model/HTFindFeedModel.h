//
//  HTFindFeedModel.h
//  HeartTrip
//
//  Created by vin on 2021/5/24.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTFindUserModel : HTBaseModel
/// 用户头像
@property (copy, nonatomic) NSString *avatar_s;
/// 用户名
@property (copy, nonatomic) NSString *username;
/// 用户id
@property (copy, nonatomic) NSString *ID;
@end


@interface HTFindProductModel : NSObject
/// 项目地点
@property (copy, nonatomic) NSString *address;
/// 项目照片
@property (copy, nonatomic) NSString *cover;
/// 项目距离
@property (copy, nonatomic) NSString *distance;
/// 项目id
@property (copy, nonatomic) NSString *ID;
/// 项目价格
@property (copy, nonatomic) NSString *price;
/// 项目描述
@property (copy, nonatomic) NSString *text;
/// 项目标题
@property (copy, nonatomic) NSString *title;
@end


@interface HTFindFeedModel : HTBaseModel

/// 项目分类
@property (copy, nonatomic) NSString *category;
/// 项目评论人数
@property (copy, nonatomic) NSString *comment_count;
/// 项目创建时间
@property (copy, nonatomic) NSString *date_added;
/// 项目喜欢人数
@property (copy, nonatomic) NSString *liked_count;
/// 项目id
@property (copy, nonatomic) NSString *product_id;
/// 项目标题
@property (copy, nonatomic) NSString *product_title;
/// spotID
@property (copy, nonatomic) NSString *spot_id;
/// 用户model
@property (strong, nonatomic) HTFindUserModel *user;
/// 活动数组
@property (strong, nonatomic) HTFindProductModel *product;
/// 喜欢用户数组
@property (strong, nonatomic) NSArray *liked_users;

@end

NS_ASSUME_NONNULL_END

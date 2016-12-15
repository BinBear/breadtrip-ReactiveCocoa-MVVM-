//
//  HTFindFeedModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/29.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTFindUserModel,HTFindProductModel;

@interface HTFindFeedModel : NSObject
/**
 *  项目分类
 */
@property (copy, nonatomic) NSString *category;
/**
 *  项目评论人数
 */
@property (strong, nonatomic) NSNumber *comment_count;
/**
 *  项目创建时间
 */
@property (copy, nonatomic) NSString *date_added;
/**
 *  项目喜欢人数
 */
@property (strong, nonatomic) NSNumber *liked_count;
/**
 *  项目id
 */
@property (strong, nonatomic) NSNumber *product_id;
/**
 *  项目标题
 */
@property (copy, nonatomic) NSString *product_title;
/**
 *  用户model
 */
@property (strong, nonatomic) HTFindUserModel *user;
/**
 *  活动数组
 */
@property (strong, nonatomic) HTFindProductModel *product;
/**
 *  喜欢用户数组
 */
@property (strong, nonatomic) NSArray *liked_users;
/**
 *  spotID
 */
@property (strong, nonatomic) NSNumber *spot_id;
@end

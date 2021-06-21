//
//  HTFindVideosModel.h
//  HeartTrip
//
//  Created by vin on 2021/5/24.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTFindVideosModel : HTBaseModel

/// 视频拍摄地址
@property (copy, nonatomic) NSString *address;
/// 背景图片地址
@property (copy, nonatomic) NSString *cover;
/// 喜欢人数
@property (copy, nonatomic) NSString *liked_count;
/// 价格
@property (copy, nonatomic) NSString *price;
/// 活动id
@property (copy, nonatomic) NSString *product_id;
/// 活动标题
@property (copy, nonatomic) NSString *product_title;
/// 视频地址
@property (copy, nonatomic) NSString *show_url;
/// 观看人数
@property (copy, nonatomic) NSString *views;
/// 距离
@property (copy, nonatomic) NSString *distance;

@end

NS_ASSUME_NONNULL_END

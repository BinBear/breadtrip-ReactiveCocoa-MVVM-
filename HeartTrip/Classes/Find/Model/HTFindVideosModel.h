//
//  HTFindVideosModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/12/1.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFindVideosModel : NSObject
/**
 *  背景图片地址
 */
@property (copy, nonatomic) NSString *cover;
/**
 *  喜欢人数
 */
@property (strong, nonatomic) NSNumber *liked_count;
/**
 *  价格
 */
@property (copy, nonatomic) NSString *price;
/**
 *  活动id
 */
@property (strong, nonatomic) NSNumber *product_id;
/**
 *  活动标题
 */
@property (copy, nonatomic) NSString *product_title;
/**
 *  视频地址
 */
@property (copy, nonatomic) NSString *show_url;
/**
 *  观看人数
 */
@property (strong, nonatomic) NSNumber *views;
@end

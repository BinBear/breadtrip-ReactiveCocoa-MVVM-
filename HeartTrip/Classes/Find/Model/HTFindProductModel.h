//
//  HTFindProductModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/29.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFindProductModel : NSObject
/**
 *  项目地点
 */
@property (copy, nonatomic) NSString *address;
/**
 *  项目照片
 */
@property (copy, nonatomic) NSString *cover;
/**
 *  项目距离
 */
@property (copy, nonatomic) NSString *distance;
/**
 *  项目id
 */
@property (strong, nonatomic) NSNumber *ID;
/**
 *  项目价格
 */
@property (copy, nonatomic) NSString *price;
/**
 *  项目描述
 */
@property (copy, nonatomic) NSString *text;
/**
 *  项目标题
 */
@property (copy, nonatomic) NSString *title;
@end

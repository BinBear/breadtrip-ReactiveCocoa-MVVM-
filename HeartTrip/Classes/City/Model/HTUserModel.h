//
//  HTUserModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/22.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTUserModel : NSObject
/**
 *  用户头像
 */
@property (copy, nonatomic) NSString *avatar_m;
/**
 *  用户名
 */
@property (copy, nonatomic) NSString *name;
/**
 *  用户id
 */
@property (strong, nonatomic) NSNumber *userID;
@end

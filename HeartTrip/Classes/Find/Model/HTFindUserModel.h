//
//  HTFindUserModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/29.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFindUserModel : NSObject
/**
 *  用户头像
 */
@property (copy, nonatomic) NSString *avatar_s;
/**
 *  用户名
 */
@property (copy, nonatomic) NSString *username;
/**
 *  用户id
 */
@property (strong, nonatomic) NSNumber *ID;
@end

//
//  HTUserModel.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/22.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTUserModel.h"

@implementation HTUserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userID" : @"id"};
}
@end

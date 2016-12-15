//
//  HTFindFeedModel.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/29.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTFindFeedModel.h"

@implementation HTFindFeedModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"liked_users" : @"HTFindUserModel"};
}
@end

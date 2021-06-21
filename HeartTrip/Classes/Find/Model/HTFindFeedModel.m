//
//  HTFindFeedModel.m
//  HeartTrip
//
//  Created by vin on 2021/5/24.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTFindFeedModel.h"

@implementation HTFindUserModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID"  : @"id"};
}
@end

@implementation HTFindProductModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID"  : @"id"};
}
@end

@implementation HTFindFeedModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"liked_users" : [HTFindUserModel class]};
}
@end

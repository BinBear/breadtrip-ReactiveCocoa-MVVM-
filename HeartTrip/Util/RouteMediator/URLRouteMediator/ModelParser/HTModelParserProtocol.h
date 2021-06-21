//
//  HTModelParserProtocol.h
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HTModelParserProtocol <NSObject>

+ (nullable instancetype)ht_modelWithJSON:(id)json;
+ (NSArray *)ht_modelArrayWithJSON:(id)json;
- (void)ht_modelSetWithJSON:(id)json;

- (nullable id)ht_modelToJSONObject;
- (nullable NSData *)ht_modelToJSONData;
- (nullable NSString *)ht_modelToJSONString;


+ (nullable NSArray<NSString *> *)ht_modelPropertyBlacklist;
+ (nullable NSArray<NSString *> *)ht_modelPropertyWhitelist;
+ (nullable NSDictionary<NSString *, id> *)ht_modelCustomPropertyMapper;
+ (nullable NSDictionary<NSString *, id> *)ht_modelContainerPropertyGenericClass;
- (void)ht_modelDidParsedWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

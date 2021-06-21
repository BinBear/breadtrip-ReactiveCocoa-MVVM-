//
//  NSObject+HTModelParser.m
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "NSObject+HTModelParser.h"

#if __has_include(<YYModel/YYModel.h>)
#import <YYModel/YYModel.h>
#endif

#if __has_include(<MJExtension/MJExtension.h>)
#import <MJExtension/MJExtension.h>
#endif

#define _YYMODEL  __has_include(<YYModel/YYModel.h>)
#define _MJEXTENSION  __has_include(<MJExtension/MJExtension.h>)


@implementation NSObject (HTModelParser)


+ (nullable instancetype)ht_modelWithJSON:(id)json {
#ifdef _YYMODEL
    return [self yy_modelWithJSON:json];
#else
    return [self mj_objectWithKeyValues:json];
#endif
}

- (void)ht_modelSetWithJSON:(id)json {
#ifdef _YYMODEL
    [self yy_modelSetWithJSON:json];
#else
    [self mj_setKeyValues:json];
#endif
}

+ (NSArray *)ht_modelArrayWithJSON:(id)json {
#ifdef _YYMODEL
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
#else
    return [self mj_objectArrayWithKeyValuesArray:json].copy;
#endif
}

- (nullable id)ht_modelToJSONObject {
#ifdef _YYMODEL
    return [self yy_modelToJSONObject];
#else
    return [self mj_JSONObject];
#endif
}

- (nullable NSData *)ht_modelToJSONData {
#ifdef _YYMODEL
    return [self yy_modelToJSONData];
#else
    return [self mj_JSONData];
#endif
}

- (nullable NSString *)ht_modelToJSONString {
#ifdef _YYMODEL
    return [self yy_modelToJSONString];
#else
    return [self mj_JSONString];
#endif
}


#ifdef _YYMODEL
+ (nullable NSArray<NSString *> *)modelPropertyWhitelist {
    return [self ht_modelPropertyWhitelist];
}
+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return [self ht_modelPropertyBlacklist];
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return [self ht_modelCustomPropertyMapper];
}
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return [self ht_modelContainerPropertyGenericClass];
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self ht_modelDidParsedWithDictionary:dic];
    return YES;
}
#else
+ (NSArray *)mj_allowedPropertyNames {
    return [self ht_modelPropertyWhitelist];
}
+ (NSArray *)mj_ignoredPropertyNames {
    return [self ht_modelPropertyBlacklist];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return [self ht_modelCustomPropertyMapper];
}
+ (NSDictionary *)mj_objectClassInArray {
    return [self ht_modelContainerPropertyGenericClass];
}
- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    [self ht_modelDidParsedWithDictionary:keyValues];
}
#endif


+ (nullable NSArray<NSString *> *)ht_modelPropertyBlacklist {return nil;}
+ (nullable NSArray<NSString *> *)ht_modelPropertyWhitelist {return nil;}
+ (nullable NSDictionary<NSString *, id> *)ht_modelCustomPropertyMapper {return nil;}
+ (nullable NSDictionary<NSString *, id> *)ht_modelContainerPropertyGenericClass {return nil;}
- (void)ht_modelDidParsedWithDictionary:(NSDictionary *)dictionary {}

@end

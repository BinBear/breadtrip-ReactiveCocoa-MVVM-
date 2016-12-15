//
//  NSDictionary+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (BinAdd)

#pragma mark - Dictionary Convertor
///=============================================================================
/// @name Dictionary Convertor
///=============================================================================

/**
 * 将属性列表数据转换为 NSDictionary 返回。
 */
+ (nullable NSDictionary *)dictionaryWithPlistData:(NSData *)plist;

/**
 * 将xml格式的属性列表字符串转换为 NSDictionary 返回。
 */
+ (nullable NSDictionary *)dictionaryWithPlistString:(NSString *)plist;

/**
 * 将字典转换为二进制的属性列表数据。
 */
- (nullable NSData *)plistData;

/**
 * 将字典转换为xml格式的属性列表字符串。
 */
- (nullable NSString *)plistString;

/**
 * 返回一个包含字典所有 key 的升序数组，key 必须为 NSString。
 */
- (NSArray *)allKeysSorted;

/**
 * 返回一个包含字典所有的 value 数组，数组 value 的顺序对应字典所有 key 的升序数组，key 必须为 NSString。
 */
- (NSArray *)allValuesSortedByKeys;

/**
 * 判断 key 对应的 value 是否不为 nil 。
 */
- (BOOL)containsObjectForKey:(id)key;

/**
 * 返回一个新的字典，该字典包含原字典所有 keys 及它们对应的值。
 */
- (NSDictionary *)entriesForKeys:(NSArray *)keys;

/**
 * 字典转为 json 字符串，错误返回 nil 。
 */
- (nullable NSString *)jsonStringEncoded;

/**
 * 字典转为格式化后的 json 字符串，错误返回 nil，这样可读性高，不格式化则输出的 json 字符串就是一整行。
 */
- (nullable NSString *)jsonPrettyStringEncoded;

/**
 * 将 NSData 或 NSString 类型的 XML 数据转成字典。
 */
+ (nullable NSDictionary *)dictionaryWithXML:(id)xmlDataOrString;

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

// 从字典里获取 key 对应的值，如果值非 NSNumber 和 NSString 类型, 返回默认值 def，有的话将值强转成返回类型然后返回，其中 NSString 类型不区分大小写后为 @“true” 或者 @“no”，则先转成 BOOL 类型数据 YES 。为 @“false” @“no” 则先转成 BOOL 类型数据 NO，为 @“nil” 和 @“null” 则先转成 nil，转完再强转返回类型返回。
- (BOOL)boolValueForKey:(NSString *)key default:(BOOL)def;

- (char)charValueForKey:(NSString *)key default:(char)def;
- (unsigned char)unsignedCharValueForKey:(NSString *)key default:(unsigned char)def;

- (short)shortValueForKey:(NSString *)key default:(short)def;
- (unsigned short)unsignedShortValueForKey:(NSString *)key default:(unsigned short)def;

- (int)intValueForKey:(NSString *)key default:(int)def;
- (unsigned int)unsignedIntValueForKey:(NSString *)key default:(unsigned int)def;

- (long)longValueForKey:(NSString *)key default:(long)def;
- (unsigned long)unsignedLongValueForKey:(NSString *)key default:(unsigned long)def;

- (long long)longLongValueForKey:(NSString *)key default:(long long)def;
- (unsigned long long)unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def;

- (float)floatValueForKey:(NSString *)key default:(float)def;
- (double)doubleValueForKey:(NSString *)key default:(double)def;

- (NSInteger)integerValueForKey:(NSString *)key default:(NSInteger)def;
- (NSUInteger)unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def;

- (nullable NSNumber *)numverValueForKey:(NSString *)key default:(nullable NSNumber *)def;
- (nullable NSString *)stringValueForKey:(NSString *)key default:(nullable NSString *)def;
#pragma mark - Merge
///=============================================================================
/// @name Merge
///=============================================================================
/**
 *  @brief  合并两个NSDictionary
 *
 *  @param dict1 NSDictionary
 *  @param dict2 NSDictionary
 *
 *  @return 合并后的NSDictionary
 */
+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;
/**
 *  @brief  并入一个NSDictionary
 *
 *  @param dict NSDictionary
 *
 *  @return 增加后的NSDictionary
 */
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
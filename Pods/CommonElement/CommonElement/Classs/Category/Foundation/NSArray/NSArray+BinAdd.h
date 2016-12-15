//
//  NSArray+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (BinAdd)

/**
 * 将属性列表数据转换为 NSArray 返回.
 */
+ (nullable NSArray *)arrayWithPlistData:(NSData *)plist;

/**
 * 将xml格式的属性列表字符串转换为 NSArray 返回.
 */
+ (nullable NSArray *)arrayWithPlistString:(NSString *)plist;

/**
 * 将数组转换为二进制的属性列表数据.
 */
- (nullable NSData *)plistData;

/**
 * 将数组转换为xml格式的属性列表字符串。
 */
- (nullable NSString *)plistString;

/**
 * 随机返回数组里的一个元素。
 */
- (nullable id)randomObject;

/**
 * 返回 index 位置的元素，越界时候返回 nil。
 */
- (nullable id)objectOrNilAtIndex:(NSUInteger)index;

/**
 * 将属性列表数据转换为 NSArray 返回.
 */
- (nullable NSString *)jsonStringEncoded;

/**
 * 数组转为格式化后的 json 字符串，错误返回 nil，这样可读性高，不格式化则输出的 json 字符串就是一整行。
 */
- (nullable NSString *)jsonPrettyStringEncoded;

@end

NS_ASSUME_NONNULL_END
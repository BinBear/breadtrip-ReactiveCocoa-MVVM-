//
//  NSMutableArray+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSMutableArray (BinAdd)
/**
 *  将属性列表数据转换为 NSMutableArray 返回。
 */
+ (nullable NSMutableArray *)arrayWithPlistData:(NSData *)plist;

/**
 *  将xml格式的属性列表字符串转换为 NSMutableArray 返回。
 */
+ (nullable NSMutableArray *)arrayWithPlistString:(NSString *)plist;

/**
 *  移除数组里第一个元素，如果数组为空则不操作。
 */
- (void)removeFirstObject;

/**
 *  移除数组里最后一个元素，如果数组为空则不操作。
 */
- (void)removeLastObject;

/**
 *  移除数组里第一个元素，并返回这个元素，如果数组为空则不操作。
 */
- (nullable id)popFirstObject;

/**
 *  移除数组里最后一个元素，并返回这个元素，如果数组为空则不操作。
 */
- (nullable id)popLastObject;

/**
 *  添加一个元素到数组末端。
 */
- (void)appendObject:(id)anObject;

/**
 *  插入一个元素到数组首端。
 */
- (void)prependObject:(id)anObject;

/**
 *  将数组 objects 里的所有元素按 objects 里的顺序添加到数组末端。
 */
- (void)appendObjects:(NSArray *)objects;

/**
 *  将数组 objects 里的所有元素按 objects 里的顺序添加到数组首端。
 */
- (void)prependObjects:(NSArray *)objects;

/**
 *  将数组 objects 里的所有元素按 objects 里的顺序添加到数组 index 位置，index 不能大于数组元素的个数。
 */
- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

/**
 *  逆序数组元素。
 */
- (void)reverse;

/**
 *  将数组里的元素随机排序。
 */
- (void)shuffle;

@end
NS_ASSUME_NONNULL_END

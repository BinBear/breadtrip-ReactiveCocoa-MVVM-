//
//  NSNumber+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (BinAdd)
#pragma mark - NumberWithString
///=============================================================================
/// @name numberWithString
///=============================================================================

/**
 * 字符串转换为 NSNumber，转换失败返回nil
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
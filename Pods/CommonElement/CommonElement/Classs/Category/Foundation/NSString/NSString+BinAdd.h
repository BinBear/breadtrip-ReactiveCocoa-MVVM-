//
//  NSString+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BinAdd)
#pragma mark - Hash
///=============================================================================
/// @name Hash
///=============================================================================

/**
 *  md2 hash, 返回小写字符串.
 */
- (nullable NSString *)md2String;

/**
 *  md4 hash, 返回小写字符串.
 */
- (nullable NSString *)md4String;

/**
 *  md5 hash, 返回小写字符串.
 */
- (nullable NSString *)md5String;

/**
 *  sha1 hash, 返回小写字符串.
 */
- (nullable NSString *)sha1String;

/**
 *  sha224 hash, 返回小写字符串.
 */
- (nullable NSString *)sha224String;

/**
 *  sha256 hash, 返回小写字符串.
 */
- (nullable NSString *)sha256String;

/**
 *  sha384 hash, 返回小写字符串.
 */
- (nullable NSString *)sha384String;

/**
 *  sha512 hash, 返回小写字符串.
 */
- (nullable NSString *)sha512String;

/**
 * HMAC MD5 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (nullable NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 * HMAC SHA1 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (nullable NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 * HMAC SHA224 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (nullable NSString *)hmacSHA224StringWithKey:(NSString *)key;

/**
 * HMAC SHA256 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (nullable NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 * HMAC SHA384 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (nullable NSString *)hmacSHA384StringWithKey:(NSString *)key;

/**
 * HMAC SHA512 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (nullable NSString *)hmacSHA512StringWithKey:(NSString *)key;


#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 * 采用 base64 对 字符串 进行编码。为了使二进制数据可以通过非纯 8-bit 的传输层传输.
 */
- (nullable NSString *)base64EncodedString;

/**
 * 对 base64 编码字符串进行解码
 */
+ (nullable NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 * URL 编码，使用 string 符合 URL 的规范，因为在标准的 URL 规范中中文和很多的字符是不允许出现在 URL 中的。
 */
- (NSString *)stringByURLEncode;

/**
 * URL 解码，返回 URL 编码前的字符串.
 */
- (NSString *)stringByURLDecode;

/**
 * 使字符串避开 HTML 语句，例如："a<b" 转成 "a&lt;b"。
 */
- (NSString *)stringByEscapingHTML;

#pragma mark - Drawing
///=============================================================================
/// @name Drawing
///=============================================================================

/**
 * 给出最大宽高，计算字符串的 size.
 
 * @param font     字符串的字体.
 
 * @param size     最大宽高.
 
 * @param lineBreakMode  see NSLineBreakMode.
 
 * @return          返回计算后的尺寸.
 */
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 * 返回字符串的宽度
 */
- (CGFloat)widthForFont:(UIFont *)font;

/**
 * 给出最大宽度，返回字符串的高度
 */
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;


#pragma mark - NSNumber Compatible
///=============================================================================
/// @name NSNumber Compatible
///=============================================================================

// 兼容 NSNumber 的部分属性，用这些属性时可以将 NSString 当做 NSNumber 来使用.
@property (readonly) char charValue;
@property (readonly) unsigned char unsignedCharValue;
@property (readonly) short shortValue;
@property (readonly) unsigned short unsignedShortValue;
@property (readonly) unsigned int unsignedIntValue;
@property (readonly) long longValue;
@property (readonly) unsigned long unsignedLongValue;
@property (readonly) unsigned long long unsignedLongLongValue;
@property (readonly) NSUInteger unsignedIntegerValue;


#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================

/**
 * 生成一个 UUID（通用唯一识别码）
 */
+ (NSString *)stringWithUUID;

/**
 * 将 UTF32 Char 字符串转换为NSString
 */
+ (nullable NSString *)stringWithUTF32Char:(UTF32Char)char32;

/**
 * 将长度为 length 的 UTF32 Char 字符串数组转换为 NSString
 
 * @param char32 An array of UTF-32 character.
 * @param length The character count in array.
 * @return A new string, or nil if an error occurs.
 */
+ (nullable NSString *)stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length;

/**
 * 将range位置的字符转为 UTF32 Char 字符串数组再枚举数组元素执行 block ，直到设置 *stop 为 YES
 */
- (void)enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block;

/**
 * 去掉在头部和尾部的空白字符（空格和换行）
 */
- (NSString *)stringByTrim;

/**
 * 添加scale到文件名末尾，例如 /p/name.png 变成 /p/name.png@2x.
 */
- (NSString *)stringByAppendingNameScale:(CGFloat)scale;

/**
 * 添加scale到文件路径末尾，例如 /p/name.png 变成 /p/name@2x.png.
 */
- (NSString *)stringByAppendingPathScale:(CGFloat)scale;

/**
 * 返回文件的 Scalee. e.g：
 <table>
 <tr><th>Path            </th><th>Scale </th></tr>
 <tr><td>"icon.png"      </td><td>1     </td></tr>
 <tr><td>"icon@2x.png"   </td><td>2     </td></tr>
 <tr><td>"icon@2.5x.png" </td><td>2.5   </td></tr>
 <tr><td>"icon@2x"       </td><td>1     </td></tr>
 <tr><td>"icon@2x..png"  </td><td>1     </td></tr>
 <tr><td>"icon@2x.png/"  </td><td>1     </td></tr>
 </table>
 */
- (CGFloat)pathScale;

/**
 * 判断字符串是否不为空， nil, @"", @"  ", @"\n" 都是空. 如果为空返回：NO 非空返回：YES
 */
- (BOOL)isNotBlank;

/**
 * 判断字符串是否包含 string
 */
- (BOOL)containsString:(NSString *)string;

/**
 * 判断字符串是否包含 set 。NSCharacterSet为一组Unicode字符。
 */
- (BOOL)containsCharacterSet:(NSCharacterSet *)set;

/**
 * 字符串转换为 NSNumber，转换失败返回nil
 */
- (nullable NSNumber *)numberValue;

/**
 * 字符串转换为 UTF-8 编码的数据
 */
- (nullable NSData *)dataValue;

/**
 * 返回一个起点为 0，宽度为字符串字符长度的 NSRange数据
 */
- (NSRange)rangeOfAll;

/**
 * 将json字符串进行解码，返回一个字典或者字符串。例如 NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count”:@2]。
 */
- (nullable id)jsonValueDecoded;

/**
 * 获取 UTF8 编码 name 文件里的内容。类似[UIImage imageNamed:]
 */
+ (nullable NSString *)stringNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
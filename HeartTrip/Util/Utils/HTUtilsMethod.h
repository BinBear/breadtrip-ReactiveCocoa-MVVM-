//
//  HTUtilsMethod.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/24.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTUtilsMethod : NSObject

/// 切割字符串
NSMutableArray *componentsSeparatByString (NSString *numStr, NSString *separatStr);

/// 删除小数点后面的0
NSString *changeFloat(NSString *stringFloat);

/// 根据精度格式化字符串，是否加逗号  num: 格式化数字  precision: 精度 isSeparate: 是否加逗号
NSString *stringFormatterCommaWithNumber(id num, NSInteger precision, BOOL isSeparate);

/// 解决服务器返回数据精度丢失问题
NSString *precisionControl(NSNumber *balance);

/// 获取小数位数精度
NSInteger getNumberDecimalDigits(double number);

/// 给数字加逗号
NSString *separateNumberUseCommaWith(NSString *number);

/// 数量小数位处理，超过10000则以 万 为单位
NSString *countTextCharsForNumber(id number, NSInteger digit);

@end

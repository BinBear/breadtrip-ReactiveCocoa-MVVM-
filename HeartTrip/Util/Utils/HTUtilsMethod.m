//
//  HTUtilsMethod.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/24.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTUtilsMethod.h"

@implementation HTUtilsMethod

/// 切割字符串
NSMutableArray *componentsSeparatByString (NSString *numStr, NSString *separatStr){
    NSMutableArray *tempArr = @[].mutableCopy;
    if ([numStr isKindOfClass:NSString.class] &&
        [numStr isNotBlank] &&
        [separatStr isKindOfClass:NSString.class] &&
        [separatStr isNotBlank]) {
        NSArray *arr = [numStr componentsSeparatedByString:separatStr];
        for (NSString *temp in arr) {
            if ([temp isNotBlank]) {
                [tempArr addObject:temp];
            }
        }
    }
    return tempArr;
}

/// 删除小数点后面的0
NSString *changeFloat(NSString *stringFloat){
    NSInteger length = [stringFloat length];
    if ([stringFloat containsString:@"."]) {
        for(NSInteger i = length - 1; i >= 0; i--){
            NSString *subString = [stringFloat substringFromIndex:i];
            if(![subString isEqualToString:@"0"]){
                if ([subString isEqualToString:@"."]) {
                    return [stringFloat substringToIndex:[stringFloat length] - 1];
                }else{
                    return stringFloat;
                }
            }else{
                stringFloat = [stringFloat substringToIndex:i];
            }
        }
    }
    return stringFloat;
}

/// 根据精度格式化字符串，是否加逗号  num: 格式化数字  precision: 精度 isSeparate: 是否加逗号
NSString *stringFormatterCommaWithNumber(id num, NSInteger precision, BOOL isSeparate){
    NSDecimalNumber *amount ;
    if ([num isKindOfClass:NSNumber.class]) {
        amount = [NSDecimalNumber decimalNumberWithString:precisionControl(num)];
    }else if ([num isKindOfClass:NSString.class]){
        amount = [NSDecimalNumber decimalNumberWithString:num];
    }else if([num isKindOfClass:NSDecimalNumber.class]){
        amount = num;
    }
    if (!amount) { return @"";}
    
    NSString *str = [NSString vv_stringFromNumber:amount fractionDigits:precision];
    if (isSeparate) {
        return separateNumberUseCommaWith(str);
    }else{
        return str;
    }
}

/// 解决服务器返回数据精度丢失问题
NSString *precisionControl(NSNumber *balance){
    double tempBalance = balance.doubleValue;
    NSInteger length = getNumberDecimalDigits(tempBalance);
    if (length >= 12) {
        length = 12;
    }
    double total = pow(10, length);
    long double rounded_up = round(tempBalance * total) / total;
    NSString *str = [NSString vv_stringWithFormat:@"%.*Lf",(int)length,rounded_up];
    return changeFloat(str);
}

/// 获取小数位数精度
NSInteger getNumberDecimalDigits(double number) {
    if (number == (long)number) {
        return 0;
    }
    NSInteger i = 0;
    while (true){
        i++;
        double total = number * pow(10, i);
        if (fmod(total,1) == 0) {
            return i;
        }
    }
}

/// 给数字加逗号
NSString *separateNumberUseCommaWith(NSString *number){
    NSString *replacedStr = [number stringByReplacingOccurrencesOfString:@"," withString:@"."];
    // 分隔符
    NSString *divide = @",";
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([replacedStr containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [replacedStr componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = replacedStr;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
    return newNumber;
}

/// 数量小数位处理，超过10000则以 万 为单位
NSString *countTextCharsForNumber(id number, NSInteger digit){

    NSDecimalNumber *amount;
    if ([number isKindOfClass:NSNumber.class]) {
        amount = [NSDecimalNumber decimalNumberWithString:[number stringValue]];
    }else if ([number isKindOfClass:NSString.class]){
        amount = [NSDecimalNumber decimalNumberWithString:number];
    }
    if (!amount) { return nil; }
    
    NSDecimalNumber *mNumber = [NSDecimalNumber decimalNumberWithString:@"10000"];
    NSString *textNumber = [NSString vv_stringWithFormat:@"%@",number];
    NSString *moneySymbol = @"";
    if ([amount compare:mNumber] == NSOrderedDescending) {
        NSDecimalNumber *result = [amount vv_safeDecimalNumberByDividing:mNumber];
        textNumber = stringFormatterCommaWithNumber(result, digit, false);
        moneySymbol = @"万";
        textNumber = [NSString vv_stringWithFormat:@"%@%@",textNumber,moneySymbol];
    }
    
    return textNumber;
}

@end

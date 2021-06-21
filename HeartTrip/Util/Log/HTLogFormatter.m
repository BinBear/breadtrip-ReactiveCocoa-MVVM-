//
//  HTLogFormatter.m
//  HeartTrip
//
//  Created by vin on 2020/11/12.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTLogFormatter.h"

@interface HTLogFormatter(){
    int atomicLoggerCounter;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end

static NSString *const KdateFormatString = @"yyyy/MM/dd HH:mm:ss";

@implementation HTLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"Error";   break;
        case DDLogFlagWarning  : logLevel = @"Warning"; break;
        case DDLogFlagInfo     : logLevel = @"Info";    break;
        case DDLogFlagDebug    : logLevel = @"Debug";   break;
        default                : logLevel = @"Verbose"; break;
            
    }
    // 日期和时间
    NSString *dateAndTime = [self stringFromDate:logMessage.timestamp];
    // 文件名
    NSString *logFileName = logMessage -> _fileName;
    // 方法名
    NSString *logFunction = logMessage -> _function;
    // 行号
    NSUInteger logLine = logMessage -> _line;
    // 日志消息
    NSString *logMsg = logMessage->_message;
    
    // 日志格式：日期和时间 文件名 方法名 : 行数 <日志等级> 日志消息
    return [NSString stringWithFormat:@"%@ %@ %@ : %lu <%@>: %@", dateAndTime, logFileName, logFunction, logLine, logLevel, logMsg];
}
- (NSString *)stringFromDate:(NSDate *)date {
    
    if (atomicLoggerCounter <= 1) {
        
        if (threadUnsafeDateFormatter == nil) {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setDateFormat:KdateFormatString];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
    } else {
        
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:KdateFormatString];
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}
- (void)didAddToLogger:(id <DDLogger>)logger {
    atomicLoggerCounter++;
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    atomicLoggerCounter--;
}

@end

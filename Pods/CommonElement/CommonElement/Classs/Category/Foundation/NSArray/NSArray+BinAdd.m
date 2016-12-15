//
//  NSArray+BinAdd.m
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import "NSArray+BinAdd.h"
#import "NSData+BinAdd.h"

@implementation NSArray (BinAdd)
+ (NSArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]]) return array;
    return nil;
}

+ (NSArray *)arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

- (NSData *)plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (NSString *)plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return xmlData.utf8String;
    return nil;
}

- (id)randomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (id)objectOrNilAtIndex:(NSUInteger)index {
    return index < self.count ? self[index] : nil;
}

- (NSString *)jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

- (NSString *)jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString * string = [NSMutableString string];
    [string appendString:@"[\n"];
    NSUInteger count = self.count;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * temp = nil;
        if ([obj respondsToSelector:@selector(descriptionWithLocale:)]) {
            temp = [obj performSelector:@selector(descriptionWithLocale:) withObject:locale];
            temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
        } else {
            temp = [obj performSelector:@selector(description) withObject:nil];
            if ([obj isKindOfClass:[NSString class]]) {
                temp = [NSString stringWithFormat:@"\"%@\"", temp];
            }
        }
        [string appendFormat:@"\t%@", temp];
        if (idx+1 != count) {
            [string appendString:@","];
        }
        [string appendString:@"\n"];
    }];
    [string appendString:@"]"];
    return string;
}
@end


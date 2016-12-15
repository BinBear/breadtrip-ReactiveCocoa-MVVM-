//
//  NSMutableArray+BinAdd.m
//  CommonElement
//
//  Created by 熊彬 on 16/6/3.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import "NSMutableArray+BinAdd.h"

@implementation NSMutableArray (BinAdd)
+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) return array;
    return nil;
}

+ (NSMutableArray *)arrayWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

- (void)removeFirstObject {
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)removeLastObject {
    if (self.count) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

#pragma clang diagnostic pop


- (id)popFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self removeFirstObject];
    }
    return obj;
}

- (id)popLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

- (void)appendObject:(id)anObject {
    [self addObject:anObject];
}

- (void)prependObject:(id)anObject {
    [self insertObject:anObject atIndex:0];
}

- (void)appendObjects:(NSArray *)objects {
    if (!objects) return;
    [self addObjectsFromArray:objects];
}

- (void)prependObjects:(NSArray *)objects {
    if (!objects) return;
    NSUInteger i = 0;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

- (void)reverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end

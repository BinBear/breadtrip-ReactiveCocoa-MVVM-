//
//  QTDisposeBag.m
//  QTEventBus
//
//  Created by Leo on 2018/6/4.
//  Copyright © 2018年 Leo Huang. All rights reserved.
//

#import "QTDisposeBag.h"
#import <os/lock.h>

@interface QTDisposeBag()

@property (strong, nonatomic) NSMutableArray<id<QTEventToken>> * tokens;
@property (assign, nonatomic) os_unfair_lock  taskLock;

@end

@implementation QTDisposeBag

- (NSMutableArray<id<QTEventToken>> *)tokens{
    if (!_tokens) {
        _tokens = [[NSMutableArray alloc] init];
        _taskLock = OS_UNFAIR_LOCK_INIT;
    }
    return _tokens;
}

- (void)addToken:(id<QTEventToken>)token{
    os_unfair_lock_lock(&_taskLock);
    if (token && [token conformsToProtocol:@protocol(QTEventToken)]) {
        [self.tokens addObject:token];
    }
    os_unfair_lock_unlock(&_taskLock);
}

- (void)dealloc{
    os_unfair_lock_lock(&_taskLock);
    for (id<QTEventToken> token in self.tokens) {
        if ([token respondsToSelector:@selector(dispose)]) {
            [token dispose];
        }
    }
    os_unfair_lock_unlock(&_taskLock);
}

@end

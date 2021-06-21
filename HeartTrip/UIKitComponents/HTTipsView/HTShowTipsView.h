//
//  HTShowTipsView.h
//  HeartTrip
//
//  Created by vin on 2020/11/19.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTShowTipsView : NSObject

/**
 *  展示提示信息
 *
 *  @param message 信息内容
 */
+ (void)showTips:(NSString *)message;
+ (RACSignal *(^)(NSString *message))signal;
+ (RACCommand *(^)(NSString *message))command;


/**
 *  展示提示信息
 *
 *  @param message  信息内容
 *  @param position 展示的位置
 *  @param point    偏移位置
 */
+ (void)showTips:(NSString *)message withPosition:(QMUIToastViewPosition)position withOffset:(CGPoint)point;
+ (RACSignal *(^)(NSString *message,QMUIToastViewPosition,CGPoint))signalPosition;
+ (RACCommand *(^)(NSString *message,QMUIToastViewPosition,CGPoint))commandPosition;

@end

NS_ASSUME_NONNULL_END

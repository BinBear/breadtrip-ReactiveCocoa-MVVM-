//
//  HTLBSManager.h
//  HeartTrip
//
//  Created by 熊彬 on 16/12/1.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTLBSManager;
@protocol HTLBSManagerDelegate <NSObject>

@optional
- (void)getLbsSuccessWithLongitude:(NSString *)longitude latitude:(NSString *)latitude;

@end

@interface HTLBSManager : NSObject

@property (nonatomic, assign) id<HTLBSManagerDelegate>delegate;

+ (HTLBSManager *)startGetLBSWithDelegate:(id<HTLBSManagerDelegate>)delegate;

@end

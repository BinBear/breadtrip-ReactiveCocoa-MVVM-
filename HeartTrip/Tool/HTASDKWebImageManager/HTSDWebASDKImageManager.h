//
//  HTSDWebASDKImageManager.h
//  HeartTrip
//
//  Created by 熊彬 on 2017/9/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <SDWebImage/SDWebImageManager.h>

@interface HTSDWebASDKImageManager : NSObject<ASImageCacheProtocol, ASImageDownloaderProtocol>

@property (nonatomic, assign) SDWebImageOptions webImageOptions;
@property (nonatomic, strong, readonly) SDWebImageManager *webImageManager;


+ (instancetype)sharedManager;

@end

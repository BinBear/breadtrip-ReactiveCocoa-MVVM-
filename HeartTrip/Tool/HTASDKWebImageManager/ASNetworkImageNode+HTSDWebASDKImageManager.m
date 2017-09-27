//
//  ASNetworkImageNode+HTSDWebASDKImageManager.m
//  HeartTrip
//
//  Created by 熊彬 on 2017/9/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "ASNetworkImageNode+HTSDWebASDKImageManager.h"
#import "HTSDWebASDKImageManager.h"

@implementation ASNetworkImageNode (HTSDWebASDKImageManager)

- (instancetype)initWithWebImage
{
    HTSDWebASDKImageManager *imageManager = [HTSDWebASDKImageManager sharedManager];
    return [self initWithCache:imageManager downloader:imageManager];
}

@end

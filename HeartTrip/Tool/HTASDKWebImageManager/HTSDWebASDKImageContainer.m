//
//  HTSDWebASDKImageContainer.m
//  HeartTrip
//
//  Created by 熊彬 on 2017/9/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTSDWebASDKImageContainer.h"

@implementation HTSDWebASDKImageContainer

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

+ (instancetype)containerForImage:(UIImage *)image {
    return [[self alloc] initWithImage:image];
}

#pragma mark - ASImageContainerProtocol

- (nullable UIImage *)asdk_image {
    return _image;
}

- (NSData *)asdk_animatedImageData {
    return nil;
}

@end

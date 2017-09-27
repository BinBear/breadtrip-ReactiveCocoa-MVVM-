//
//  HTSDWebASDKImageContainer.h
//  HeartTrip
//
//  Created by 熊彬 on 2017/9/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface HTSDWebASDKImageContainer : NSObject<ASImageContainerProtocol>

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image;
+ (instancetype)containerForImage:(UIImage *)image;

@end

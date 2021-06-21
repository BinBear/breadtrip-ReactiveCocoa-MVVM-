//
//  HTHUD.h
//  HeartTrip
//
//  Created by vin on 2021/2/22.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTHUD : NSObject

/// 展示在Window上
+ (void)loadingViewInKeyWindow;
/// 移除Window上的HUD
+ (void)dismiss;

/// 展示在相应view上
+ (void)loadingViewInView:(UIView * _Nullable)view;
/// 移除相应view上的HUD
+ (void)dismissWithView:(UIView * _Nullable)view;

@end

NS_ASSUME_NONNULL_END

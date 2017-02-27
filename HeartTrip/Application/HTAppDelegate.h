//
//  HTAppDelegate.h
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RealReachability.h>

@interface HTAppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 *  网络状态
 */
@property (assign , nonatomic , readonly) ReachabilityStatus  NetWorkStatus;

@end

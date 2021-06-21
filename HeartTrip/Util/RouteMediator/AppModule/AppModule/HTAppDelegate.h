//
//  HTAppDelegate.h
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTAppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/// 默认在debug模式下打印所有的模块方法调用和耗时
- (BOOL)shouldModuleMetrics;

@end

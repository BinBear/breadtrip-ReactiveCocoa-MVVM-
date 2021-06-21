//
//  HTViewControllerProtocol.h
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HTViewModelProtocol;
@protocol HTViewControllerProtocol <NSObject>

@optional

/// 路由向下传递的数据
@property (nonatomic,strong,readonly) id parameter;
/// 路由向下传递的viewModel
@property (nonatomic,strong,readonly) id<HTViewModelProtocol> viewModel;

/// 初始化Controller，并赋值viewModel
/// @param viewModelName viewModel名称
/// @param parameter viewModel参数
+ (instancetype)viewControllerWithViewModelName:(NSString * _Nullable)viewModelName
                                      parameter:(id _Nullable)parameter;

/// viewModel正在初始化，子类实现
- (void)bindViewModelWillLoad;
/// viewModel已初始化，子类实现
- (void)bindViewModelDidLoad;

/// 栈底的控制器pop时，需要往栈顶的控制器传数据，实现此方法
/// @param name 栈底pop的控制器
/// @param parameter 传输的数据
- (void)popFromViewController:(NSString * _Nullable)name
                    parameter:(id _Nullable)parameter;

/// 栈顶的控制器dismiss时，需要往栈底的控制器传数据，实现此方法
/// @param name 栈顶dismiss的控制器
/// @param parameter 传输的数据
- (void)dismissFromViewController:(NSString *)name
                        parameter:(NSDictionary *)parameter;

@end

NS_ASSUME_NONNULL_END

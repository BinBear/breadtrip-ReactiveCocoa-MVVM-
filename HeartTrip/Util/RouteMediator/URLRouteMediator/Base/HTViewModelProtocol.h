//
//  HTViewModelProtocol.h
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HTViewControllerProtocol;
@protocol HTViewModelProtocol <NSObject>

@optional

/// 路由向下传递的数据
@property (nonatomic,strong,readonly) id parameter;
/// 当前viewModel所在控制器的导航控制器
@property (nonatomic,weak,  readonly) UINavigationController *viewModelNavigationController;
/// 当前viewModel所在控制器
@property (nonatomic,weak,  readonly) UIViewController<HTViewControllerProtocol> *viewModelController;
/// 根据key配置相应的Command
@property (nonatomic,copy,  readonly) RACCommand *(^requestCommand)(NSString *_Nullable key);
/// 根据key配置相应的刷新Signal
@property (nonatomic,copy,  readonly) RACSubject *(^refreshSignal)(NSString *_Nullable key);

/// 初始化一个viewModel，并且赋值viewModel的相应属性
/// @param parameter viewModel参数
+ (instancetype)viewModelWithParameter:(id _Nullable)parameter;

/// viewModel已初始化，子类实现
- (void)viewModelLoad;

@end

NS_ASSUME_NONNULL_END

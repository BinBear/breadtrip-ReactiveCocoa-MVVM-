//
//  HTViewModel.h
//  HeartTrip
//
//  Created by 熊彬 on 17/2/28.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTViewModelService.h"


typedef NS_ENUM(NSUInteger, HTNavBarStyleType) {
    
    kNavBarStyleNomal   = 0, // 默认
    kNavBarStyleHidden  = 1, // 隐藏
    
};

@interface HTViewModel : NSObject
/**
 *  数据请求
 */
@property (strong, nonatomic, readonly) RACCommand *requestDataCommand;
/**
 *  网络状态
 */
@property (assign, nonatomic) ReachabilityStatus  netWorkStatus;
/**
 *  NavBar类型
 */
@property (assign, nonatomic, readonly) HTNavBarStyleType navBarStyleType;
/**
 *  标题
 */
@property (copy, nonatomic, readonly) NSString *title;
/**
 *  viewModel服务
 */
@property (strong, nonatomic, readonly) id<HTViewModelService> services;

- (instancetype)initWithServices:(id<HTViewModelService>)services params:(NSDictionary *)params;
- (void)initialize;

- (RACSignal *)executeRequestDataSignal:(id)input;

@end

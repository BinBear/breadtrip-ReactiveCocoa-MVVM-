//
//  HTBaseEnum.h
//  HeartTrip
//
//  Created by vin on 2021/5/20.
//  Copyright © 2021 BinBear. All rights reserved.
//

#ifndef HTBaseEnum_h
#define HTBaseEnum_h

/// TableView上下拉刷新类型
typedef NS_ENUM(NSUInteger, HTRefreshActionType) {
    HTRefreshActionType_First = 0,   // 首次加载
    HTRefreshActionType_Refresh,    // 下拉刷新
    HTRefreshActionType_LoadMore,  // 加载更多
};

/// Tableview数据占位图类型
typedef NS_ENUM(NSUInteger, HTEmptyType) {
    HTEmptyType_NoStatus = 1U << 0,         // 无状态，还未请求接口
    HTEmptyType_NoData = 1U << 1,          // 暂无数据
    HTEmptyType_NetworkError = 1U << 2,   // 网络连接异常，请稍后再试
    HTEmptyType_OneAction = 1U << 3,     // 单个按钮
    HTEmptyType_TwoAction  = 1U << 4,   // 两个按钮
    HTEmptyType_Success  = 1U << 5     // 请求成功
};

typedef NS_ENUM(NSUInteger, HCURLRouteActionType) {
    HCURLRouteActionType_Push = 0,        // Push跳转
    HCURLRouteActionType_Present,        // Present跳转
    HCURLRouteActionType_Pop,           // Pop跳转
    HCURLRouteActionType_Dismiss,      // Dismiss跳转
};

#endif /* HTBaseEnum_h */

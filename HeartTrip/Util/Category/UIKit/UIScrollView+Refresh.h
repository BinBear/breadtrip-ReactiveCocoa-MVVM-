//
//  UIScrollView+Refresh.h
//  HeartTrip
//
//  Created by vin on 2020/11/20.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Refresh)

/// 给UIScrollView增加上下拉刷新 (KK)
/// @param headerRefreshBlock 头部进入刷新的时候会调用的方法 如果传空，则头部不添加
/// @param footerRefreshBlock 尾部进入刷新的时候会调用的方法 如果传空，则尾部不添加
- (void)addRefreshWithKaKaHeaderBlock:(void (^)(void))headerRefreshBlock
                  withKaKaFooterBlock:(void (^)(void))footerRefreshBlock;

/// 停止刷新
- (void)endRefresh;
@end

//
//  UIWebView+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/12.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BinWebViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIWebView (BinAdd) <BinWebViewProtocol>
/**
 *  setting UIWebViewDelegate to a class
 *
 */
- (void) setDelegateViews: (id <UIWebViewDelegate>) delegateView;

@end

NS_ASSUME_NONNULL_END
//
//  WKWebView+BinAdd.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/12.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "BinWebViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (BinAdd) <BinWebViewProtocol>

/**
 *  setting WKUIDelegate and WKNavigationDelegate to the same class
 *
 */
- (void) setDelegateViews: (id <WKNavigationDelegate, WKUIDelegate>) delegateView;

@end

NS_ASSUME_NONNULL_END
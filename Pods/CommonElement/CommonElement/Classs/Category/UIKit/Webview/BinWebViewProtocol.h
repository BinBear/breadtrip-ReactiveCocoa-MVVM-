//
//  BinWebViewProtocol.h
//  CommonElement
//
//  Created by 熊彬 on 16/6/12.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BinWebViewProtocol <NSObject>


@property (nonatomic, strong) NSURLRequest *request;

/*
 *  设置webview的代理.
 */
- (void) setDelegateViews: (id) delegateView;

/*
 * Load an NSURLRequest in the active webview.
 */
- (void) loadRequest: (NSURLRequest *) request;

/*
 * Convenience method to load a request from a string.
 */
- (void) loadRequestFromString: (NSString *) urlNameAsString;

- (BOOL) canGoToBack;
- (void) goToBack;

- (BOOL) canGoToForward;
- (void) goToForward;

- (void) evaluateJavaScript: (NSString *) javaScriptString completionHandler: (void (^)(id, NSError *)) completionHandler;

@end

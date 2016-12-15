//
//  UIWebView+BinAdd.m
//  CommonElement
//
//  Created by 熊彬 on 16/6/12.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import "UIWebView+BinAdd.h"

@implementation UIWebView (BinAdd)


- (void) setDelegateViews: (id <UIWebViewDelegate>) delegateView
{
    [self setDelegate: delegateView];
}


- (void) loadRequestFromString: (NSString *) urlNameAsString
{
    [self loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString: urlNameAsString]]];
}


- (void) evaluateJavaScript: (NSString *) javaScriptString completionHandler: (void (^)(id, NSError *)) completionHandler
{
    NSString *string = [self stringByEvaluatingJavaScriptFromString: javaScriptString];
    
    if (completionHandler) {
        completionHandler(string, nil);
    }
}

- (void) setScalesPagesToFit: (BOOL) setPages
{
    self.scalesPageToFit = setPages;
}

- (BOOL)canGoToBack
{
    return [self canGoBack];
}

- (void)goToBack
{
    [self goBack];
}

- (BOOL)canGoToForward
{
    return [self canGoForward];
}
- (void)goToForward
{
    [self goForward];
}
@end

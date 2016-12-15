//
//  WKWebView+BinAdd.m
//  CommonElement
//
//  Created by 熊彬 on 16/6/12.
//  Copyright © 2016年 熊彬. All rights reserved.
//

#import "WKWebView+BinAdd.h"
#import <objc/runtime.h>

@implementation WKWebView (BinAdd)

/*
 *  设置webview的代理.
 */
- (void) setDelegateViews: (id <WKNavigationDelegate, WKUIDelegate>) delegateView
{
    [self setNavigationDelegate: delegateView];
    [self setUIDelegate: delegateView];
}


- (NSURLRequest *) request
{
    return objc_getAssociatedObject(self, @selector(request));
}


- (void) setRequest: (NSURLRequest *) request
{
    objc_setAssociatedObject(self, @selector(request), request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void) altLoadRequest: (NSURLRequest *) request
{
    [self setRequest: request];
    
    // Since we swizzled with loadRequest, this will actually call the original loadRequest.
    [self altLoadRequest: request];
}


- (void) loadRequestFromString: (NSString *) urlNameAsString
{
    [self loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString: urlNameAsString]]];
}


- (void) setScalesPagesToFit: (BOOL) setPages
{
    return; // not supported in WKWebView
}

+ (void) load
{
    static dispatch_once_t onceToken;
    
    // We want to make sure this is only done once!
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // Get the representation of the method names to swizzle.
        SEL originalSelector = @selector(loadRequest:);
        SEL swizzledSelector = @selector(altLoadRequest:);
        
        // Get references to the methods to swizzle.
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // Attempt to add the new method in place of the old method.
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        // If we succeeded, put the old method in place of the new method.
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            // Otherwise, just swap their implementations.
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (BOOL)canGoToBack
{
    return  [self canGoBack];
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

//
//  FTDIntegrationWebView.m
//  FuTongDai
//
//  Created by 熊彬 on 16/8/23.
//  Copyright © 2016年 OFIM. All rights reserved.
//

#import "FTDIntegrationWebView.h"

static void *FTDIntegrationWebBrowserContext = &FTDIntegrationWebBrowserContext;

@interface FTDIntegrationWebView ()<UIAlertViewDelegate>{
    NSString *webTitle;
    struct {
        unsigned int didTitle                :1;
        unsigned int didshouldStartLoad      :1;
        unsigned int didStartLoad            :1;
        unsigned int didFinishLoad           :1;
        unsigned int didFailToLoad           :1;
        
    } _delegateFlags; //将代理对象是否能响应相关协议方法缓存在结构体中
}
@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, assign) BOOL uiWebViewIsLoading;
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;
@property (nonatomic, strong) NSURL *URLToLaunchWithPermission;
@property (nonatomic, strong) UIAlertView *externalAppPermissionAlertView;

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIWebView *uiWebView;

@end

@implementation FTDIntegrationWebView
#pragma mark --Initializers
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if(NSClassFromString(@"WKWebView")) {
            self.wkWebView = [[WKWebView alloc] init];
        } else {
            self.uiWebView = [[UIWebView alloc] init];
        }
        
        self.backgroundColor = [UIColor redColor];
        
        if(self.wkWebView) {
            [self.wkWebView setFrame:frame];
            [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [self.wkWebView setNavigationDelegate:self];
            [self.wkWebView setUIDelegate:self];
            [self.wkWebView setMultipleTouchEnabled:YES];
            [self.wkWebView setAutoresizesSubviews:YES];
            [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
            [self addSubview:self.wkWebView];
            [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:FTDIntegrationWebBrowserContext];
            [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        } else {
            [self.uiWebView setFrame:frame];
            [self.uiWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [self.uiWebView setDelegate:self];
            [self.uiWebView setMultipleTouchEnabled:YES];
            [self.uiWebView setAutoresizesSubviews:YES];
            [self.uiWebView setScalesPageToFit:YES];
            [self.uiWebView.scrollView setAlwaysBounceVertical:YES];
            [self addSubview:self.uiWebView];
        }
        /*
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        [self.progressView setFrame:self.bounds];
        
        //设置进度条颜色
        [self setTintColor:[UIColor orangeColor]];
        [self addSubview:self.progressView];
        */
    }
    return self;
}

#pragma mark - Public Interface
- (BOOL)canGoBack
{
    if(self.wkWebView) {
        return [self.wkWebView canGoBack];
    } else {
        return [self.uiWebView canGoBack];
    }
}
- (BOOL)canGoForward
{
    if(self.wkWebView) {
        return [self.wkWebView canGoForward];
    } else {
        return [self.uiWebView canGoForward];
    }
}
- (void)goBack
{
    if(self.wkWebView) {
        [self.wkWebView goBack];
    } else {
        [self.uiWebView goBack];
    }
}
- (void)goForward
{
    if(self.wkWebView) {
        [self.wkWebView goForward];
    } else {
        [self.uiWebView goForward];
    }
}
- (void)loadRequest:(NSURLRequest *)request {
    if(self.wkWebView) {
        [self.wkWebView loadRequest:request];
    } else {
        [self.uiWebView loadRequest:request];
    }
}

- (void)loadURL:(NSURL *)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    if(self.wkWebView) {
        [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
    } else if(self.uiWebView) {
        [self.uiWebView loadHTMLString:HTMLString baseURL:nil];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.progressView setTintColor:tintColor];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
}
- (void)setDelegate:(id<FTDIntegrationWebViewDelegate>)delegate
{
    _delegate = delegate;
    
    _delegateFlags.didTitle = [delegate respondsToSelector:@selector(FTD_WebView:title:)];
    _delegateFlags.didshouldStartLoad = [delegate respondsToSelector:@selector(FTD_WebView:shouldStartLoadWithURL:)];
    _delegateFlags.didStartLoad = [delegate respondsToSelector:@selector(FTD_WebViewDidStartLoad:)];
    _delegateFlags.didFinishLoad = [delegate respondsToSelector:@selector(FTD_WebView:didFinishLoadingURL:)];
    _delegateFlags.didFailToLoad = [delegate respondsToSelector:@selector(FTD_WebView:didFailToLoadURL:error:)];
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(webView == self.uiWebView) {
        
        if (_delegateFlags.didStartLoad) {
            [self.delegate FTD_WebViewDidStartLoad:self];
        }
    }
}

//监视请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(webView == self.uiWebView) {
        if(![self externalAppRequiredToOpenURL:request.URL]) {
            self.uiWebViewCurrentURL = request.URL;
            self.uiWebViewIsLoading = YES;
            [self fakeProgressViewStartLoading];
            
            //back delegate
            if (_delegateFlags.didshouldStartLoad) {
                [self.delegate FTD_WebView:self shouldStartLoadWithURL:request.URL];
            }
            return YES;
        } else {
            [self launchExternalAppWithURL:request.URL];
            return NO;
        }
    }
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(webView == self.uiWebView) {
        if(!self.uiWebView.isLoading) {
            self.uiWebViewIsLoading = NO;
            [self fakeProgressBarStopLoading];
        }
        //back delegate
        if (_delegateFlags.didFinishLoad) {
            [self.delegate FTD_WebView:self didFinishLoadingURL:self.uiWebView.request.URL];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(webView == self.uiWebView) {
        if(!self.uiWebView.isLoading) {
            self.uiWebViewIsLoading = NO;
            [self fakeProgressBarStopLoading];
        }
        //back delegate
        if (_delegateFlags.didFailToLoad) {
            [self.delegate FTD_WebView:self didFailToLoadURL:self.uiWebView.request.URL error:error];
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
        //back delegate
        if (_delegateFlags.didStartLoad) {
            [self.delegate FTD_WebViewDidStartLoad:self];
        }
        
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
        //back delegate
        if (_delegateFlags.didFinishLoad) {
            [self.delegate FTD_WebView:self didFinishLoadingURL:self.wkWebView.URL];
        }
       
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
        //back delegate
        if (_delegateFlags.didFailToLoad) {
            [self.delegate FTD_WebView:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
        
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    if(webView == self.wkWebView) {
        //back delegate
        if (_delegateFlags.didFailToLoad) {
            
            [self.delegate FTD_WebView:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
        
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(webView == self.wkWebView) {
        NSURL *URL = navigationAction.request.URL;
        if(![self externalAppRequiredToOpenURL:URL]) {
            if(!navigationAction.targetFrame) {
                [self loadURL:URL];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
            [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
        } else if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            [self launchExternalAppWithURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType {
    //back delegate
    if (_delegateFlags.didshouldStartLoad) {
         [self.delegate FTD_WebView:self shouldStartLoadWithURL:request.URL];
    }
    return YES;
}

#pragma mark - WKUIDelegate
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - Estimated Progress KVO (WKWebView)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else if ([keyPath isEqualToString:@"title"]){
        webTitle = self.wkWebView.title;
        if (_delegateFlags.didTitle) {
            [self.delegate FTD_WebView:self title:webTitle];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.uiWebView isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

#pragma mark - External App Support
- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    
    //若需要限制只允许某些前缀的scheme通过请求，则取消下述注释，并在数组内添加自己需要放行的前缀
    //    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https",@"file"]];
    //    return ![validSchemes containsObject:URL.scheme];
    
    return !URL;
}

- (void)launchExternalAppWithURL:(NSURL *)URL {
    self.URLToLaunchWithPermission = URL;
    if (![self.externalAppPermissionAlertView isVisible]) {
        [self.externalAppPermissionAlertView show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView == self.externalAppPermissionAlertView) {
        if(buttonIndex != alertView.cancelButtonIndex) {
            [[UIApplication sharedApplication] openURL:self.URLToLaunchWithPermission];
        }
        self.URLToLaunchWithPermission = nil;
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    [self.uiWebView setDelegate:nil];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}
@end

//
//  HTWebViewController.m
//  HeartTrip
//
//  Created by 熊彬 on 16/12/13.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTWebViewController.h"
#import "FTDIntegrationWebView.h"
#import "HTWebViewModel.h"
#import "UIViewController+HTHideBottomLine.h"

@interface HTWebViewController ()<FTDIntegrationWebViewDelegate>
/**
 *  viewModel
 */
@property (strong, nonatomic, readonly) HTWebViewModel *viewModel;
/**
 *  webview
 */
@property (strong, nonatomic) FTDIntegrationWebView *webView;

@end

@implementation HTWebViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)bindViewModel
{
    [super bindViewModel];
    
    [self.webView loadURLString:self.viewModel.requestURL];
    
    // 开始加载
    @weakify(self);
    [[self
      rac_signalForSelector:@selector(FTD_WebViewDidStartLoad:)
      fromProtocol:@protocol(FTDIntegrationWebViewDelegate)]
    	subscribeNext:^(RACTuple *tuple) {
            @strongify(self)
            if (tuple.first == self.webView){
                
                dispatch_main_async_safe(^{
                    [HTShowMessageView showStatusWithMessage:@"Loading..."];
                });
            }
        }];
    // 加载完成
    [[self
      rac_signalForSelector:@selector(FTD_WebView:didFinishLoadingURL:)
      fromProtocol:@protocol(FTDIntegrationWebViewDelegate)]
    	subscribeNext:^(RACTuple *tuple) {
            @strongify(self)
            if (tuple.first == self.webView){
                
                dispatch_main_async_safe(^{
                    [HTShowMessageView dismissSuccessView:@"Success"];
                    if (self.viewModel.webType == kWebFindDetailType) {
                        
                        NSString *jsMethod = @"document.getElementById(\"download\").remove();document.querySelector(\"header.has-banner\").style.marginTop = 0;";
                        [self.webView FTD_stringByEvaluatingJavaScriptFromString:jsMethod];
                    }
                    
                });
            }
        }];
    // 加载失败
    [[self
      rac_signalForSelector:@selector(FTD_WebView:didFailToLoadURL:error:)
      fromProtocol:@protocol(FTDIntegrationWebViewDelegate)]
    	subscribeNext:^(RACTuple *tuple) {
            @strongify(self)
            if (tuple.first == self.webView){
                
                dispatch_main_async_safe(^{
                    [HTShowMessageView dismissErrorView:@"Error"];
                });
            }
        }];
    
    // 标题
    if ([self.viewModel.title isNotBlank]) {
        RAC(self.navigationItem,title) = RACObserve(self.viewModel, title);
    }else{
        [[self
          rac_signalForSelector:@selector(FTD_WebView:title:)
          fromProtocol:@protocol(FTDIntegrationWebViewDelegate)]
         subscribeNext:^(RACTuple *tuple) {
             @strongify(self)
             
             dispatch_main_async_safe(^{
                 self.navigationItem.title = tuple.second;
             });
             
         }];
    }
    
    self.webView.delegate = self;
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
- (void)updateViewConstraints
{
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if (self.viewModel.navBarStyleType == kNavBarStyleHidden) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(-64);
        }
    }];
    
    [super updateViewConstraints];
}
#pragma mark - getter
- (FTDIntegrationWebView *)webView
{
    return HT_LAZY(_webView, ({
    
        FTDIntegrationWebView *view = [FTDIntegrationWebView new];
        [self.view addSubview:view];
        view;
    }));
}

@end

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
@property (strong, nonatomic) HTWebViewModel *viewModel;
/**
 *  webview
 */
@property (strong, nonatomic) FTDIntegrationWebView *webView;
/**
 *  NavBar
 */
@property (strong, nonatomic) UINavigationBar *navBar;
@end

@implementation HTWebViewController

- (instancetype)initWithViewModel:(HTWebViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self bindViewModel];
    
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.bottom.equalTo(self.view);
    }];
}
- (void)bindViewModel
{
    
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self removeFakeNavBar];
    if (self.viewModel.navBarStyleType == kWebNavBarStyleHidden) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self HT_hideBottomLineInView:self.navigationController.navigationBar];
    
        [self addFakeNavBar];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [self removeFakeNavBar];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeFakeNavBar];
    if (self.viewModel.navBarStyleType == kWebNavBarStyleHidden) {
        [self addFakeNavBar];
        self.navigationController.navigationBar.barStyle = UINavigationBar.appearance.barStyle;
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UINavigationBar.appearance backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self HT_showBottomLineInView:self.navigationController.navigationBar];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self removeFakeNavBar];
}
- (void)addFakeNavBar {

    if (self.viewModel.navBarStyleType == kWebNavBarStyleHidden) {
        [self.navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self HT_hideBottomLineInView:self.navBar];
        
    }else {
        [self.navBar setBackgroundImage:[UINavigationBar.appearance backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self HT_showBottomLineInView:self.navBar];
        
    }
}

- (void)removeFakeNavBar {
    if (self.navBar.superview) {
        [self.navBar removeFromSuperview];
    }
}
- (void)updateViewConstraints
{
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if (self.viewModel.navBarStyleType == kWebNavBarStyleHidden) {
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
- (UINavigationBar *)navBar
{
    return HT_LAZY(_navBar, ({
    
        UINavigationBar *bar = [[UINavigationBar alloc] init];
        bar.barStyle = UINavigationBar.appearance.barStyle;
        bar.translucent = YES;
        [self.view addSubview:bar];
        [bar setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        bar;
    }));
}
@end

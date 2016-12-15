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

@interface HTWebViewController ()<FTDIntegrationWebViewDelegate>
/**
 *  viewModel
 */
@property (strong, nonatomic) HTWebViewModel *viewModel;
/**
 *  webview
 */
@property (strong, nonatomic) FTDIntegrationWebView *webView;
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
                
                dispatch_main_sync_safe(^{
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
                
                dispatch_main_sync_safe(^{
                    [HTShowMessageView dismissSuccessView:@"Success"];
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
                
                dispatch_main_sync_safe(^{
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
             
             dispatch_main_sync_safe(^{
                 self.navigationItem.title = tuple.second;
             });
             
         }];
    }
    
    self.webView.delegate = self;
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

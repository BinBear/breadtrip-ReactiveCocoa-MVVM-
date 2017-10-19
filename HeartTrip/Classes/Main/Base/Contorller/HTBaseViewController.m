//
//  HTBaseViewController.m
//  HeartTrip
//
//  Created by 熊彬 on 17/3/1.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTBaseViewController.h"
#import "UIViewController+HTHideBottomLine.h"
#import "HTViewModel.h"

@interface HTBaseViewController ()
@property (strong, nonatomic, readwrite) HTViewModel *viewModel;
@end

@implementation HTBaseViewController

- (instancetype)initWithViewModel:(HTViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindViewModel];
}
- (void)bindViewModel
{
    @weakify(self);
    [RACObserve(HT_APPDelegate , NetWorkStatus) subscribeNext:^(NSNumber *networkStatus) {
        
        @strongify(self);
        if (networkStatus.integerValue == RealStatusNotReachable || networkStatus.integerValue == RealStatusUnknown) {
            
            [self.viewModel.requestDataCommand execute:@(RealStatusNotReachable)];
        }else{
            
            [self.viewModel.requestDataCommand execute:@1];
        }
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self removeFakeNavBar];
    if (self.viewModel.navBarStyleType == kNavBarStyleHidden) {
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
    if (self.viewModel.navBarStyleType == kNavBarStyleHidden) {
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
    
    if (self.viewModel.navBarStyleType == kNavBarStyleHidden) {
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
+ (void)popCallBack:(NSDictionary *)infoDic{};
@end

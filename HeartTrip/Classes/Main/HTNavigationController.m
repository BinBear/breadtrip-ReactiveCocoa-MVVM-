//
//  HTNavigationController.m
//  HeartTrip
//
//  Created by vin on 2021/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTNavigationController.h"

@interface HTNavigationController ()

@end

@implementation HTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Public Method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self setUpNavigationBarAppearance];
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = true;
    }
    [super pushViewController:viewController animated:true];
}

#pragma mark - 设置全局的导航栏属性
- (void)setUpNavigationBarAppearance {
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    NSDictionary *textAttributes = @{NSFontAttributeName:textFontPingFangRegularFont(18),
                                     NSForegroundColorAttributeName: UIColorWhite};
    
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    navigationBarAppearance.tintColor = UIColorWhite;
    navigationBarAppearance.barTintColor = UIColorMake(80, 189, 203);
    navigationBarAppearance.translucent = true;
}
@end

//
//  HTFoldingTabBarControllerConfig.m
//  HeartTrip
//
//  Created by 熊彬 on 17/2/22.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTFoldingTabBarControllerConfig.h"
#import "HTCityTravelNotesController.h"
#import "HTFindViewController.h"
#import "HTDestinationViewController.h"
#import "HTMeViewController.h"
#import "HTConfigBaseNavigationController.h"
#import "HTViewModelServicesImpl.h"
#import "HTCityTravelViewModel.h"
#import "HTFindViewModel.h"

@interface HTFoldingTabBarControllerConfig ()

@property (nonatomic, readwrite, strong) YALFoldingTabBarController *flodingTabBarController;

/**
 *  数据服务
 */
@property (strong, nonatomic) HTViewModelServicesImpl *viewModelService;
/**
 *  首页viewModel
 */
@property (strong, nonatomic) HTCityTravelViewModel *cityTravelViewModel;
/**
 *  发现viewModel
 */
@property (strong, nonatomic) HTFindViewModel *findViewModel;

@end

@implementation HTFoldingTabBarControllerConfig
- (YALFoldingTabBarController *)flodingTabBarController
{
    return HT_LAZY(_flodingTabBarController, ({
        
        YALFoldingTabBarController *tabBarVC = [[YALFoldingTabBarController alloc] init];
        tabBarVC.viewControllers = [self viewControllersForController];
        [self customFoldingTabBarAppearance:tabBarVC];
        tabBarVC;
        
    }));
}
- (NSArray *)viewControllersForController {
    
    // 数据服务
    self.viewModelService = [[HTViewModelServicesImpl alloc] initModelServiceImpl];
    
    // 首页
    self.cityTravelViewModel = [[HTCityTravelViewModel alloc] initWithServices:self.viewModelService params:nil];
    HTCityTravelNotesController *firstViewController = [[HTCityTravelNotesController alloc] initWithViewModel:self.cityTravelViewModel];
    HTConfigBaseNavigationController *firstNavigationController = [[HTConfigBaseNavigationController alloc]
                                                                   initWithRootViewController:firstViewController];
    
    // 发现
    self.findViewModel = [[HTFindViewModel alloc] initWithServices:self.viewModelService params:nil];
    HTFindViewController *financingViewController = [[HTFindViewController alloc] initWithViewModel:self.findViewModel];
    HTConfigBaseNavigationController *secondNavigationController = [[HTConfigBaseNavigationController alloc]
                                                                    initWithRootViewController:financingViewController];
    
    // 目的地
    HTDestinationViewController *destinationViewController = [[HTDestinationViewController alloc] init];
    HTConfigBaseNavigationController *thirdNavigationController = [[HTConfigBaseNavigationController alloc]
                                                                   initWithRootViewController:destinationViewController];
    
    // 我的
    HTMeViewController *meViewController = [[HTMeViewController alloc] init];
    HTConfigBaseNavigationController *fourNavigationController = [[HTConfigBaseNavigationController alloc]
                                                                  initWithRootViewController:meViewController];
    
    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 fourNavigationController
                                 ];
    return viewControllers;
}
- (void)customFoldingTabBarAppearance:(YALFoldingTabBarController *)tabBarVC
{
    YALTabBarItem *item1 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"nearby_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    
    YALTabBarItem *item2 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"profile_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    tabBarVC.leftBarItems = @[item1, item2];
    
    
    YALTabBarItem *item3 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"chats_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    
    YALTabBarItem *item4 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"settings_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    tabBarVC.rightBarItems = @[item3, item4];
    
    tabBarVC.centerButtonImage = [UIImage imageNamed:@"plus_icon"];
    
    tabBarVC.selectedIndex = 0;
    
    
    tabBarVC.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
    tabBarVC.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
    tabBarVC.tabBarView.tabBarColor = SetColor(80, 189, 203);
    tabBarVC.tabBarViewHeight = YALTabBarViewDefaultHeight;
    tabBarVC.tabBarView.tabBarViewEdgeInsets = UIEdgeInsetsMake(-15.0f, 15.0f, 10.0f, 15.0f);
    tabBarVC.tabBarView.tabBarItemsEdgeInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
}
@end

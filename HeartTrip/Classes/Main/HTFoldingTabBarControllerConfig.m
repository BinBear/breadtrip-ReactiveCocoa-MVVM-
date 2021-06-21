//
//  HTFoldingTabBarControllerConfig.m
//  HeartTrip
//
//  Created by vin on 2021/4/19.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTFoldingTabBarControllerConfig.h"
#import <FoldingTabBar/YALTabBarItem.h>
#import <FoldingTabBar/YALAnimatingTabBarConstants.h>
#import "HTNavigationController.h"

// 游记
#import "HTCityTravelNotesController.h"
#import "HTCityTravelNotesASDKController.h"
#import "HTCityTravelNotesViewModel.h"

// 发现
#import "HTFindViewController.h"
#import "HTFindASDKViewController.h"
#import "HTFindViewModel.h"

@interface HTFoldingTabBarControllerConfig ()

@property (nonatomic, readwrite, strong) YALFoldingTabBarController *flodingTabBarController;

@end

@implementation HTFoldingTabBarControllerConfig

- (YALFoldingTabBarController *)flodingTabBarController {
    return HT_LAZY(_flodingTabBarController, ({
        YALFoldingTabBarController *tabBarVC = [[YALFoldingTabBarController alloc] init];
        tabBarVC.viewControllers = [self viewControllersForController];
        [self customFoldingTabBarAppearance:tabBarVC];
        tabBarVC;
    }));
}


- (NSArray *)viewControllersForController {
    
    // 游记
    HTCityTravelNotesController *cityController = [HTCityTravelNotesController viewControllerWithViewModelName:@"HTCityTravelNotesViewModel" parameter:nil];
    HTNavigationController *firstNav = [[HTNavigationController alloc]
                                        initWithRootViewController:cityController];
    
    // 游记(Texture)
    HTCityTravelNotesASDKController *citASDKController = [HTCityTravelNotesASDKController viewControllerWithViewModelName:@"HTCityTravelNotesViewModel" parameter:nil];
    HTNavigationController *secondNav = [[HTNavigationController alloc]
                                        initWithRootViewController:citASDKController];
    
    // 发现
    HTFindViewController *findController = [HTFindViewController viewControllerWithViewModelName:@"HTFindViewModel" parameter:nil];
    HTNavigationController *thirdNav = [[HTNavigationController alloc]
                                         initWithRootViewController:findController];
    
    // 发现(Texture)
    HTFindASDKViewController *findASDKController = [HTFindASDKViewController viewControllerWithViewModelName:@"HTFindViewModel" parameter:nil];
    HTNavigationController *fourNav = [[HTNavigationController alloc]
                                         initWithRootViewController:findASDKController];
    
    NSArray *viewControllers = @[firstNav,secondNav,thirdNav,fourNav];
    
    return viewControllers;
}

- (void)customFoldingTabBarAppearance:(YALFoldingTabBarController *)tabBarVC {
    YALTabBarItem *item1 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"nearby_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    YALTabBarItem *item2 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"nearby_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];

    tabBarVC.leftBarItems = @[item1,item2];
    
    
    YALTabBarItem *item3 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"chats_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    YALTabBarItem *item4 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"chats_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    tabBarVC.rightBarItems = @[item3,item4];
    
    tabBarVC.centerButtonImage = [UIImage imageNamed:@"plus_icon"];
    
    tabBarVC.selectedIndex = 0;
    
    
    tabBarVC.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
    tabBarVC.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
    tabBarVC.tabBarViewHeight = TabBarHeight;
    tabBarVC.tabBarView.tabBarColor = UIColorMake(80, 189, 203);
    tabBarVC.tabBarView.backgroundColor = UIColorWhite;
    tabBarVC.tabBarView.layer.borderColor = UIColorWhite.CGColor;
    tabBarVC.tabBarView.tabBarViewEdgeInsets = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 40.0f);
    tabBarVC.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;

    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:UIColorWhite];
    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:UIColorWhite]];
}


@end

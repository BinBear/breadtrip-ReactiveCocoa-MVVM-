//
//  HTMediatorAction+HTExploreMoreViewController.m
//  HeartTrip
//
//  Created by 熊彬 on 17/1/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTMediatorAction+HTExploreMoreViewController.h"

@implementation HTMediatorAction (HTExploreMoreViewController)

- (void)pushExploreMoreViewControllerWithViewModel:(HTExploreMoreViewModel *)viewModel
{
    id vc = [@"HTExploreMoreViewController" VKCallClassAllocInitSelectorName:@"initWithViewModel:" error:nil,viewModel];
    UIViewController *currentVC = [self performTarget:nil action:nil];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        [currentVC.navigationController pushViewController:vc animated:YES];
    }
    
}

@end

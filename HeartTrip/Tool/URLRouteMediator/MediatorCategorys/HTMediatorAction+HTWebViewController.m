//
//  HTMediatorAction+HTWebViewController.m
//  HeartTrip
//
//  Created by 熊彬 on 16/12/13.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTMediatorAction+HTWebViewController.h"

@implementation HTMediatorAction (HTWebViewController)

- (void)pushWebViewControllerWithViewModel:(HTWebViewModel *)viewModel
{
    id vc = [@"HTWebViewController" VKCallClassAllocInitSelectorName:@"initWithViewModel:" error:nil,viewModel];
    UIViewController *currentVC = [self performTarget:nil action:nil];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        [currentVC.navigationController pushViewController:vc animated:YES];
    }
    
}

@end

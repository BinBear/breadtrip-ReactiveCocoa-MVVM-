//
//  HTMediatorAction+HTExploreMoreViewController.h
//  HeartTrip
//
//  Created by 熊彬 on 17/1/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTMediatorAction.h"

@class HTExploreMoreViewModel;

@interface HTMediatorAction (HTExploreMoreViewController)

- (void)pushExploreMoreViewControllerWithViewModel:(HTExploreMoreViewModel *)viewModel;

@end

//
//  HTMediatorAction+HTCityTravelDetailController.m
//  HeartTrip
//
//  Created by 熊彬 on 17/3/30.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTMediatorAction+HTCityTravelDetailController.h"

@implementation HTMediatorAction (HTCityTravelDetailController)

- (void)pushCityTravelDetailControllerWithViewModel:(HTCityTravelDetialViewModel *)viewModel
{
    id vc = [@"HTCityTravelDetailController" VKCallClassAllocInitSelectorName:@"initWithViewModel:" error:nil,viewModel];
    UIViewController *currentVC = [self performTarget:nil action:nil];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        [currentVC.navigationController pushViewController:vc animated:YES];
    }
}

- (void)popViewControllerWithInfo:(NSDictionary *)infoDic
{
    UIViewController *currentVC = [self performTarget:nil action:nil];
    [currentVC.navigationController popViewControllerAnimated:YES];
    
    [@"HTCityTravelNotesController" VKCallClassSelectorName:@"popCallBack:" error:nil,infoDic];
}
@end

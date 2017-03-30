//
//  HTCityTravelDetailController.m
//  HeartTrip
//
//  Created by 熊彬 on 17/3/30.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTCityTravelDetailController.h"
#import "HTCityTravelDetialViewModel.h"

@interface HTCityTravelDetailController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) HTCityTravelDetialViewModel *viewModel;
@end

@implementation HTCityTravelDetailController
@dynamic viewModel;
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SetColor(250, 246, 232);
    self.navigationController.navigationBar.barTintColor = SetColor(250, 246, 232);
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = SetColor(80, 189, 203);
}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
}

@end

//
//  HTCityTravelDetailController.m
//  HeartTrip
//
//  Created by vin on 2021/6/21.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTCityTravelDetailController.h"

@interface HTCityTravelDetailController ()

@end

@implementation HTCityTravelDetailController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBase];
}

#pragma mark - Bind
- (void)bindViewModelDidLoad{
    DDLogDebug(@"%@",self.viewModel.listItem);
}

#pragma mark - Config
- (void)configBase{
    
}

#pragma mark - Getter

@end

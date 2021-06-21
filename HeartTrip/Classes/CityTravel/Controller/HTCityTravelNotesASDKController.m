//
//  HTCityTravelNotesASDKController.m
//  HeartTrip
//
//  Created by vin on 2021/5/21.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTCityTravelNotesASDKController.h"

@interface HTCityTravelNotesASDKController ()

@end

@implementation HTCityTravelNotesASDKController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBase];
}

#pragma mark - Bind
- (void)bindViewModelDidLoad{
    
}

#pragma mark - Config
- (void)configBase{
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    logo.image = UIImageMake(@"breadTrip_logo");
    self.navigationItem.titleView = logo;
}

#pragma mark - Getter
@end

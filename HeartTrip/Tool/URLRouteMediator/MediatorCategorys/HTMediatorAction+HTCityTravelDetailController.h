//
//  HTMediatorAction+HTCityTravelDetailController.h
//  HeartTrip
//
//  Created by 熊彬 on 17/3/30.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTMediatorAction.h"

@class HTCityTravelDetialViewModel;

@interface HTMediatorAction (HTCityTravelDetailController)

- (void)pushCityTravelDetailControllerWithViewModel:(HTCityTravelDetialViewModel *)viewModel;

@end

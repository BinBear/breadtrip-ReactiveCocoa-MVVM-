//
//  HTMediatorAction+HTWebViewController.h
//  HeartTrip
//
//  Created by 熊彬 on 16/12/13.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTMediatorAction.h"

@class HTWebViewModel;

@interface HTMediatorAction (HTWebViewController)

- (void)pushWebViewControllerWithViewModel:(HTWebViewModel *)viewModel;

@end

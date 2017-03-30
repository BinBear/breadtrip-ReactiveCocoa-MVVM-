//
//  HTBaseViewController.h
//  HeartTrip
//
//  Created by 熊彬 on 17/3/1.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTViewModel;

@interface HTBaseViewController : UIViewController
/**
 *  viewModel
 */
@property (strong, nonatomic, readonly) HTViewModel *viewModel;
/**
 *  NavBar
 */
@property (strong, nonatomic) UINavigationBar *navBar;

- (instancetype)initWithViewModel:(HTViewModel *)viewModel;
- (void)bindViewModel;

@end

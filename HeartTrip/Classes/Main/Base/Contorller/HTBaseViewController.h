//
//  HTBaseViewController.h
//  HeartTrip
//
//  Created by 熊彬 on 17/3/1.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class HTViewModel;

@interface HTBaseViewController : ASViewController
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
+ (void)popCallBack:(NSDictionary *)infoDic;

@end

//
//  HTCityTravelDetailController.m
//  HeartTrip
//
//  Created by 熊彬 on 17/3/30.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTCityTravelDetailController.h"
#import "HTCityTravelDetialViewModel.h"
#import "HTMediatorAction+HTCityTravelDetailController.h"
#import "HTDetailNavBar.h"

@interface HTCityTravelDetailController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) HTCityTravelDetialViewModel *viewModel;
/**
 *  nav
 */
@property (strong, nonatomic) HTDetailNavBar *navBarView;
@end

@implementation HTCityTravelDetailController
@dynamic viewModel;
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SetColor(250, 246, 232);
    self.fd_prefersNavigationBarHidden = YES;
    
    [self navBarView];
}

#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
}


#pragma mark - getter
- (HTDetailNavBar *)navBarView
{
    return HT_LAZY(_navBarView, ({
        
        CGRect frame;
        if (IS_IPHONEX) {
            frame = CGRectMake(0, 0, SCREEN_WIDTH, 88);
        }else{
            frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        }
        HTDetailNavBar *view = [[HTDetailNavBar alloc] initWithFrame:frame];
        [self.view addSubview:view];
        view;
    }));
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [[HTMediatorAction sharedInstance] popViewControllerWithInfo:@{@"ClassName":@"HTCityTravelNotesController",@"Type":@"CallBack"}];
//}

@end

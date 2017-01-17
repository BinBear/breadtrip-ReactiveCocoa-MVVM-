//
//  HTCityHunterButton.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/19.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTCityHunterButton.h"
#import "HTCustomTabBarController.h"

@interface HTCityHunterButton ()
/**
 *  是否更换背景图片
 */
@property (assign , nonatomic) BOOL  isChangeImage;
@end

@implementation HTCityHunterButton

#pragma mark -
#pragma mark - Life Cycle
+ (void)load {
    [super registerSubclass];
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.adjustsImageWhenHighlighted = NO;
        self.isChangeImage = NO;
    }
    return self;
}

#pragma mark -
#pragma mark - HTCustomTabBarButtonDelegate
+ (id)customButton
{
    
    HTCityHunterButton *hunterButton = ({
        
        HTCityHunterButton *button = [[HTCityHunterButton alloc] init];
        button.frame = CGRectMake(0.0, 0.0, 60, 60);
        [button setBackgroundImage:[UIImage imageNamed:@"root_tab_add_btn"] forState:UIControlStateNormal];
        @weakify(button);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(button);
            [button showCityHunterView];
        }];
        button;
        
    });
    return hunterButton;
}
+ (CGFloat)multiplerInCenterY {
    return  0.3;
}

#pragma mark -
#pragma mark - Privete Method
- (void)showCityHunterView
{
    self.isChangeImage = !self.isChangeImage;
    HTCustomTabBarController *tabBarController = [self HT_tabBarController];
    UIViewController *viewController = tabBarController.selectedViewController;
    if (self.isChangeImage) {
        [self setBackgroundImage:[UIImage imageNamed:@"root_tab_add_btn_select"] forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:[UIImage imageNamed:@"root_tab_add_btn"] forState:UIControlStateNormal];
    }
    
}

@end

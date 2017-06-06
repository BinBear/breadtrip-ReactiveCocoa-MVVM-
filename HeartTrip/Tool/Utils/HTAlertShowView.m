//
//  HTAlertShowView.m
//  HeartTrip
//
//  Created by 熊彬 on 2017/6/5.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTAlertShowView.h"
#import <Lottie/Lottie.h>

static CGFloat Loading_width = 270;
static CGFloat Loading_hight = 170;


@interface HTAlertShowView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) LOTAnimationView *laAnimation;
@end

@implementation HTAlertShowView

+ (instancetype)sharedAlertManager
{
    HTAlertShowView *Manager = [[HTAlertShowView alloc] initWithFrame:MainScreenRect];
    return Manager;
}
- (void)showHTAlertView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    [window addSubview:self.backgroundView];
    [self.laAnimation play];
    
}
-(void)dismissAlertView
{
    [self.laAnimation removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    
    self.laAnimation = nil;
    self.backgroundView = nil;
    
}

#pragma mark - getter(lazy load)
- (UIView *)backgroundView
{
    return HT_LAZY(_backgroundView, ({
    
        UIView *backgroundView = [[UIView alloc] initWithFrame:MainScreenRect];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        backgroundView;
    }));
}
- (LOTAnimationView *)laAnimation
{
    return HT_LAZY(_laAnimation, ({
    
        LOTAnimationView *view = [LOTAnimationView animationNamed:@"heart"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.frame = CGRectMake((SCREEN_WIDTH - Loading_width)/2.0 , (SCREEN_HEIGHT - Loading_hight)/2.0, Loading_width, Loading_hight);
        view.loopAnimation = YES;
        [self.backgroundView addSubview:view];
        view;
    }));
}
@end

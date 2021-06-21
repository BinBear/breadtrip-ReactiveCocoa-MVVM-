//
//  HTHUD.m
//  HeartTrip
//
//  Created by vin on 2021/2/22.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTHUD.h"

@interface HTHUD ()
/// window
@property (strong, nonatomic) UIWindow *window;
@end

static HTHUD *indicator = nil;

@implementation HTHUD
+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indicator = [[HTHUD alloc] init];
    });
    return indicator;
}

- (void)initLOTAnimationView:(UIView * _Nullable)view{
        
    HTLottieView *logoAnimation = [[HTLottieView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    logoAnimation.loopAnimation = true;
    [logoAnimation lottieWithName:@"loadingHUD"];
    [logoAnimation play];

    [HTBaseCenterTipView showTipViewToView:view?:self.window
                                      size:CGSizeMake(200, 150)
                                blackAlpha:0
                               blackAction:NO
                               contentView:logoAnimation
                          automaticDismiss:NO
                            animationStyle:HTBaseTipViewAnimationStyleFade
                     tipViewStatusCallback:nil];
}
+ (void)loadingViewInKeyWindow {
    dispatch_main_async_safe(^{
        [HTHUD.shared  initLOTAnimationView:nil];
    });
}

+ (void)loadingViewInView:(UIView * _Nullable)view{
    
    dispatch_main_async_safe(^{
        [HTHUD.shared initLOTAnimationView:view];
    });
}

+ (void)dismissWithView:(UIView * _Nullable)view{
    dispatch_main_async_safe(^{
        [HTBaseCenterTipView dismissForView:view completion:nil];
    });
}

+ (void)dismiss{
    dispatch_main_async_safe(^{
        [HTBaseCenterTipView dismissForView:HTHUD.shared.window completion:nil];
        HTHUD.shared.window.hidden = true;
        HTHUD.shared.window = nil;
    });
}

#pragma mark - Getter
- (UIWindow *)window {
    return  HT_LAZY(_window, ({
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.windowLevel = UIWindowLevelAlert;
        window.backgroundColor = UIColorClear;
        window.hidden = false;
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes){
                if (windowScene.activationState == UISceneActivationStateForegroundActive){
                    window.windowScene = windowScene;
                    break;
                }
            }
        }
#endif
        window;
    }));
}
@end

//
//  HTBaseCenterTipView.h
//  HeartTrip
//
//  Created by vin on 2021/2/22.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HTBaseTipViewShowStatus) {
    HTBaseTipViewShowStatusWillShow,  // 即将开始动画显示
    HTBaseTiPViewShowStatusDidShow,  // 完成动画显示
    HTBaseTipViewShowStatusWillDismiss,  // 即将动画消失
    HTBaseTipViewShowStatusDidDismiss   // 完成动画消失
};

typedef NS_ENUM(NSUInteger, HTBaseTipViewAnimationStyle) {
    HTBaseTipViewAnimationStyleScale,   // 放大缩小动画
    HTBaseTipViewAnimationStyleFade,   // 渐变动画
    HTBaseTipViewAnimationStyleShake  // 放大抖动动画
};

@interface HTBaseCenterTipView : UIView

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
         contentViewClass:(Class)contentViewClass // Class
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback;

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha //透明度
              blackAction:(BOOL)blackAction  // 是否点击背景消失
         contentViewClass:(Class)contentViewClass // Class
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback;




+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
       contentViewNibName:(NSString *)contentViewNibName // Xib
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback; // Xib

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
       contentViewNibName:(NSString *)contentViewNibName // Xib
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback; // Xib





+ (void)showTipViewToView:(UIView *)view // 传nil 加到KeyWindow
                     size:(CGSize)size
              contentView:(UIView *)contentView // view
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback;

+ (void)showTipViewToView:(UIView *)view // 传nil 加到KeyWindow
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
              contentView:(UIView *)contentView // view
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback;


+ (instancetype)getInstanceWithInView:(UIView *)view;

+ (void)showHUD;
+ (void)dismissHUD;

+ (void)showHudForView:(UIView *)view;
+ (void)dismissHudForView:(UIView *)view;

+ (void)dismissWithCompletion:(void(^)(void))completion;
+ (void)dismissForView:(UIView *)view completion:(void(^)(void))completion;

+ (void)bringSubviewToFrontWithView:(UIView *)view;
@end



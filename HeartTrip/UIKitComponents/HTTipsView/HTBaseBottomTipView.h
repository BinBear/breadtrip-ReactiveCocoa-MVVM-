//
//  HTBaseBottomTipView.h
//  HeartTrip
//
//  Created by vin on 2021/2/22.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTBaseCenterTipView.h"

@interface HTBaseBottomTipView : UIView

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
              contentView:(UIView *)contentView // view
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback;


+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
         contentViewClass:(Class)contentViewClass  // Class
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback;


+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
       contentViewNibName:(NSString *)contentViewNibName // // Xib
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback;

+ (instancetype)getInstanceWithInView:(UIView *)view;

+ (void)showHUD;
+ (void)dismissHUD;

+ (void)showHudForView:(UIView *)view;
+ (void)dismissHudForView:(UIView *)view;

+ (void)dismissWithCompletion:(void(^)(void))completion;
+ (void)dismissForView:(UIView *)view completion:(void(^)(void))completion;

+ (void)resetBlackAlpha:(CGFloat)alpha inView:(UIView *)inView;

@end



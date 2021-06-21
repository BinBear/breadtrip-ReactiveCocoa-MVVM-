//
//  HTBaseBottomTipView.m
//  HeartTrip
//
//  Created by vin on 2021/2/22.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTBaseBottomTipView.h"


@interface HTBaseBottomTipView ()
@property (nonatomic,weak) UIView *inView;
@property (nonatomic,weak) UIView *contentView;
@property (nonatomic,strong) UIButton *blackView;
@property (nonatomic,assign) CGFloat blackAlpha;
@property (nonatomic,strong)  UIActivityIndicatorView *inDicatorView;
@property (nonatomic, copy) void(^tipViewStatusCallback)(HTBaseTipViewShowStatus showStatus);
@property (nonatomic, strong) id KeyboardObserver;
@property (nonatomic, assign, getter=isChangeFrame) BOOL changeFrame;
@property (nonatomic, strong) MASConstraint  *contentConstraint;
@end



@implementation HTBaseBottomTipView
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
         contentViewClass:(Class)contentViewClass
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    [self showTipViewToView:view
                       size:size
                contentView:[[contentViewClass alloc] init]
      tipViewStatusCallback:tipViewStatusCallback];
}


+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
       contentViewNibName:(NSString *)contentViewNibName
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    [self showTipViewToView:view
                       size:size
                contentView:[[[NSBundle mainBundle] loadNibNamed:contentViewNibName
                                                           owner:nil
                                                         options:nil] lastObject]
      tipViewStatusCallback:tipViewStatusCallback];
}

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
              contentView:(UIView *)contentView
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    UIView *inView = view ?: keywindow;
    
    if ([self getInstanceWithInView:inView]) {
        return;
    }

    HTBaseBottomTipView *tipView = [[self alloc] init];
    tipView.backgroundColor = [UIColor clearColor];
    tipView.contentView = contentView;
    tipView.tipViewStatusCallback = [tipViewStatusCallback copy];
    
    tipView.frame = inView.bounds;
    [inView addSubview:tipView];
    [inView bringSubviewToFront:tipView];
    tipView.inView = inView;
    
    [tipView addSubview:tipView.blackView];
    [tipView addSubview:contentView];

    if (CGSizeEqualToSize(CGSizeZero, size)) {
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(tipView);
            tipView.contentConstraint = make.top.mas_equalTo(tipView.mas_bottom);
        }];
    } else {
        contentView.size = size;
        contentView.top = inView.height;
        contentView.centerX = inView.width / 2;
    }
    
    if (inView != keywindow) {
        tipView.blackAlpha = 0.0;
    }else{
        tipView.blackAlpha = 0.5;
    }
    [[RACScheduler mainThreadScheduler] afterDelay:.05 schedule:^{
        [tipView show];
    }];
    [tipView observerKeyboardFrameChange];
}

+ (void)resetBlackAlpha:(CGFloat)alpha inView:(UIView *)inView {
   HTBaseBottomTipView *tipView = [self getInstanceWithInView:inView];
    tipView.blackAlpha = alpha;
}

+ (void)showHUD {
    [[self getInstanceWithInView:keywindow] showActivityIndicator];
}

+ (void)dismissHUD {
    [[self getInstanceWithInView:keywindow] dismissActivityIndicator];
}

+ (void)showHudForView:(UIView *)view {
    [[self getInstanceWithInView:view] showActivityIndicator];
}

+ (void)dismissHudForView:(UIView *)view {
    [[self getInstanceWithInView:view] dismissActivityIndicator];
}

+ (void)dismissWithCompletion:(void(^)(void))completion {
    [self dismissForView:keywindow completion:completion];
}

+ (void)dismissForView:(UIView *)view completion:(void(^)(void))completion {
    [[self getInstanceWithInView:view] dismissCompleteAction:completion];
}

+ (instancetype)getInstanceWithInView:(UIView *)view {
    __block HTBaseBottomTipView *tipView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:self] ||
            [NSStringFromClass([obj class]) isEqualToString:@"HTBaseBottomTipView"]) {
            tipView = (HTBaseBottomTipView *)obj;
            *stop = YES;
        }
    }];
    return tipView;
}

- (void)show {
    self.tipViewStatusCallback ?
    self.tipViewStatusCallback(HTBaseTipViewShowStatusWillShow) : nil;
    @weakify(self);
    if (self.contentConstraint) {
        
        [self layoutIfNeeded];
        [self.contentConstraint deactivate];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.contentConstraint = make.bottom.mas_equalTo(self.mas_bottom);
        }];
        self.contentView.alpha = 0.0;
        [UIView animateWithDuration:.35 animations:^{
            @strongify(self);
            self.blackView.alpha = self.blackAlpha;
            self.contentView.alpha = 1.0;
            [self layoutIfNeeded];
        } completion:nil];
        
    } else {
        
        CGFloat transfromH = self.contentView.height;
        self.contentView.alpha = 0.0;
        [UIView animateWithDuration:.35
                              delay:.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            @strongify(self);
            self.contentView.transform = CGAffineTransformMakeTranslation(0, -transfromH);
            self.blackView.alpha = self.blackAlpha;
            self.contentView.alpha = 1.0;
        } completion:^(BOOL finished) {
            @strongify(self);
            self.tipViewStatusCallback ?
            self.tipViewStatusCallback(HTBaseTiPViewShowStatusDidShow) : nil;
        }];
        
    }
}

- (void)dismissCompleteAction:(void(^)(void))completeAction {
    
    self.tipViewStatusCallback ?
    self.tipViewStatusCallback(HTBaseTipViewShowStatusWillDismiss) : nil;
    @weakify(self);
    if (self.contentConstraint) {
        
        [self.contentConstraint deactivate];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.contentConstraint = make.top.mas_equalTo(self.mas_bottom);
        }];
        [UIView animateWithDuration:.25 animations:^{
            @strongify(self);
            self.blackView.alpha = 0;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            @strongify(self);
            [[NSNotificationCenter defaultCenter] removeObserver:self.KeyboardObserver];
            completeAction ? completeAction() : nil;
            self.tipViewStatusCallback ?
            self.tipViewStatusCallback(HTBaseTipViewShowStatusDidDismiss) : nil;
            [self removeFromSuperview];
        }];
        
    } else {
        
        [UIView animateWithDuration:.25
                         animations:^{
            @strongify(self);
            self.contentView.transform = CGAffineTransformIdentity;
            self.blackView.alpha = 0;
        } completion:^(BOOL finished) {
            @strongify(self);
            [[NSNotificationCenter defaultCenter] removeObserver:self.KeyboardObserver];
            completeAction ? completeAction() : nil;
            self.tipViewStatusCallback ?
            self.tipViewStatusCallback(HTBaseTipViewShowStatusDidDismiss) : nil;
            [self removeFromSuperview];
        }];
    }
}

- (UIButton *)blackView {
    return HT_LAZY(_blackView, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.inView.bounds;
        btn.backgroundColor = [UIColor blackColor];
        btn.alpha = 0.0;
        btn;
    }));
}

- (void)showActivityIndicator {
    UIActivityIndicatorView *inDicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    inDicatorView.color = UIColorMake(46, 64, 107);
    [inDicatorView startAnimating];
    [self.contentView addSubview:inDicatorView];
    
    inDicatorView.centerX = self.contentView.width / 2;
    inDicatorView.centerY = self.contentView.height / 2 - kSafeAreaBottom;
    
    self.inDicatorView = inDicatorView;
}

- (void)dismissActivityIndicator {
    [self.inDicatorView stopAnimating];
    [self.inDicatorView removeFromSuperview];
}
- (void)observerKeyboardFrameChange {
    @weakify(self);
    self.KeyboardObserver =
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue: [NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        CGRect beginKeyboardRect = [[note.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endKeyboardRect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        
        
        if (self.contentConstraint) {
            
            [self layoutIfNeeded];
            [self.contentConstraint deactivate];
            
            if (endKeyboardRect.origin.y < beginKeyboardRect.origin.y) {
                
                [UIView animateWithDuration:duration delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        self.contentConstraint = make.bottom.mas_equalTo(-endKeyboardRect.size.height);
                    }];
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.changeFrame = YES;
                }];
            }
            if (self.isChangeFrame && endKeyboardRect.origin.y >beginKeyboardRect.origin.y) {
                
                [UIView animateWithDuration:duration delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                        self.contentConstraint = make.bottom.mas_equalTo(self.mas_bottom);
                    }];
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.changeFrame = NO;
                }];
            }
            
        } else {
            
            if (endKeyboardRect.origin.y < beginKeyboardRect.origin.y) {
                [UIView animateWithDuration:duration delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                    self.contentView.top = self.height - (self.contentView.height - kSafeAreaBottom) - endKeyboardRect.size.height;
                } completion:^(BOOL finished) {
                    self.changeFrame = YES;
                }];
            }
            if (self.isChangeFrame && endKeyboardRect.origin.y >beginKeyboardRect.origin.y) {
                
                [UIView animateWithDuration:duration delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
                    self.contentView.top = self.height - (self.contentView.height - kSafeAreaBottom);
                } completion:^(BOOL finished) {
                    self.changeFrame = NO;
                }];
            }
            
        }
        
    }];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.KeyboardObserver];
}
@end

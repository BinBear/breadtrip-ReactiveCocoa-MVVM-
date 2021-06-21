//
//  HTBaseCenterTipView.m
//  HeartTrip
//
//  Created by vin on 2021/2/22.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTBaseCenterTipView.h"

@interface HTBaseCenterTipView ()
@property (nonatomic,weak) UIView *inView;
@property (nonatomic,assign) BOOL blackAction;
@property (nonatomic,assign) CGFloat blackAlpha;
@property (nonatomic,strong) UIButton *balckView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) id KeyboardObserver;
@property (nonatomic, assign) BOOL automaticDismiss;
@property (nonatomic,strong)  UIActivityIndicatorView *inDicatorView;
@property (nonatomic, assign, getter=isChangeFrame) BOOL changeFrame;
@property (nonatomic, assign) HTBaseTipViewAnimationStyle animationStyle;
@property (nonatomic, copy) void(^tipViewStatusCallback)(HTBaseTipViewShowStatus showStatus);
@end


@implementation HTBaseCenterTipView

+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
         contentViewClass:(Class)contentViewClass
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                contentView:[[contentViewClass alloc] init]
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
         contentViewClass:(Class)contentViewClass
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                 blackAlpha:blackAlpha
                blackAction:blackAction
                contentView:[[contentViewClass alloc] init]
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}




+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
       contentViewNibName:(NSString *)contentViewNibName
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    [self showTipViewToView:view
                       size:size
                contentView:[[[NSBundle mainBundle] loadNibNamed:contentViewNibName
                                                           owner:nil
                                                         options:nil] lastObject]
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}
+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
       contentViewNibName:(NSString *)contentViewNibName // Xib
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                 blackAlpha:blackAlpha
                blackAction:blackAction
                contentView:[[[NSBundle mainBundle] loadNibNamed:contentViewNibName
                                                           owner:nil
                                                         options:nil] lastObject]
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}



+ (void)showTipViewToView:(UIView *)view
                     size:(CGSize)size
              contentView:(UIView *)contentView
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    [self showTipViewToView:view
                       size:size
                 blackAlpha:((view == keywindow) || view == nil) ? 0.5: 0.0
                blackAction:NO
                contentView:contentView
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}

+ (void)showTipViewToView:(UIView *)view // 传nil 加到KeyWindow
                     size:(CGSize)size
               blackAlpha:(CGFloat)blackAlpha
              blackAction:(BOOL)blackAction
              contentView:(UIView *)contentView // view
         automaticDismiss:(BOOL)automaticDismiss
           animationStyle:(HTBaseTipViewAnimationStyle)animationStyle
    tipViewStatusCallback:(void (^)(HTBaseTipViewShowStatus showStatus))tipViewStatusCallback {
    
    UIView *inView = view ?: keywindow;
    if ([self getInstanceWithInView:inView]) {
        return;
    }
    
    HTBaseCenterTipView *tipView = [[self alloc] init];
    [inView addSubview:tipView];
    tipView.frame = inView.bounds;
    [inView bringSubviewToFront:tipView];
    tipView.inView = inView;
    
    [tipView addSubview:tipView.balckView];
    [tipView addSubview:contentView];
    contentView.size = size;
    contentView.centerX = inView.width / 2;
    contentView.centerY = inView.height / 2;
    tipView.contentView = contentView;
    tipView.automaticDismiss = automaticDismiss;
    tipView.animationStyle = animationStyle;
    tipView.tipViewStatusCallback = [tipViewStatusCallback copy];
    [tipView observerKeyboardFrameChange];
    
    tipView.blackAlpha = blackAlpha;
    tipView.blackAction = blackAction;
    
    [tipView show];
}

- (void)blackViewAction {
    if (self.blackAction) {
        [self dismissWithCompletion:nil];
    }
}

- (void)show {
    if (self.animationStyle == HTBaseTipViewAnimationStyleScale) {
        [self showAnimationSacle];
    }
    if (self.animationStyle == HTBaseTipViewAnimationStyleFade) {
        [self showAnimationFade];
    }
    if (self.animationStyle == HTBaseTipViewAnimationStyleShake) {
        [self showAnimationShake];
    }
    if (self.automaticDismiss) {
        [self dismissWithCompletion:nil];
    }
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
    [[self getInstanceWithInView:view] dismissWithCompletion:completion];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
    [self endEditing:YES];
    if (self.animationStyle == HTBaseTipViewAnimationStyleScale) {
        [self dismissAnimationSacleWithCompletion:completion];
    }
    if (self.animationStyle == HTBaseTipViewAnimationStyleFade) {
        [self dismissAnimationFadeWithCompletion:completion];
    }
    if (self.animationStyle == HTBaseTipViewAnimationStyleShake) {
        [self dismissAnimationShakeWithCompletion:completion];
    }
}
+ (void)bringSubviewToFrontWithView:(UIView *)view{
    
    UIView *inputView = [self getInstanceWithInView:view];
    [inputView.superview bringSubviewToFront:inputView];
}
+ (instancetype)getInstanceWithInView:(UIView *)view {
    
    view = view ?: keywindow;
    __block HTBaseCenterTipView *tipView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:self] ||
            [NSStringFromClass([obj class]) isEqualToString:@"HTBaseCenterTipView"]) {
            tipView = (HTBaseCenterTipView *)obj;
            *stop = YES;
        }
    }];
    return tipView;
}

- (void)showAnimationSacle {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTipViewShowStatusWillShow) : nil;
    self.contentView.alpha = 0.0;
    [self.contentView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    @weakify(self);
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.75
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        @strongify(self);
        [self.contentView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
        self.contentView.alpha = 1.0;
        self.balckView.alpha = self.blackAlpha;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTiPViewShowStatusDidShow) : nil;
    }];
}

- (void)showAnimationFade {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTipViewShowStatusWillShow) : nil;
    self.contentView.alpha = 0.0;
    @weakify(self);
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        @strongify(self);
        self.contentView.alpha = 1.0;
        self.balckView.alpha = self.blackAlpha;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTiPViewShowStatusDidShow) : nil;
    }];
}

- (void)showAnimationShake{
    self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTipViewShowStatusWillShow) : nil;
    self.contentView.alpha = 0.0;
    [self.contentView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    @weakify(self);
    [UIView animateWithDuration:0.85
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        @strongify(self);
        [self.contentView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
        self.contentView.alpha = 1.0;
        self.balckView.alpha = self.blackAlpha;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTiPViewShowStatusDidShow) : nil;
    }];
}

- (void)dismissAnimationSacleWithCompletion:(void(^)(void))completion {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTipViewShowStatusWillDismiss) : nil;
    @weakify(self);
    [UIView animateWithDuration:0.25
                          delay:self.automaticDismiss ? 2.5 : 0
         usingSpringWithDamping:0.8
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        @strongify(self);
        self.contentView.alpha = 0;
        self.balckView.alpha = 0;
    } completion:^(BOOL finished) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] removeObserver:self.KeyboardObserver];
        self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTipViewShowStatusDidDismiss) : nil;
        [self removeFromSuperview];
        completion ? completion() : nil;
    }];
}

- (void)dismissAnimationFadeWithCompletion:(void(^)(void))completion {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTipViewShowStatusWillDismiss) : nil;
    @weakify(self);
    [UIView animateWithDuration:0.25
                          delay:self.automaticDismiss ? 2.5 : 0
         usingSpringWithDamping:0.8
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        @strongify(self);
        self.contentView.alpha = 0;
        self.balckView.alpha = 0;
    } completion:^(BOOL finished) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] removeObserver:self.KeyboardObserver];
        self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTipViewShowStatusDidDismiss) : nil;
        [self removeFromSuperview];
        completion ? completion() : nil;
    }];
}

- (void)dismissAnimationShakeWithCompletion:(void(^)(void))completion {
    self.tipViewStatusCallback ? self.tipViewStatusCallback(HTBaseTipViewShowStatusWillDismiss) : nil;
    @weakify(self);
    [UIView animateWithDuration:0.25
                          delay:self.automaticDismiss ? 2.5 : 0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        @strongify(self);
        self.contentView.alpha = 0;
        self.balckView.alpha = 0;
    } completion:^(BOOL finished) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] removeObserver:self.KeyboardObserver];
        self.tipViewStatusCallback ?self.tipViewStatusCallback(HTBaseTipViewShowStatusDidDismiss) : nil;
        [self removeFromSuperview];
        completion ? completion() : nil;
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
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
        
        CGFloat offset = self.contentView.bottom  - endKeyboardRect.origin.y;
        if (offset > 0 && endKeyboardRect.origin.y < beginKeyboardRect.origin.y) {
            [UIView animateWithDuration:duration animations:^{
                self.contentView.transform = CGAffineTransformMakeTranslation(0, -offset);
            } completion:^(BOOL finished) {
                self.changeFrame = YES;
            }];
        }
        if (self.isChangeFrame && endKeyboardRect.origin.y >beginKeyboardRect.origin.y) {
            [UIView animateWithDuration:duration animations:^{
                self.contentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.changeFrame = NO;
            }];
        }
    }];
}

- (UIButton *)balckView {
    return HT_LAZY(_balckView, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.inView.bounds;
        btn.backgroundColor = UIColorMake(5, 18, 35);
        [btn addTarget:self action:@selector(blackViewAction) forControlEvents:UIControlEventTouchUpInside];
        btn.alpha = 0.0;
        btn;
    }));
}

- (void)showActivityIndicator {
    UIActivityIndicatorView *inDicatorView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    inDicatorView.color = UIColorMake(5, 18, 35);
    [inDicatorView startAnimating];
    [self.contentView addSubview:inDicatorView];
    
    inDicatorView.centerX = self.contentView.width / 2;
    inDicatorView.centerY = self.contentView.height / 2;
    
    self.inDicatorView = inDicatorView;
}

- (void)dismissActivityIndicator {
    [self.inDicatorView stopAnimating];
    [self.inDicatorView removeFromSuperview];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.KeyboardObserver];
}
@end

//
//  HTShowTipsView.m
//  HeartTrip
//
//  Created by vin on 2020/11/19.
//  Copyright © 2020 BinBear. All rights reserved.
//

#import "HTShowTipsView.h"

@implementation HTShowTipsView

+ (void)showTips:(NSString *)message{
    [HTShowTipsView showTips:message withPosition:QMUIToastViewPositionCenter withOffset:CGPointMake(0, 0)];
}
+ (RACSignal *(^)(NSString *message))signal {
    @weakify(self);
    return ^RACSignal *(NSString *message){
        return ht_signalWithAction(^{
            @strongify(self);
            [self showTips:message];
        });
    };
}
+ (RACCommand *(^)(NSString *message))command {
    @weakify(self);
    return ^RACCommand *(NSString *message){
        return ht_commandWithAction(^(id  _Nonnull input) {
            @strongify(self);
            [self showTips:message];
        });
    };
}


+ (void)showTips:(NSString *)message withPosition:(QMUIToastViewPosition)position withOffset:(CGPoint)point{
    if (![message isKindOfClass:NSString.class] || ![message isNotBlank]) { return; }
    QMUITips *tips = [QMUITips showWithText:message inView:DefaultTipsParentView hideAfterDelay:1.5];
    tips.userInteractionEnabled = NO;
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.textLabelAttributes = @{NSFontAttributeName: textFontPingFangRegularFont(12),NSForegroundColorAttributeName: UIColorWhite};
    contentView.insets = UIEdgeInsetsMake(8, 16, 8, 16);
    QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
    backgroundView.cornerRadius =  3;
    backgroundView.styleColor = UIColorMakeWithRGBA(3, 14, 29, 0.9);
    tips.marginInsets = UIEdgeInsetsMake(30, 30, 30, 30);
    tips.toastPosition = position;
    tips.offset = point;
}
+ (RACSignal *(^)(NSString *message,QMUIToastViewPosition,CGPoint))signalPosition {
    @weakify(self);
    return ^RACSignal *(NSString *message,QMUIToastViewPosition position, CGPoint point){
        return ht_signalWithAction(^{
            @strongify(self);
            [self showTips:message withPosition:position withOffset:point];
        });
    };
}
+ (RACCommand *(^)(NSString *message,QMUIToastViewPosition,CGPoint))commandPosition {
    @weakify(self);
    return ^RACCommand *(NSString *message,QMUIToastViewPosition position, CGPoint point){
        return ht_commandWithAction(^(id  _Nonnull input) {
            @strongify(self);
            [self showTips:message withPosition:position withOffset:point];
        });
    };
}
@end

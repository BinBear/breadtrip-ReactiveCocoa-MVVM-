//
//  HTActionTipsView.m
//  HeartTrip
//
//  Created by vin on 2021/2/22.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTActionTipsView.h"

@interface HTActionTipViewBtnConfigure ()
@property (nonatomic,strong) id centerTipView_btnTitle;
@property (nonatomic,copy) actionBtnAction centerTipView_btnCallback;
@end
@implementation HTActionTipViewBtnConfigure
+ (instancetype)btnConfigure {
    return [[self alloc] init];
}
- (id)getBtnTitle {
    return self.centerTipView_btnTitle;
}

- (actionBtnAction)getBtnCallback {
    return self.centerTipView_btnCallback;
}
- (actionBtnConfigBlock)btnTitle {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            self.centerTipView_btnTitle = value;
        } else {
            DDLogDebug(@"赋值btnTitle的类型不正确");
        }
        return self;
    };
}
- (actionBtnCallbackConfigBlock)btnCallback {
    @weakify(self);
    return ^(actionBtnAction action){
        @strongify(self);
        self.centerTipView_btnCallback = [action copy];
        return self;
    };
}
@end


@interface HTActionTipViewConfigure ()
@property (nonatomic,strong) id centerTipView_title;
@property (nonatomic,strong) id centerTipView_subTitle;
@property (nonatomic,strong) id<RACSubscriber> subscriber;
@property (nonatomic,copy) actionTapAction action;
@property (nonatomic,strong) NSMutableArray<HTActionTipViewBtnConfigure *> *centerTipView_btnsConfig;
+ (instancetype)defaultConfigure; // 初始化默认配置
@end
@implementation HTActionTipViewConfigure
+ (instancetype)defaultConfigure {
    HTActionTipViewConfigure *configure = [[self alloc] init];
    configure.centerTipView_title = nil;
    configure.centerTipView_subTitle = nil;
    HTActionTipViewBtnConfigure *btnConfigLeft = [[HTActionTipViewBtnConfigure alloc] init];
    btnConfigLeft.btnTitle(@"取消");
    
    HTActionTipViewBtnConfigure *btnConfigRight = [[HTActionTipViewBtnConfigure alloc] init];
    btnConfigRight.btnTitle(@"确定");
    
    configure.centerTipView_btnsConfig = @[btnConfigLeft , btnConfigRight].mutableCopy;
    return configure;
}
- (id)getTitle {
    return self.centerTipView_title;
}
- (id)getSubTitle {
    return self.centerTipView_subTitle;
}
- (NSMutableArray *)getBtnsConfig {
    return self.centerTipView_btnsConfig;
}
- (configTapActionBlock)tapCallback{
    @weakify(self);
    return ^HTActionTipViewConfigure *(actionTapAction action) {
        @strongify(self);
        self.action = [action copy];
        return self;
    };
}
- (actionConfigBlock)title {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            self.centerTipView_title = value;
        } else {
            DDLogDebug(@"赋值title的类型不正确");
        }
        return self;
    };
}
- (actionConfigBlock)subTitle {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            self.centerTipView_subTitle = value;
        } else {
            DDLogDebug(@"赋值subTitle的类型不正确");
        }
        return self;
    };
}
- (actionConfigBlock)btnsConfig {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (!value ||
            [self checkArray:value allClass:[HTActionTipViewBtnConfigure class]]) {
            self.centerTipView_btnsConfig = value;
        } else {
            DDLogDebug(@"赋值btnsConfig的类型不正确");
        }
        return self;
    };
}

- (BOOL)checkArray:(NSArray *)array allClass:(Class)class {
    if (![array isKindOfClass:[NSArray class]] &&
        ![array isKindOfClass:[NSMutableArray class]]) {
        return NO;
    }
    __block BOOL isAllClass = YES;
    [array enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:class]) {
            isAllClass = NO;
            *stop = YES;
        }
    }];
    return isAllClass;
}
@end


@interface HTActionTipsView ()
@property (nonatomic,strong) HTActionTipViewConfigure *viewConfigure;
@property (nonatomic,copy)   actionTipViewConfigBlock tipBlock;
@end

@implementation HTActionTipsView

+ (void)showWithConfigure:(actionTipViewConfigBlock)configure {
    
    HTActionTipsView *tipView = [[self alloc] init];
    HTActionTipViewConfigure *config = [HTActionTipViewConfigure defaultConfigure];
    tipView.tipBlock = configure;
    if (configure) { configure(config);}
    tipView.viewConfigure = config;
    [tipView configUI];
}

+ (RACSignal *)signalWithConfigure:(actionTipViewConfigBlock)configure {
    @weakify(self);
    return ht_createSignal(^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        HTActionTipsView *tipView = [[self alloc] init];
        HTActionTipViewConfigure *config = [HTActionTipViewConfigure defaultConfigure];
        tipView.tipBlock = configure;
        !configure ? : configure(config);
        tipView.viewConfigure = config;
        [tipView configUI];
        return nil;
    });
}

+ (RACCommand *)commandWithConfigure:(actionTipViewConfigBlock)configure{
    @weakify(self);
    return ht_commandWithSignal(^RACSignal * _Nonnull(id  _Nonnull input) {
        @strongify(self);
        return [self signalWithConfigure:configure];
    });
}


#pragma mark - configUI
- (void)configUI{
    NSString *title = @"";
    NSString *message = @"";
    NSString *cancelTitle = @"";
    NSString *confirmTitle = @"";
    if ([self.viewConfigure.centerTipView_title isKindOfClass:[NSString class]] && [self.viewConfigure.centerTipView_title isNotBlank]) {
        title = self.viewConfigure.centerTipView_title;
    }
    if ([self.viewConfigure.centerTipView_subTitle isKindOfClass:[NSString class]] && [self.viewConfigure.centerTipView_subTitle isNotBlank]) {
        message = self.viewConfigure.centerTipView_subTitle;
    }
    
    if (self.viewConfigure.centerTipView_btnsConfig.count > 1) {
        HTActionTipViewBtnConfigure *cancelbtnConfig = self.viewConfigure.centerTipView_btnsConfig[0];
        cancelTitle = cancelbtnConfig.centerTipView_btnTitle;
        HTActionTipViewBtnConfigure *confirmbtnConfig = self.viewConfigure.centerTipView_btnsConfig[1];
        confirmTitle = confirmbtnConfig.centerTipView_btnTitle;
    }else{
        HTActionTipViewBtnConfigure *confirmbtnConfig = self.viewConfigure.centerTipView_btnsConfig[0];
        confirmTitle = confirmbtnConfig.centerTipView_btnTitle;
    }
    // 取消按钮
    QMUIAlertAction *cancelButton = [QMUIAlertAction actionWithTitle:cancelTitle style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        if (_viewConfigure.centerTipView_btnsConfig.firstObject.centerTipView_btnCallback) {
            _viewConfigure.centerTipView_btnsConfig.firstObject.centerTipView_btnCallback();
        };
        _tipBlock = nil;
        _viewConfigure = nil;
    }];
    cancelButton.buttonAttributes = @{NSForegroundColorAttributeName:UIColorMakeWithHex(@"#666666"),NSFontAttributeName:textFontPingFangRegularFont(16)};
    
    // 确定按钮
    QMUIAlertAction *confirmButton = [QMUIAlertAction actionWithTitle:confirmTitle style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        if (_viewConfigure.centerTipView_btnsConfig.lastObject.centerTipView_btnCallback) {
            _viewConfigure.centerTipView_btnsConfig.lastObject.centerTipView_btnCallback();
        };
        _tipBlock = nil;
        _viewConfigure = nil;
    }];
    confirmButton.buttonAttributes = @{NSForegroundColorAttributeName:UIColorMakeWithHex(@"#62BCCC"),NSFontAttributeName:textFontPingFangRegularFont(16)};

    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:title message:message preferredStyle:QMUIAlertControllerStyleAlert];
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    alertController.alertTitleAttributes = @{NSForegroundColorAttributeName:UIColorMakeWithHex(@"#333333"),NSFontAttributeName:textFontPingFangRegularFont(16), NSParagraphStyleAttributeName:textStyle};
    alertController.alertMessageAttributes = @{NSForegroundColorAttributeName:UIColorMakeWithHex(@"#666666"),NSFontAttributeName:textFontPingFangRegularFont(13), NSParagraphStyleAttributeName:textStyle};
    alertController.alertTitleMessageSpacing = 15;
    alertController.alertSeparatorColor = UIColorMakeWithHex(@"#62BCCC");
    alertController.alertButtonHighlightBackgroundColor = UIColorMakeWithHex(@"#62BCCC");
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    alertController.mainVisualEffectView = visualEffectView;
    alertController.alertHeaderBackgroundColor = nil;
    alertController.alertButtonBackgroundColor = nil;
    
    if ([cancelTitle isNotBlank] && [confirmTitle isNotBlank]) {
        // 两个按钮都有
        [alertController addAction:cancelButton];
        [alertController addAction:confirmButton];
    }else{
        [alertController addAction:confirmButton];
    }
    
    [alertController showWithAnimated:true];
}

@end

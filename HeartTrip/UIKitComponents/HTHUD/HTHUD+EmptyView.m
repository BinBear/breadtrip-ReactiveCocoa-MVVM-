//
//  HTHUD+EmptyView.m
//  HotCoin
//
//  Created by vin on 2020/11/9.
//  Copyright © 2020 com.hotcoin.www. All rights reserved.
//

#import "HTHUD+EmptyView.h"
#import "HTBaseEnum.h"

/*********  配置选项内容  ***********/
@implementation HTHUDConfigureItem

@end

/*********  配置类  ***********/
@interface HTHUDConfigure ()

// 外部自定义的View
@property (nonatomic,strong) UIView *HT_contenView;

// 背景图片 可以是 UIImage| NSString 当设置为nil 则为隐藏
@property (nonatomic,strong) id HT_backgroundImage;

// 上面的logo 可以是 UIImage| NSString 当设置为nil 则为隐藏
@property (nonatomic,strong) id HT_image;
@property (nonatomic,  copy) NSString *HT_imageJsonName;

// logo下面的标题 可以是 NSString| NSAttributedString | NSAttributedString 当设置为nil 则为隐藏
// 如果要改变字体大小 颜色等其他属性 可以用富文本 不提直接的属性
@property (nonatomic,strong) id HT_title;

// title下面的复标题 可以是 NSString| NSAttributedString | NSAttributedString 当设置为nil 则为隐藏
// 如果要改变字体大小 颜色等其他属性 可以用富文本 不提供直接的属性
@property (nonatomic,strong) id HT_subTitle;

// 空视图类型
@property (nonatomic,assign) HTEmptyType HT_emptyType;

// 布局类型
@property (nonatomic,assign) HTHUDPosition HT_position;

@property (nonatomic,strong) HTHUDConfigureItem *HT_oneItem;
@property (nonatomic,strong) HTHUDConfigureItem *HT_twoItem;

@property (nonatomic,assign) CGRect HT_contentFrame;
@property (nonatomic,assign) CGFloat HT_contentOffset;

+ (instancetype)defaultConfigure; // 初始化默认配置
@end


@implementation HTHUDConfigure
+ (instancetype)defaultConfigure {
    HTHUDConfigure *configure = [[self alloc] init];
    configure.HT_backgroundImage = nil;
    configure.HT_title = nil;
    configure.HT_subTitle = nil;
    return configure;
}
- (instancetypeBlock)contentView {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value && [value isKindOfClass:[UIView class]]) {
            self.HT_contenView = value;
        } else {
            DDLogDebug(@"赋值contentView的类型不正确");
        }
        return self;
    };
}
- (instancetypeBlock)backgroundImage {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value && [value isKindOfClass:[UIImage class]]) {
            self.HT_backgroundImage = value;
        } else {
            DDLogDebug(@"赋值backgroundImage的类型不正确");
        }
        return self;
    };
}
- (instancetypeBlock)image {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value && [value isKindOfClass:[UIImage class]]) {
            self.HT_image = value;
        } else {
            DDLogDebug(@"赋值image的类型不正确");
        }
        return self;
    };
}
- (instancetypeBlock)imageJsonName {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value && [value isKindOfClass:[NSString class]]) {
            self.HT_imageJsonName = value;
        } else {
            DDLogDebug(@"赋值imageJsonName的类型不正确");
        }
        return self;
    };
}
- (instancetypeBlock)title {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value &&
            ([value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]])) {
            self.HT_title = value;
        } else {
            DDLogDebug(@"赋值title的类型不正确");
        }
        return self;
    };
}
- (instancetypeBlock)subTitle {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value &&
            ([value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]])) {
            self.HT_subTitle = value;
        } else {
            DDLogDebug(@"赋值subTitle的类型不正确");
        }
        return self;
    };
}
- (instancetypeBlock)emptyType{
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value) {
            self.HT_emptyType = [value integerValue];
        } else {
            DDLogDebug(@"赋值emptyType的类型不正确");
        }
        return self;
    };
}
- (instancetypeBlock)position{
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value) {
            self.HT_position = [value integerValue];
        } else {
            DDLogDebug(@"赋值position的类型不正确");
        }
        return self;
    };
}
- (instancetypeBlock)contentOffset{
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value) {
            self.HT_contentOffset = [value floatValue];
        } else {
            DDLogDebug(@"赋值contentOffset的类型不正确");
        }
        return self;
    };
}
- (instancetypeBlock)contentFrame {
    @weakify(self);
    return ^(id value){
        @strongify(self);
        if (value) {
            self.HT_contentFrame = [value CGRectValue];
        } else {
            DDLogDebug(@"赋值contentFrame的类型不正确");
        }
        return self;
    };
}
- (instancetypeContentBlock)oneItem {
    @weakify(self);
    return ^(HTHUDConfigureItem *value){
        @strongify(self);
        if (value) {
            self.HT_oneItem = value;
        } else {
            DDLogDebug(@"赋值oneItem的类型不正确");
        }
        return self;
    };
}
- (instancetypeContentBlock)twoItem {
    @weakify(self);
    return ^(HTHUDConfigureItem *value){
        @strongify(self);
        if (value) {
            self.HT_twoItem = value;
        } else {
            DDLogDebug(@"赋值twoItem的类型不正确");
        }
        return self;
    };
}

@end



@interface HTHUDContentView : UIView
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) QMUIButton *oneButton;
@property (nonatomic,strong) QMUIButton *twoButton;
@property (nonatomic,strong) HTLottieView *lottieAnimation;
@property (nonatomic,strong) HTHUDConfigure *configure;
@property (nonatomic,copy) configureBlock configureBlock;
@end

@implementation HTHUDContentView

+ (instancetype)contentViewWithConfigure:(HTHUDConfigure *)configure {
    
    HTHUDContentView *contentView = [[HTHUDContentView alloc] init];
    contentView.backgroundColor = UIColorWhite;
    contentView.configure = configure;
    [contentView configUI];
    [contentView configSignal];
    return contentView;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self observeFrame];
}

- (void)observeFrame {
    @weakify(self);
        [[[RACObserve(self.superview, frame) takeUntil:self.rac_willDeallocSignal]
          deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (self.configure.HT_contentFrame.size.width) {
                self.frame = self.configure.HT_contentFrame;
            } else {
                CGRect rect = [x CGRectValue];
                self.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            }
        }];
}

- (void)configUI {
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.lottieAnimation];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.oneButton];
    [self addSubview:self.twoButton];
    if (self.configure.HT_contenView) {
        [self addSubview:self.configure.HT_contenView];
    }
    if (self.configure.HT_emptyType == HTEmptyType_NoStatus) { return; }
    
    self.oneButton.hidden = (self.configure.HT_emptyType != HTEmptyType_OneAction) & (self.configure.HT_emptyType != HTEmptyType_TwoAction);
    self.twoButton.hidden = self.configure.HT_emptyType != HTEmptyType_TwoAction;
    
    // 背景图片
    if ([self.configure.HT_backgroundImage isKindOfClass:[NSString class]]) {
        self.backgroundImageView.image = UIImageMake(self.configure.HT_backgroundImage);
    }
    if ([self.configure.HT_backgroundImage isKindOfClass:[UIImage class]]) {
        self.backgroundImageView.image = self.configure.HT_backgroundImage;
    }
    
    // 图片
    if ([self.configure.HT_image isKindOfClass:[NSString class]] && self.configure.HT_emptyType) {
        self.backgroundImageView.image = UIImageMake(self.configure.HT_image);
    }
    if ([self.configure.HT_image isKindOfClass:[UIImage class]]) {
        self.imageView.image = self.configure.HT_image;
    }
    if ([self.configure.HT_imageJsonName isNotBlank]) {
        [self.lottieAnimation lottieWithName:self.configure.HT_imageJsonName];
        [self.lottieAnimation play];
    }
    
    // 标题
    if ([self.configure.HT_title isKindOfClass:[NSString class]]) {
        self.titleLabel.text = self.configure.HT_title;
    }else{
        switch (self.configure.HT_emptyType) {
            case HTEmptyType_NoData: {
                self.titleLabel.text = @"暂无数据";
            }break;
            case HTEmptyType_NetworkError: {
                self.titleLabel.text = @"网络连接异常，请稍后再试";
            }break;
            default:
                break;
        }
    }
    if ([self.configure.HT_title isKindOfClass:[NSAttributedString class]] ||
        [self.configure.HT_title isKindOfClass:[NSAttributedString class]]) {
        self.titleLabel.attributedText = self.configure.HT_title;
    }
    
    // 副标题
    if ([self.configure.HT_subTitle isKindOfClass:[NSString class]]) {
        self.subTitleLabel.text = self.configure.HT_subTitle;
    }
    if ([self.configure.HT_subTitle isKindOfClass:[NSMutableAttributedString class]] ||
        [self.configure.HT_subTitle isKindOfClass:[NSAttributedString class]]) {
        self.subTitleLabel.attributedText = self.configure.HT_subTitle;
    }
    
    // 第一个按钮
    if ([self.configure.HT_oneItem.title isNotBlank]) {
        [self.oneButton setTitle:self.configure.HT_oneItem.title forState:UIControlStateNormal];
    }
    if (self.configure.HT_oneItem.btnImg) {
        [self.oneButton setImage:self.configure.HT_oneItem.btnImg forState:UIControlStateNormal];
    }
    if (self.configure.HT_oneItem.btnBgImg) {
        [self.oneButton setBackgroundImage:self.configure.HT_oneItem.btnBgImg forState:UIControlStateNormal];
    }
    
    // 第二个按钮
    if ([self.configure.HT_twoItem.title isNotBlank]) {
        [self.twoButton setTitle:self.configure.HT_twoItem.title forState:UIControlStateNormal];
    }
    if (self.configure.HT_twoItem.btnImg) {
        [self.twoButton setImage:self.configure.HT_twoItem.btnImg forState:UIControlStateNormal];
    }
    if (self.configure.HT_twoItem.btnBgImg) {
        [self.twoButton setBackgroundImage:self.configure.HT_twoItem.btnBgImg forState:UIControlStateNormal];
    }
}

- (void)configSignal{
    @weakify(self);
    if (self.configure.HT_emptyType == HTEmptyType_OneAction || self.configure.HT_emptyType == HTEmptyType_TwoAction) {
        self.oneButton.rac_command = ht_commandWithAction(^(id  _Nonnull input) {
            @strongify(self);
            !self.configure.HT_oneItem.confirmSignal?:self.configure.HT_oneItem.confirmSignal();
        });
        self.twoButton.rac_command = ht_commandWithAction(^(id  _Nonnull input) {
            @strongify(self);
            !self.configure.HT_twoItem.confirmSignal?:self.configure.HT_twoItem.confirmSignal();
        });
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];

    if (self.configure.HT_contenView) {
        [self.configure.HT_contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        if (self.configure.HT_position == HTHUDPosition_Top) {
            make.top.equalTo(self.mas_top).offset(self.configure.HT_contentOffset);
        }else{
            make.centerY.equalTo(self.mas_centerY).offset(-30);
        }
    }];
    [self.lottieAnimation mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        if (self.configure.HT_position == HTHUDPosition_Top) {
            make.top.equalTo(self.mas_top).offset(self.configure.HT_contentOffset);
        }else{
            make.centerY.equalTo(self.mas_centerY).offset(-30);
        }
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        if ([self.configure.HT_imageJsonName isNotBlank]) {
            make.top.equalTo(self.lottieAnimation.mas_bottom).offset(10);
        }else{
            make.top.equalTo(self.imageView.mas_bottom).offset(10);
        }
    }];
    
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    if (self.configure.HT_emptyType == HTEmptyType_OneAction) {
        [self.oneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(95, 40));
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
        }];
    }else if(self.configure.HT_emptyType == HTEmptyType_TwoAction){
        
        [self.oneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(70);
            make.height.mas_equalTo(40);
            make.width.equalTo(self.twoButton.mas_width);
            make.right.equalTo(self.twoButton.mas_left).offset(16);
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
        }];

        [self.twoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(70);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(20);
        }];
    }
}


- (UIImageView *)backgroundImageView {
    return HT_LAZY(_backgroundImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.clipsToBounds = YES;
        imageView;
    }));
}
- (UIImageView *)imageView {
    return HT_LAZY(_imageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.clipsToBounds = YES;
        imageView;
    }));
}
- (UILabel *)titleLabel {
    return HT_LAZY(_titleLabel, ({
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = UIColorMakeWithHex(@"#666666");
        lable.font = textFontPingFangMediumFont(14);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.numberOfLines = 0;
        lable;
    }));
}
- (UILabel *)subTitleLabel {
    return HT_LAZY(_subTitleLabel, ({
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = UIColorMakeWithHex(@"#999999");
        lable.font = textFontPingFangMediumFont(12);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.numberOfLines = 0;
        lable;
    }));
}
- (QMUIButton *)oneButton{
    return HT_LAZY(_oneButton, ({
        QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        button.titleLabel.font = textFontPingFangMediumFont(14);
        [button sizeToFit];
        button.titleLabel.adjustsFontSizeToFitWidth = true;
        button;
    }));
}
- (QMUIButton *)twoButton{
    return HT_LAZY(_twoButton, ({
        QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColorWhite forState:UIControlStateNormal];
        button.titleLabel.font = textFontPingFangMediumFont(14);
        [button sizeToFit];
        button.titleLabel.adjustsFontSizeToFitWidth = true;
        button;
    }));
}
- (HTLottieView *)lottieAnimation {
    return HT_LAZY(_lottieAnimation, ({
        HTLottieView *lottieAnimation = [[HTLottieView alloc] initWithFrame:CGRectZero];
        lottieAnimation.loopAnimation = true;
        lottieAnimation;
    }));
}
@end


@implementation HTHUD (EmptyView)

+ (void)showEmptyViewToView:(UIView *)view
                  configure:(configureBlock)configure {
    
    HTHUDContentView *orginContentView = [self getHasShowContentViewForView:view];
    if (orginContentView) {
        [orginContentView removeFromSuperview];
    }
    
    HTHUDConfigure *config = [HTHUDConfigure defaultConfigure];
    if (configure) {configure(config);}
    
    HTHUDContentView *contentView =
    [HTHUDContentView contentViewWithConfigure:config];
    [view insertSubview:contentView atIndex:0];
    [view bringSubviewToFront:contentView];
}

+ (void)dismissEmptyViewForView:(UIView *)view {
    HTHUDContentView *contentView = [self getHasShowContentViewForView:view];
    if (contentView) {
        contentView.configure = nil;
        [contentView removeFromSuperview];
    }
}

+ (HTHUDContentView *)getHasShowContentViewForView:(UIView *)view {
    __block HTHUDContentView *contentView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[HTHUDContentView class]]) {
            contentView = (HTHUDContentView *)obj;
            *stop = YES;
        }
    }];
    return contentView;
}

@end

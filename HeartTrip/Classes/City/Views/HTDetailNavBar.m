//
//  HTDetailNavBar.m
//  HeartTrip
//
//  Created by 熊彬 on 2017/11/8.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTDetailNavBar.h"
#import "UIView+UIViewController.h"

@interface HTDetailNavBar ()

/**
 *  返回按钮
 */
@property (strong, nonatomic) UIButton *backButton;
/**
 *  分享按钮
 */
@property (strong, nonatomic) UIButton *shareButton;
/**
 *  评论按钮
 */
@property (strong, nonatomic) UIButton *commentButton;
/**
 *  底线
 */
@property (strong, nonatomic) UIView *lineView;
@end

@implementation HTDetailNavBar
#pragma mark - initview
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = SetColor(250, 246, 232);
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.height.equalTo(@35);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.height.equalTo(@35);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.commentButton.mas_left).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.height.equalTo(@35);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@1);
    }];
}
#pragma mark - getter
- (UIButton *)backButton
{
    return HT_LAZY(_backButton,({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"trip_new_btn_back_18x18_"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"trip_new_btn_back_hl_18x18_"] forState:UIControlStateHighlighted];
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [self addSubview:button];
        button;
    }));
}
- (UIButton *)shareButton
{
    return HT_LAZY(_shareButton,({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"trip_new_share_18x18_"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"trip_new_share_hl_18x18_"] forState:UIControlStateHighlighted];
        [self addSubview:button];
        button;
    }));
}
- (UIButton *)commentButton
{
    return HT_LAZY(_commentButton,({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"trip_new_comment_20x19_"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"trip_new_comment_hl_20x19_"] forState:UIControlStateHighlighted];
        [self addSubview:button];
        button;
    }));
}
- (UIView *)lineView
{
    return HT_LAZY(_lineView, ({
        
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(201, 184, 151);
        [self addSubview:view];
        view;
    }));
}
@end

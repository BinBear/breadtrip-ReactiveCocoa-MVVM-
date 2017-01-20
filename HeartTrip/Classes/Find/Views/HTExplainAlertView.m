//
//  HTExplainAlertView.m
//  HeartTrip
//
//  Created by 熊彬 on 17/1/19.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTExplainAlertView.h"

@interface HTExplainAlertView ()
/**
 *  背景图
 */
@property (strong, nonatomic) UIImageView *closeImage;
/**
 *  提示信息
 */
@property (strong, nonatomic) UILabel *messageLabel;
/**
 *  window
 */
@property (strong, nonatomic) UIWindow *alertWindow;
@end

@implementation HTExplainAlertView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.frame = MainScreenRect;
        self.backgroundColor = [UIColor colorWithWhite:.3 alpha:.7];
        
        _alertWindow = ({
        
            UIWindow *window = [[UIWindow alloc] initWithFrame:MainScreenRect];
            window.windowLevel=UIWindowLevelAlert;
            [window becomeKeyWindow];
            [window makeKeyAndVisible];
            [window addSubview:self];
            window;
        });
        
        _closeImage = ({
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled=YES;
            imageView.image = [UIImage imageNamed:@"closeImage"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:imageView];
            imageView;
        });
        _messageLabel = ({
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor whiteColor];
            label.text = @"活动现场是面包猎人推出的全新模块，我们将以视频的形式展现出更丰富多彩的活动内容，让猎人活动更加鲜活地呈现在你面前。\n同时，我们也会不定期地指派优秀的活动体验师前往体验你的活动，直播或拍摄视频，并在app内展示你的活动现场视频，让你的活动人气爆棚。";
            label.textColor = [UIColor lightGrayColor];
            label.font = HTSetFont(@"Damascus", 14);
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentLeft;
            label.lineBreakMode=NSLineBreakByTruncatingTail;
            label.characterSpace = 1.5f;
            label.lineSpace = 3.5f;
            label;
        });
        CGSize labSize = [_messageLabel getLableRectWithMaxWidth:260];
        NSLog(@"%@",NSStringFromCGSize(labSize));
        [_closeImage addSubview:_messageLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            [self dismissAlertView];
        }];
        [self addGestureRecognizer:tap];
        
        [[[[NSNotificationCenter defaultCenter]
           rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil]
          takeUntil:self.rac_willDeallocSignal]
         subscribeNext:^(id x) {
             
            [self dismissAlertView];
         }];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.width.equalTo(@270);
        make.height.equalTo(@380);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.closeImage).insets(UIEdgeInsetsMake(180, 5, 10, 5));
    }];
}
+ (instancetype)sharedAlertManager
{
    return [[HTExplainAlertView alloc] init];
}
- (void)showExplainAlertView
{
    [self setShowAnimation];
}
- (void)dismissAlertView
{
    [self removeFromSuperview];
    [_alertWindow resignKeyWindow];
    _alertWindow = nil;
}
-(void)setShowAnimation
{
    CGPoint startPoint = CGPointMake(self.center.x, - _closeImage.frame.size.height);
    _closeImage.layer.position=startPoint;
    
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _closeImage.layer.position=CGPointMake(self.center.x, self.center.y);
        
    } completion:^(BOOL finished) {
        
    }];
}
@end

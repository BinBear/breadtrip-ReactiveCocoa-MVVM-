//
//  HTBannerItemView.m
//  HeartTrip
//
//  Created by vin on 2021/5/21.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTBannerItemView.h"

@interface HTBannerItemView ()
/// icon
@property (strong, nonatomic) SDAnimatedImageView *iconImage;
@end

@implementation HTBannerItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorClear;
        [self addSubview:self.iconImage];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}

- (void)cycleViewReloadDataAtIndex:(NSInteger)index parameter:(id)parameter {
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:parameter] placeholderImage:UIImageMake(@"tripdisplay_photocell_placeholder")];
}
#pragma mark - Getter
- (SDAnimatedImageView *)iconImage{
    return HT_LAZY(_iconImage, ({
        SDAnimatedImageView *view = [SDAnimatedImageView new];
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = true;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    }));
}

@end

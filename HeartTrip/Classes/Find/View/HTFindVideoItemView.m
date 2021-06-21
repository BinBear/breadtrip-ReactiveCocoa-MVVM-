//
//  HTFindVideoItemView.m
//  HeartTrip
//
//  Created by vin on 2021/5/24.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTFindVideoItemView.h"
#import "HTFindVideosModel.h"

@interface HTFindVideoItemView ()
/// icon
@property (strong, nonatomic) SDAnimatedImageView *iconImage;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 看过人数
@property (strong, nonatomic) UILabel *likeLabel;
@end

@implementation HTFindVideoItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorClear;
        [self addSubview:self.iconImage];
        [self.iconImage addSubview:self.titleLabel];
        [self.iconImage addSubview:self.likeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.inset(8);
    }];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.left.right.inset(8);
    }];
}

- (void)cycleViewReloadDataAtIndex:(NSInteger)index parameter:(id)parameter {
    
    HTFindVideosModel *model = parameter;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:UIImageMake(@"VideoPlaceholder")];
    self.titleLabel.text = model.product_title;
    self.likeLabel.text = [NSString vv_stringWithFormat:@"%@个面粉看过",model.views];
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
- (UILabel *)titleLabel{
    return HT_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangMediumFont(15);
        label.textColor = UIColorWhite;
        label.numberOfLines = 0;
        label;
    }));
}
- (UILabel *)likeLabel{
    return HT_LAZY(_likeLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textColor = UIColorWhite;
        label.numberOfLines = 0;
        label;
    }));
}
@end

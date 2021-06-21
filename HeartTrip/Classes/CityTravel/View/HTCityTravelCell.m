//
//  HTCityTravelCell.m
//  HeartTrip
//
//  Created by vin on 2021/5/20.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTCityTravelCell.h"
#import "HTCityTravelNotesViewModel.h"


@interface HTCityTravelCell ()
/// 背景图
@property (strong, nonatomic) SDAnimatedImageView *backgroundImageView;
/// 游记标题
@property (strong, nonatomic) UILabel *titleLabel;
/// line
@property (strong, nonatomic) UIView *blueLine;
/// 时间
@property (strong, nonatomic) UILabel *timeLabel;
/// 游记地点
@property (strong, nonatomic) UILabel  *placeLabel;
/// 用户头像
@property (strong, nonatomic) SDAnimatedImageView *avatarView;
/// 用户名
@property (strong, nonatomic) UILabel *avatarLabel;
@end

@implementation HTCityTravelCell

- (void)ht_cellLoad {
    
    [self.contentView addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.titleLabel];
    [self.backgroundImageView addSubview:self.blueLine];
    [self.backgroundImageView addSubview:self.timeLabel];
    [self.backgroundImageView addSubview:self.placeLabel];
    [self.backgroundImageView addSubview:self.avatarView];
    [self.backgroundImageView addSubview:self.avatarLabel];
    
    [self layoutItemSubviews];
}

- (void)ht_reloadCellData {
    
    HTCityTravelNotesViewModel *viewModel = self.ht_cellData;
    HTCityTravelItemModel *model = viewModel.listData[self.ht_indexPath.row];
    // 背景
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_image] placeholderImage:UIImageMake(@"tripdisplay_photocell_placeholder")];
    // 游记标题
    self.titleLabel.text = model.name;
    // 游记信息
    self.timeLabel.text = [self subTimeStringWithViewModel:model];
    // 游记地点
    self.placeLabel.text = model.popular_place_str;
    // 用户名
    self.avatarLabel.text = [NSString vv_stringWithFormat:@"by %@",model.user.name];
    // 用户头像
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.user.avatar_m] placeholderImage:UIImageMake(@"avatar_placeholder")];
}

- (NSString *)subTimeStringWithViewModel:(HTCityTravelItemModel *)model {
    NSString *time = [model.first_day stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString *dayCount = [NSString vv_stringWithFormat:@"%@%@",model.type == 4 ? model.day_count : model.spot_count,model.type == 4 ? @"天" : @"故事"];
    NSString *viewCount = [NSString vv_stringWithFormat:@"%@浏览",countTextCharsForNumber(model.view_count,1)];
    NSString *timeStr = [NSString vv_stringWithFormat:@"%@   %@   %@",time,dayCount,viewCount];
    return timeStr;
}
#pragma mark - Layout
- (void)layoutItemSubviews {
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 15, 0, 15));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.right.inset(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.blueLine.mas_right).offset(4);
    }];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.left.equalTo(self.blueLine.mas_right).offset(4);
    }];
    [self.blueLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_top);
        make.bottom.equalTo(self.placeLabel.mas_bottom);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(3);
    }];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.height.equalTo(@30);
    }];
    [self.avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).offset(5);
        make.centerY.equalTo(self.avatarView.mas_centerY);
    }];
}

#pragma mark - Getter
- (SDAnimatedImageView *)backgroundImageView {
    return HT_LAZY(_backgroundImageView, ({
        SDAnimatedImageView *view = [SDAnimatedImageView new];
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = true;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    }));
}
- (UILabel *)titleLabel {
    return HT_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangMediumFont(17);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label;
    }));
}
- (UIView *)blueLine{
    return HT_LAZY(_blueLine, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorMake(80, 189, 203);
        view.layer.cornerRadius = 2;
        view;
    }));
}
- (UILabel *)timeLabel{
    return HT_LAZY(_timeLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(10);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label;
    }));
}
- (UILabel *)placeLabel{
    return HT_LAZY(_placeLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(8);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label;
    }));
}
- (SDAnimatedImageView *)avatarView{
    return HT_LAZY(_avatarView, ({
        SDAnimatedImageView *view = [SDAnimatedImageView new];
        view.layer.cornerRadius = 15;
        view.layer.masksToBounds = true;
        view;
    }));
}
- (UILabel *)avatarLabel{
    return HT_LAZY(_avatarLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(10);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label;
    }));
}@end

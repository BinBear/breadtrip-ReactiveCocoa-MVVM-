//
//  HTFindFeedCell.m
//  HeartTrip
//
//  Created by vin on 2021/5/24.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTFindFeedCell.h"
#import "HTFindViewModel.h"

@interface HTFindFeedCell ()
/// 用户头像
@property (strong, nonatomic) SDAnimatedImageView *avatarView;
/// 用户名
@property (strong, nonatomic) UILabel *avatarLabel;
/// 创建时间
@property (strong, nonatomic) UILabel *timeLabel;
/// 活动背景图
@property (strong, nonatomic) SDAnimatedImageView *backgroundImageView;
/// 活动标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 活动地点
@property (strong, nonatomic) UILabel *addressLabel;
/// 活动价格
@property (strong, nonatomic) UILabel *priceLabel;
/// 横线
@property (strong, nonatomic) UIView *transverseLineView;
/// 活动描述
@property (strong, nonatomic) UILabel *describeLabel;
/// 喜欢人数
@property (strong, nonatomic) UILabel *likerNumLabel;
/// 评论图标
@property (strong, nonatomic) UIView *commentLogoView;
/// 竖线
@property (strong, nonatomic) UIView *verticalLineView;
/// 灰色view
@property (strong, nonatomic) UIView *grayView;
/// 评论
@property (strong, nonatomic) QMUIButton *commentLink;
/// 头像数组
@property (strong, nonatomic) NSMutableArray *photoArr;
@end

@implementation HTFindFeedCell

- (void)ht_cellLoad {
    
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.avatarLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.backgroundImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.transverseLineView];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.likerNumLabel];
    [self.contentView addSubview:self.commentLogoView];
    [self.contentView addSubview:self.verticalLineView];
    [self.contentView addSubview:self.grayView];
    [self.contentView addSubview:self.commentLink];
    
    [self layoutItemSubviews];
}

- (void)ht_reloadCellData {
    
    HTFindViewModel *viewModel = self.ht_cellData;
    HTFindFeedModel *model = viewModel.feedData[self.ht_indexPath.row];
    
    // 头像
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.user.avatar_s] placeholderImage:UIImageMake(@"tripdisplay_photocell_placeholder")];
    // 用户名
    self.avatarLabel.text = model.user.username;
    // 创建时间
    self.timeLabel.text = model.date_added;
    // 活动图
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.product.cover] placeholderImage:UIImageMake(@"FindFeedPlaceholder")];
    // 活动名
    self.titleLabel.text = model.product_title;
    // 活动地址
    self.addressLabel.text = model.product.address;
    // 价格
    self.priceLabel.text = [NSString vv_stringWithFormat:@"￥%@",model.product.price];
    // 活动描述
    self.describeLabel.text = model.product.text;
    // 评论数
    [self.commentLink setTitle:model.comment_count forState:UIControlStateNormal];
    // 喜欢人数
    self.likerNumLabel.text = [NSString vv_stringWithFormat:@"%@个人喜欢",model.liked_count];
    [self.photoArr removeAllObjects];
    [self.commentLogoView qmui_removeAllSubviews];
    for (HTFindUserModel *user in model.liked_users) {
        SDAnimatedImageView *view = [SDAnimatedImageView new];
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = true;
        [view sd_setImageWithURL:[NSURL URLWithString:user.avatar_s] placeholderImage:UIImageMake(@"avatar_placeholder_26_26x26_")];
        [self.photoArr addObject:view];
        [self.commentLogoView addSubview:view];
    }
    [self.photoArr mas_distributeSudokuViewsWithFixedItemWidth:20
                                               fixedItemHeight:20
                                              fixedLineSpacing:0
                                         fixedInteritemSpacing:-5
                                                     warpCount:self.photoArr.count
                                                    topSpacing:5
                                                 bottomSpacing:5
                                                   leadSpacing:0
                                                   tailSpacing:0];
}


#pragma mark - Layout
- (void)layoutItemSubviews {
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(15);
        make.width.height.equalTo(@40);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.avatarView.mas_centerY);
    }];
    [self.avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.centerY.equalTo(self.avatarView.mas_centerY);
    }];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@180);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-25);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.mas_centerY);
        make.left.right.inset(10);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(-15);
    }];
    [self.transverseLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        make.left.right.inset(10);
        make.height.equalTo(@1);
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transverseLineView.mas_bottom).offset(10);
        make.left.right.inset(10);
    }];
    [self.commentLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    [self.likerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentLogoView.mas_right).offset(10);
        make.centerY.equalTo(self.commentLogoView.mas_centerY);
    }];
    [self.commentLink mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentLogoView.mas_centerY);
        make.right.mas_equalTo(-15);
    }];
    [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentLogoView.mas_centerY);
        make.right.equalTo(self.commentLink.mas_left).offset(-15);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
    }];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentLogoView.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@10);
    }];
    
}

#pragma mark - Getter
- (SDAnimatedImageView *)backgroundImageView{
    return HT_LAZY(_backgroundImageView, ({
        SDAnimatedImageView *view = [SDAnimatedImageView new];
//        view.contentMode = UIViewContentModeScaleAspectFill;
        view;
    }));
}
- (UILabel *)titleLabel{
    return HT_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangMediumFont(15);
        label.numberOfLines = 0;
        label.textColor = UIColorBlack;
        label;
    }));
}
- (UILabel *)timeLabel{
    return HT_LAZY(_timeLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textColor = UIColorMake(153, 153, 153);
        label.textAlignment = NSTextAlignmentRight;
        label;
    }));
}
- (UILabel *)addressLabel{
    return HT_LAZY(_addressLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textColor = UIColorMake(153, 153, 153);
        label;
    }));
}
- (SDAnimatedImageView *)avatarView{
    return HT_LAZY(_avatarView, ({
        SDAnimatedImageView *view = [SDAnimatedImageView new];
        view.layer.cornerRadius = 20;
        view.layer.masksToBounds = true;
        view;
    }));
}
- (UILabel *)avatarLabel{
    return HT_LAZY(_avatarLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontHelveticaMediumFont(14);
        label.textColor = UIColorBlack;
        label;
    }));
}
- (UILabel *)priceLabel{
    return HT_LAZY(_priceLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontHelveticaMediumFont(14);
        label.textColor = UIColorRed;
        label.textAlignment = NSTextAlignmentRight;
        label;
    }));
}
- (UIView *)transverseLineView{
    return HT_LAZY(_transverseLineView, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorMake(240, 240, 240);
        view;
    }));
}
- (UILabel *)describeLabel{
    return HT_LAZY(_describeLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textColor = UIColorMake(102, 102, 102);
        label;
    }));
}

- (UILabel *)likerNumLabel{
    return HT_LAZY(_likerNumLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(12);
        label.textColor = UIColorMake(153, 153, 153);
        label;
    }));
}
- (UIView *)commentLogoView{
    return HT_LAZY(_commentLogoView, ({
        UIView *view = [UIView new];
        view;
    }));
}
- (UIView *)verticalLineView{
    return HT_LAZY(_verticalLineView, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorMake(240, 240, 240);
        view;
    }));
}
- (UIView *)grayView{
    return HT_LAZY(_grayView, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorMake(250, 250, 250);
        view;
    }));
}
- (QMUIButton *)commentLink{
    return HT_LAZY(_commentLink, ({
        QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:UIColorMake(153, 153, 153) forState:UIControlStateNormal];
        button.titleLabel.font = textFontPingFangRegularFont(12);
        button.imagePosition = QMUIButtonImagePositionLeft;
        button.spacingBetweenImageAndTitle = 5;
        [button setImage:UIImageMake(@"discovery_comment_23x22_") forState:UIControlStateNormal];
        button;
    }));
}
- (NSMutableArray *)photoArr{
    return HT_LAZY(_photoArr, @[].mutableCopy);
}
@end

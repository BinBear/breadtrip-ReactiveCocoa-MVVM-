//
//  HTFindFeedCell.m
//  HeartTrip
//
//  Created by 熊彬 on 16/12/2.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTFindFeedCell.h"
#import "HTFindFeedModel.h"
#import "HTFindUserModel.h"
#import "HTFindProductModel.h"
#import "UIImageView+HTRoundImage.h"

@interface HTFindFeedCell ()
/**
 *  用户头像
 */
@property (strong, nonatomic) UIImageView *avatarView;
/**
 *  用户名
 */
@property (strong, nonatomic) UILabel *avatarLabel;
/**
 *  创建时间
 */
@property (strong, nonatomic) UILabel *timeLabel;
/**
 *  活动背景图
 */
@property (strong, nonatomic) UIImageView *backgroundImageView;
/**
 *  活动标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  活动地点
 */
@property (strong, nonatomic) UILabel *addressLabel;
/**
 *  活动价格
 */
@property (strong, nonatomic) UILabel *priceLabel;
/**
 *  横线
 */
@property (strong, nonatomic) UIView *transverseLineView;
/**
 *  活动描述
 */
@property (strong, nonatomic) UILabel *describeLabel;
/**
 *  喜欢的用户1
 */
@property (strong, nonatomic) UIImageView *likerOne;
/**
 *  喜欢的用户2
 */
@property (strong, nonatomic) UIImageView *likerTwo;
/**
 *  喜欢的用户3
 */
@property (strong, nonatomic) UIImageView *likerThree;
/**
 *  喜欢的用户4
 */
@property (strong, nonatomic) UIImageView *likerFour;
/**
 *  喜欢的用户5
 */
@property (strong, nonatomic) UIImageView *likerFive;
/**
 *  喜欢人数
 */
@property (strong, nonatomic) UILabel *likerNumLabel;
/**
 *  评论人数
 */
@property (strong, nonatomic) UILabel *commentNumLabel;
/**
 *  评论图标
 */
@property (strong, nonatomic) UIImageView *commentLogo;
/**
 *  竖线
 */
@property (strong, nonatomic) UIView *verticalLineView;
/**
 *  灰色view
 */
@property (strong, nonatomic) UIView *grayView;
@end

@implementation HTFindFeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.height.equalTo(@40);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.avatarView.mas_centerY);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];

    [self.avatarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.avatarView.mas_right).offset(10);
        make.centerY.equalTo(self.avatarView.mas_centerY);
        make.height.equalTo(@20);
        make.width.equalTo(@140);
    }];

    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.avatarView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.equalTo(@180);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backgroundImageView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.height.equalTo(@25);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@15);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@20);
    }];
    
    [self.transverseLineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@1);
    }];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.transverseLineView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.height.equalTo(@20);
    }];
    
    [self.likerOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.width.equalTo(@22);
    }];
    [self.likerTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.likerOne.mas_right).offset(-5);
        make.height.width.equalTo(@22);
    }];
    [self.likerThree mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.likerTwo.mas_right).offset(-5);
        make.height.width.equalTo(@22);
    }];
    [self.likerFour mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.likerThree.mas_right).offset(-5);
        make.height.width.equalTo(@22);
    }];
    [self.likerFive mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.likerFour.mas_right).offset(-5);
        make.height.width.equalTo(@24);
    }];
    [self.likerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.describeLabel.mas_bottom).offset(15);
        make.left.equalTo(self.likerFive.mas_right).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@120);
    }];
    
    [self.commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.describeLabel.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.equalTo(@20);
        make.width.equalTo(@45);
    }];
    [self.commentLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.right.equalTo(self.commentNumLabel.mas_left).offset(-3);
        make.height.width.equalTo(@24);
    }];
    [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.describeLabel.mas_bottom).offset(10);
        make.right.equalTo(self.commentLogo.mas_left).offset(-25);
        make.width.equalTo(@1);
        make.height.equalTo(@30);
    }];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.height.equalTo(@10);
    }];
}
- (void)bindViewModel:(id)viewModel
{
    HTFindFeedModel *model = viewModel;
    
    [self.avatarView HT_setImageWithCornerRadius:20 imageURL:[NSURL URLWithString:model.user.avatar_s] placeholder:@"im_avatar_placeholder_46x46_" size:CGSizeMake(40,40)];
    self.avatarLabel.text = model.user.username;
    self.timeLabel.text = model.date_added;
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.product.cover] placeholderImage:[UIImage imageNamed:@"FindFeedPlaceholder"]];
    self.titleLabel.text = model.product_title;
    self.addressLabel.text = model.product.address;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.product.price];
    self.describeLabel.text = model.product.text;
    self.commentNumLabel.text = [NSString stringWithFormat:@"%@",model.comment_count];
    self.likerNumLabel.text = [NSString stringWithFormat:@"%@个人喜欢",model.liked_count];
    [model.liked_users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HTFindUserModel *model = obj;
        switch (idx) {
            case 0:
            {
                [self.likerOne HT_setImageWithCornerRadius:10 imageURL:[NSURL URLWithString:model.avatar_s] placeholder:@"avatar_placeholder_26_26x26_" size:CGSizeMake(20,20)];
            }
                break;
            case 1:
            {
                [self.likerTwo HT_setImageWithCornerRadius:10 imageURL:[NSURL URLWithString:model.avatar_s] placeholder:@"avatar_placeholder_26_26x26_" size:CGSizeMake(20,20)];
            }
                break;
            case 2:
            {
                [self.likerThree HT_setImageWithCornerRadius:10 imageURL:[NSURL URLWithString:model.avatar_s] placeholder:@"avatar_placeholder_26_26x26_" size:CGSizeMake(20,20)];
            }
                break;
            case 3:
            {
                [self.likerFour HT_setImageWithCornerRadius:10 imageURL:[NSURL URLWithString:model.avatar_s] placeholder:@"avatar_placeholder_26_26x26_" size:CGSizeMake(20,20)];
            }
                break;
            default:
                break;
        }
    }];
    
}
#pragma mark - getter
- (UIImageView *)backgroundImageView
{
    return HT_LAZY(_backgroundImageView, ({
        
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        view;
    }));
}
- (UILabel *)titleLabel
{
    return HT_LAZY(_titleLabel, ({
        
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusBold", 15);
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UILabel *)timeLabel
{
    return HT_LAZY(_timeLabel, ({
        
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusLight", 12);
        label.textColor = SetColor(153, 153, 153);
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UILabel *)addressLabel
{
    return HT_LAZY(_addressLabel, ({
        
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusLight", 12);
        label.textColor = SetColor(153, 153, 153);
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UIImageView *)avatarView
{
    return HT_LAZY(_avatarView, ({
        
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        view;
    }));
}
- (UILabel *)avatarLabel
{
    return HT_LAZY(_avatarLabel, ({
        
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusBold", 14);
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UILabel *)priceLabel
{
    return HT_LAZY(_priceLabel, ({
        
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusBold", 14);
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UIView *)transverseLineView
{
    return HT_LAZY(_transverseLineView, ({
    
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(240, 240, 240);
        [self.contentView addSubview:view];
        view;
    }));
}
- (UILabel *)describeLabel
{
    return HT_LAZY(_describeLabel, ({
    
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusLight", 12);
        label.textColor = SetColor(102, 102, 102);
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UIImageView *)likerOne
{
    return HT_LAZY(_likerOne, ({
    
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        view;
    }));
}
- (UIImageView *)likerTwo
{
    return HT_LAZY(_likerTwo, ({
        
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        view;
    }));
}
- (UIImageView *)likerThree
{
    return HT_LAZY(_likerThree, ({
        
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        view;
    }));
}
- (UIImageView *)likerFour
{
    return HT_LAZY(_likerFour, ({
        
        UIImageView *view = [UIImageView new];
        [self.contentView addSubview:view];
        view;
    }));
}
- (UIImageView *)likerFive
{
    return HT_LAZY(_likerFive, ({
        
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"discovery_like_more_34x34_"];
        [self.contentView addSubview:view];
        view;
    }));
}
- (UILabel *)likerNumLabel
{
    return HT_LAZY(_likerNumLabel, ({
        
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusLight", 12);
        label.textColor = SetColor(153, 153, 153);
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UILabel *)commentNumLabel
{
    return HT_LAZY(_commentNumLabel, ({
    
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusLight", 12);
        label.textColor = SetColor(153, 153, 153);
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        label;
    }));
}
- (UIImageView *)commentLogo
{
    return HT_LAZY(_commentLogo, ({
    
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"discovery_comment_23x22_"];
        [self.contentView addSubview:view];
        view;
    }));
}
- (UIView *)verticalLineView
{
    return HT_LAZY(_verticalLineView, ({
    
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(240, 240, 240);
        [self.contentView addSubview:view];
        view;
    }));
}
- (UIView *)grayView
{
    return HT_LAZY(_grayView, ({
    
        UIView *view = [UIView new];
        view.backgroundColor = SetColor(250, 250, 250);
        [self.contentView addSubview:view];
        view;
    }));
}
@end

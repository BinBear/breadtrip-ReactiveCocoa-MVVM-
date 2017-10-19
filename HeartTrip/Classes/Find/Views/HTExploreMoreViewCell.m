//
//  HTExploreMoreViewCell.m
//  HeartTrip
//
//  Created by 熊彬 on 17/1/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTExploreMoreViewCell.h"
#import "HTExploreMoreViewModel.h"
#import "HTFindVideosModel.h"

@interface HTExploreMoreViewCell ()
/**
 *  活动背景图
 */
@property (strong, nonatomic) UIImageView *backgroundImageView;
/**
 *  播放图
 */
@property (strong, nonatomic) UIImageView *startView;
/**
 *  观看人数
 */
@property (strong, nonatomic) UILabel *watchNumLabel;
/**
 *  活动标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  喜欢人数
 */
@property (strong, nonatomic) UILabel *likerNumLabel;
/**
 *  活动价格
 */
@property (strong, nonatomic) UILabel *priceLabel;
/**
 *  灰色view
 */
@property (strong, nonatomic) UIView *grayView;
/**
 *  点击活动详情
 */
@property (strong, nonatomic) UIButton *productLink;
@end

@implementation HTExploreMoreViewCell

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
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.height.equalTo(@200);
    }];
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.backgroundImageView);
        make.width.height.equalTo(@40);
    }];
    [self.watchNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-10);
        make.height.equalTo(@20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backgroundImageView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-60);
        make.height.equalTo(@20);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@20);
        make.width.equalTo(@60);
    }];
    [self.likerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.priceLabel.mas_left).offset(-10);
        make.height.equalTo(@20);
        
    }];
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.height.equalTo(@10);
    }];
    [self.productLink mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.startView.mas_bottom).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
}

- (void)bindViewModel:(id)viewModel withParams:(NSDictionary *)params
{
    HTExploreMoreViewModel *exploreModel = viewModel;
    HTFindVideosModel *model = exploreModel.videosData[[params[DataIndex] integerValue]];
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"FindFeedPlaceholder"]];
    self.watchNumLabel.text = [NSString stringWithFormat:@"%@个面粉看过",model.views];
    self.titleLabel.text = model.product_title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    if ([model.address isNotBlank] && [model.distance isNotBlank]) {
        self.likerNumLabel.text = [NSString stringWithFormat:@"%@ · %@ · %@个人喜欢",model.address,model.distance,model.liked_count];
    }else if ([model.address isNotBlank] && ![model.distance isNotBlank]){
        self.likerNumLabel.text = [NSString stringWithFormat:@"%@ · %@个人喜欢",model.address,model.liked_count];
    }else if (![model.address isNotBlank] && ![model.distance isNotBlank]){
        self.likerNumLabel.text = [NSString stringWithFormat:@"%@个人喜欢",model.liked_count];
    }else if (![model.address isNotBlank] && [model.distance isNotBlank]){
        self.likerNumLabel.text = [NSString stringWithFormat:@"%@ · %@个人喜欢",model.distance,model.liked_count];
    }
        
    [[[[self.productLink rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(__kindof UIControl * _Nullable x) {
           
            self.productLink.enabled = NO;
           
       }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
           
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               [exploreModel.productDetailCommand execute:model.product_id];
               [subscriber sendNext:nil];
               [subscriber sendCompleted];
               return nil;
           }];
       }] subscribeNext:^(id  _Nullable x) {
           
           self.productLink.enabled = YES;
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
- (UIImageView *)startView
{
    return HT_LAZY(_startView, ({
    
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"btn_start_20x20_"];
        [self.contentView addSubview:view];
        view;
    }));
}
- (UILabel *)watchNumLabel
{
    return HT_LAZY(_watchNumLabel, ({
    
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusLight", 13);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        label;
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
- (UILabel *)priceLabel
{
    return HT_LAZY(_priceLabel, ({
        
        UILabel *label = [UILabel new];
        label.font = HTSetFont(@"DamascusBold", 15);
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        label;
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
- (UIButton *)productLink
{
    return HT_LAZY(_productLink, ({
        
        UIButton *button = [UIButton new];
        button.adjustsImageWhenHighlighted = NO;
        [self.contentView addSubview:button];
        button;
    }));
}
@end

//
//  HTFindVideoView.m
//  HeartTrip
//
//  Created by 熊彬 on 16/12/2.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTFindVideoView.h"
#import <iCarousel.h>
#import "HTFindVideosModel.h"
#import "UIImageView+HTRoundImage.h"
#import "UIImage+HTRoundImage.h"

@interface HTFindVideoView ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic,strong) iCarousel *carousel;
/**  model数组 */
@property (nonatomic, strong) NSMutableArray *modelGroup;

@end

@implementation HTFindVideoView

#pragma mark - initview
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self carousel];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self carousel];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.top.bottom.equalTo(self);
    }];
}
- (void)setModelSignal:(RACSignal *)modelSignal
{
    _modelSignal = modelSignal;
    @weakify(self);
    [_modelSignal subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        if ([x count] > 0) {
            
            for (HTFindVideosModel *model in x) {
                [self.modelGroup addObject:model];
            }
            HTFindVideosModel *Model = [HTFindVideosModel new];
            Model.cover = @"VideoPlaceholder";
            [self.modelGroup addObject:Model];
        }
        
        dispatch_main_async_safe(^{
            
            [self.carousel reloadData];
            
        });
        
        
    }];
}
#pragma mark - iCarouselDelegate && iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.modelGroup.count;
}
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    CGFloat viewWidth = (SCREEN_WIDTH/375)*300;
    CGFloat viewHeight = (SCREEN_HEIGHT/667)*200;
    UILabel *titleLabel = nil;
    UILabel *likeLabel = nil;
    UIImageView *startView = nil;
    if (view == nil) {
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        view.backgroundColor = [UIColor clearColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, viewWidth-16, 50)];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = HTSetFont(@"DamascusBold", 15);
        [view addSubview:titleLabel];
        
        likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, viewHeight - 30, viewWidth-16, 20)];
        likeLabel.textColor = [UIColor whiteColor];
        likeLabel.font = HTSetFont(@"Damascus", 12);
        [view addSubview:likeLabel];
        
        startView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth - 40, viewHeight-40, 30, 30)];
        [view addSubview:startView];
    }

    HTFindVideosModel *model = self.modelGroup[index];
    if ([model.cover hasPrefix:@"http"]) {
        
        [((UIImageView *)view) HT_setImageWithCornerRadius:5 imageURL:[NSURL URLWithString:model.cover] placeholder:nil contentMode:UIViewContentModeScaleToFill size:CGSizeMake(viewWidth, viewHeight)];
        titleLabel.text = model.product_title;
        likeLabel.text = [NSString stringWithFormat:@"%@个面粉看过",model.views];
        startView.image = [UIImage imageNamed:@"btn_start_20x20_"];
        
    }else{
        
        UIImage *placeholderImage = [UIImage imageNamed:model.cover];
        ((UIImageView *)view).image = [placeholderImage HT_setRadius:5 size:CGSizeMake(viewWidth, viewHeight)];
    }
    
    return view;
}
- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    
}
- (void)dealloc
{
    self.carousel.dataSource = nil;
    self.carousel.delegate = nil;
}
#pragma mark - getter
- (iCarousel *)carousel
{
    return HT_LAZY(_carousel, ({
        
        iCarousel *carousel = [[iCarousel alloc] init];
        carousel.delegate = self;
        carousel.dataSource = self;
        carousel.pagingEnabled = YES;
        carousel.bounces = YES;
        carousel.type = iCarouselTypeRotary;
        [self addSubview:carousel];
        carousel;
    }));
}
- (NSMutableArray *)modelGroup
{
    return HT_LAZY(_modelGroup, @[].mutableCopy);
}
@end

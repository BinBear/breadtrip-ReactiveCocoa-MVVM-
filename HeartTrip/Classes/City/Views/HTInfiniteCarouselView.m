//
//  HTInfiniteCarouselView.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/15.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTInfiniteCarouselView.h"
#import "UIImage+HTRoundImage.h"
#import "UIImageView+HTRoundImage.h"
#import <iCarousel.h>
#import "HTBannerModel.h"
#import "HTWebViewModel.h"
#import "HTMediatorAction+HTWebViewController.h"

#define PAGE_OFFSET 10

@interface HTInfiniteCarouselView ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic,strong) iCarousel *carousel;
/**  url string 数组 */
@property (nonatomic, strong) NSMutableArray *imageURLStringsGroup;
/**
 *  无数据时背景图
 */
@property (strong, nonatomic) UIImageView *placeholderImageView;
@end

@implementation HTInfiniteCarouselView
#pragma mark - initview
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self carousel];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self carousel];
}
- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    self.carousel.autoscroll = autoScrollTimeInterval;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    [self bringSubviewToFront:self.placeholderImageView];
    UIImage *placeholderImage = [UIImage imageNamed:placeholder];
    self.placeholderImageView.image = [placeholderImage HT_setRadius:self.cornerRadius size:CGSizeMake(SCREEN_WIDTH - 2*PAGE_OFFSET, self.height)];
}
- (void)setImageURLSignal:(RACSignal *)imageURLSignal
{
    _imageURLSignal = imageURLSignal;
    @weakify(self);
    [_imageURLSignal subscribeNext:^(id  _Nullable x) {
       
        @strongify(self);
        if ([x count] > 0) {
            
            [self.placeholderImageView removeFromSuperview];

            [x enumerateObjectsUsingBlock:^(HTBannerModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.imageURLStringsGroup addObject:model];
            }];
        }
        
        dispatch_main_async_safe(^{
            
            [self.carousel reloadData];
            
        });
        
        
    }];
}
#pragma mark - life cycle
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.left.top.bottom.equalTo(self);
    }];
}
- (void)dealloc
{
    self.carousel.dataSource = nil;
    self.carousel.delegate = nil;
}
#pragma mark - iCarouselDelegate && iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.imageURLStringsGroup.count;
}
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    CGFloat viewWidth = SCREEN_WIDTH - 2*PAGE_OFFSET;
    if (view == nil) {
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.height)];
        view.backgroundColor = [UIColor clearColor];
    }
   
    HTBannerModel *model = self.imageURLStringsGroup[index];
    [((UIImageView *)view) HT_setImageWithCornerRadius:self.cornerRadius imageURL:[NSURL URLWithString:model.image_url] placeholder:self.placeholder contentMode:UIViewContentModeScaleToFill size:CGSizeMake(viewWidth, self.height)];
    return view;
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.8f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.carousel.itemWidth * 1.2, 0.0, 0.0);
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    HTBannerModel *model = self.imageURLStringsGroup[index];
    HTWebViewModel *viewModel = [[HTWebViewModel alloc] initWithServices:nil params:@{WebTitlekey:@"",RequestURLkey:model.html_url}];
    [[HTMediatorAction sharedInstance] pushWebViewControllerWithViewModel:viewModel];
    
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock(index);
    }
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(self.carousel.currentItemIndex);
    }
}
#pragma mark - getter
- (iCarousel *)carousel
{
    return HT_LAZY(_carousel, ({
    
        iCarousel *carousel = [[iCarousel alloc] init];
        carousel.delegate = self;
        carousel.dataSource = self;
        carousel.pagingEnabled = YES;
        carousel.autoscroll = 0.2;
        carousel.type = iCarouselTypeCustom;
        [self addSubview:carousel];
        carousel;
    }));
}
- (UIImageView *)placeholderImageView
{
    return HT_LAZY(_placeholderImageView, ({
    
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 2*PAGE_OFFSET, self.height)];
        view.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:view];
        view;
    }));
}
- (NSMutableArray *)imageURLStringsGroup
{
    return HT_LAZY(_imageURLStringsGroup, @[].mutableCopy);
}
@end

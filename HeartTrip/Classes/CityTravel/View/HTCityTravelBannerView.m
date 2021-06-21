//
//  HTCityTravelBannerView.m
//  HeartTrip
//
//  Created by vin on 2021/5/21.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTCityTravelBannerView.h"
#import "HTCityTravelNotesViewModel.h"
#import "HTBannerItemView.h"


@interface HTCityTravelBannerView ()<HTCycleViewProviderProtocol>
/// viewModel
@property (strong, nonatomic) HTCityTravelNotesViewModel *viewModel;

/// banner
@property (strong, nonatomic) HTCycleView *bannerView;
/// page
@property (strong, nonatomic) HTSegmentView *pageView;

/// Disposable数组
@property (strong, nonatomic) NSMutableArray<RACDisposable *> *disposees;
@end

@implementation HTCityTravelBannerView

+ (instancetype)bindViewWithViewModel:(id)viewModel {
    HTCityTravelBannerView *view = [[self alloc] init];
    view.viewModel = viewModel;
    [view configUI];
    [view configViewModel];
    return view;
}

- (void)configUI{
    
    self.backgroundColor = UIColorWhite;
    
    [self addSubview:self.bannerView];
    [self addSubview:self.pageView];
}

- (void)configViewModel {
    
    @weakify(self);
    
    // 配置cycleView的item
    self.signalForSelectorFromProtocol(@selector(configCycleView:index:), @protocol(HTCycleViewProviderProtocol)).subscribeNext(^(RACTuple *value) {
        [value.first view:^UIView * _Nonnull(HTCycleView * _Nonnull cycleView) {
            return [[HTBannerItemView alloc] init];
        }];
    });
    
    // 监听banner
    [self.disposees addObject:
     self.viewModel.refreshSignal(@"1").deliverOnMainThread.subscribeNext(^(NSNumber *value) {
        @strongify(self);
        [self.bannerView reloadData];
        [self.pageView reloadData];
    })];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.pageView.mas_top);
    }];
    [self.pageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(10 * self.viewModel.bannerData.count + 24, 4));
    }];
}
#pragma mark - Getter
- (HTCycleView *)bannerView{
    if (!_bannerView) {
        @weakify(self);
        HTCycleView *cycleView = [[HTCycleView alloc] initWithFrame:CGRectZero];
        [[[[[[[[[cycleView.configure direction:HTCycleViewDirectionLeft] interval:3]
               totalIndexs:^NSInteger(HTCycleView * _Nonnull cycleView) {
            @strongify(self);
            return self.viewModel.bannerData.count;
        }] roundingIndexChange:^(HTCycleView * _Nonnull cycleView, NSInteger indexs, NSInteger roundingIndex) {
            @strongify(self);
            [self.pageView clickItemAtIndex:roundingIndex];
        }] viewWillAppearAtIndex:^(HTCycleView * _Nonnull cycleView, HTBannerItemView *view, NSInteger index, BOOL isFirstLoad) {
            @strongify(self);
            HTBannerModel *item = self.viewModel.bannerData[index];
            if (item) {
                [cycleView reloadDataAtIndex:index parameter:item.image_url];
            }
        }] clickActionAtIndex:^(HTCycleView * _Nonnull cycleView, id  _Nonnull view, NSInteger index) {
            @strongify(self);
            HTBannerModel *item = self.viewModel.bannerData[index];
            if (item) {
                
            }
        }] viewProviderAtIndex:^id<HTCycleViewProviderProtocol> _Nonnull(HTCycleView * _Nonnull cycleView, NSInteger index) {
            @strongify(self);
            return self;
        }] isAutoCycle:true] isCycle:true];
        _bannerView = cycleView;
    }
    return _bannerView;
}
- (HTSegmentView *)pageView {
    if (!_pageView) {
        @weakify(self);
        _pageView =
        [HTSegmentView segmentViewWithFrame:CGRectZero
                             configureBlock:^(HTSegmentViewConfigure *configure) {
            @strongify(self);
            configure
            .keepingMarginAndInset(true)
            .itemMargin(6)
            .numberOfItems(self.viewModel.bannerData.count)
            .viewForItemAtIndex(^UIView *(UIView *currentView,
                                          NSInteger pageNumber,
                                          CGFloat progress,
                                          HTSegmentViewItemPosition positon,
                                          NSArray<UIView *> *animationViews) {
                
                UIView *view = currentView;
                if (!view) {
                    view = [UIView new];
                    view.layer.masksToBounds = true;
                    view.backgroundColor = UIColorMake(235, 229, 219);
                    view.layer.cornerRadius = 2;
                }
                
                if (progress == 0) {
                    view.alpha = .5;
                    view.sizeValue(4, 4);
                }
                
                if (progress == 1) {
                    view.alpha = 1;
                    view.sizeValue(18, 4);
                }
                return view;
                
            }).clickItemAtIndex(^BOOL(NSInteger page,
                                      BOOL isRepeat){
                return NO;
            });
        }];
        _pageView.backgroundColor = UIColorClear;
    }
    return _pageView;
}

- (NSMutableArray<RACDisposable *> *)disposees{
    return HT_LAZY(_disposees, @[].mutableCopy);
}
- (void)dealloc{
    [self.disposees makeObjectsPerformSelector:@selector(dispose)];
}
@end

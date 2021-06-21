//
//  HTFindVideoView.m
//  HeartTrip
//
//  Created by vin on 2021/5/24.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTFindVideoView.h"
#import "HTFindViewModel.h"
#import "HTFindVideoItemView.h"

@interface HTFindVideoView ()<HTCycleViewProviderProtocol>
/// viewModel
@property (strong, nonatomic) HTFindViewModel *viewModel;

/// banner
@property (strong, nonatomic) HTCycleView *bannerView;
/// page
@property (strong, nonatomic) HTSegmentView *pageView;

/// Disposable数组
@property (strong, nonatomic) NSMutableArray<RACDisposable *> *disposees;
@end


@implementation HTFindVideoView

+ (instancetype)bindViewWithViewModel:(id)viewModel {
    HTFindVideoView *view = [[self alloc] init];
    view.viewModel = viewModel;
    [view configUI];
    [view configViewModel];
    return view;
}

- (void)configUI{
    
    self.backgroundColor = UIColorWhite;
    
    [self addSubview:self.bannerView];
}

- (void)configViewModel {
    
    @weakify(self);
    
    // 配置cycleView的item
    self.signalForSelectorFromProtocol(@selector(configCycleView:index:), @protocol(HTCycleViewProviderProtocol)).subscribeNext(^(RACTuple *value) {
        [value.first view:^UIView * _Nonnull(HTCycleView * _Nonnull cycleView) {
            return [[HTFindVideoItemView alloc] init];
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
        make.top.bottom.left.right.equalTo(self);
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
            return self.viewModel.videoData.count;
        }] roundingIndexChange:^(HTCycleView * _Nonnull cycleView, NSInteger indexs, NSInteger roundingIndex) {
            @strongify(self);
            if (!self.pageView.superview) {
                self.pageView.backgroundColor = UIColorClear;
                self.pageView.centerXValue(cycleView.width * 0.5);
                self.pageView.bottomValue(cycleView.height - 25);
                [cycleView addSubview:self.pageView];
            }
            [self.pageView clickItemAtIndex:roundingIndex];
        }] viewWillAppearAtIndex:^(HTCycleView * _Nonnull cycleView, HTFindVideoItemView *view, NSInteger index, BOOL isFirstLoad) {
            @strongify(self);
            HTFindVideosModel *item = self.viewModel.videoData[index];
            if (item) {
                [cycleView reloadDataAtIndex:index parameter:item];
            }
        }] clickActionAtIndex:^(HTCycleView * _Nonnull cycleView, id  _Nonnull view, NSInteger index) {
            @strongify(self);
            HTFindVideosModel *item = self.viewModel.videoData[index];
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
        [HTSegmentView segmentViewWithFrame:CGRectMake(0, 0, 10 * self.viewModel.videoData.count + 24, 4)
                             configureBlock:^(HTSegmentViewConfigure *configure) {
            @strongify(self);
            configure
            .keepingMarginAndInset(true)
            .itemMargin(6)
            .numberOfItems(self.viewModel.videoData.count)
            .viewForItemAtIndex(^UIView *(UIView *currentView,
                                          NSInteger pageNumber,
                                          CGFloat progress,
                                          HTSegmentViewItemPosition positon,
                                          NSArray<UIView *> *animationViews) {
                
                UIView *view = currentView;
                if (!view) {
                    view = [UIView new];
                    view.layer.masksToBounds = true;
                    view.backgroundColor = UIColor.whiteColor;
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

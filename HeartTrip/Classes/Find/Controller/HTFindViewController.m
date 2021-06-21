//
//  HTFindViewController.m
//  HeartTrip
//
//  Created by vin on 2021/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTFindViewController.h"
#import "HTFindFeedCell.h"
#import "HTFindVideoView.h"

@interface HTFindViewController ()
/// 列表
@property (strong, nonatomic) UITableView *listTableView;
/// banner
@property (strong, nonatomic) HTFindVideoView *bannerView;
/// Disposable数组
@property (strong, nonatomic) NSMutableArray<RACDisposable *> *disposees;
@end

@implementation HTFindViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBase];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(NavigationContentTopConstant);
        make.bottom.mas_equalTo(-TabBarHeight);
    }];
}
#pragma mark - Bind
- (void)bindViewModelDidLoad{
    
    @weakify(self);
    
    // 上下拉刷新
    [self.listTableView addRefreshWithKaKaHeaderBlock:^{
        @strongify(self);
        self.viewModel.requestCommand(@"list").execute(@(HTRefreshActionType_Refresh));
    } withKaKaFooterBlock:^{
        @strongify(self);
        self.viewModel.requestCommand(@"list").execute(@(HTRefreshActionType_LoadMore));
    }];
    
    // 监听列表数据
    self.viewModel.requestCommand(@"list").subscribeAll(^(id  _Nonnull value) {
        
    }, ^(NSError * _Nonnull error) {
        @strongify(self);
        self.viewModel.emptyType = HTEmptyType_NetworkError;
        [self.listTableView reloadData];
    }, ^(id  _Nonnull value) {
        @strongify(self);
        if (![value boolValue]) {
            self.viewModel.emptyType = HTEmptyType_OneAction;
            [HTHUD dismissWithView:self.listTableView];
            [self.listTableView endRefresh];
            [self updateHeadrViewConstraints];
            [self.listTableView reloadData];
        }
    });
    self.viewModel.requestCommand(@"list").execute(@(HTRefreshActionType_Refresh));
}

#pragma mark - Config
- (void)configBase{
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    logo.image = UIImageMake(@"breadTrip_logo");
    self.navigationItem.titleView = logo;
    [self.view addSubview:self.listTableView];
    [self bannerView];
    [HTHUD loadingViewInView:self.listTableView];
}

- (void)updateHeadrViewConstraints{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    self.bannerView.rectValue(0, 0, SCREEN_WIDTH, 215);
    [self.listTableView layoutIfNeeded];
    [self.listTableView setTableHeaderView:self.viewModel.videoData.count?self.bannerView:view];
}
#pragma mark - Getter
- (UITableView *)listTableView {
    return HT_LAZY(_listTableView, ({
        UITableView *tableView = [UITableView ht_tableViewWithFrame:CGRectMake(0, NavigationContentTopConstant, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTopConstant-TabBarHeight)
                                                              style:UITableViewStyleGrouped
                                                      tableViewData:self.viewModel
                                                        cellClasses:@[HTFindFeedCell.class]
                                            headerFooterViewClasses:nil
                                                  delegateConfigure:[self tableViewConfigure]];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        tableView.backgroundColor = UIColorWhite;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 410;
        tableView;
    }));
}
- (void (^)(HTTableViewDelegateConfigure *configure))tableViewConfigure{
    @weakify(self);
    return
    ^(HTTableViewDelegateConfigure *configure) {
        
        configure.configNumberOfRowsInSection(^NSInteger(UITableView *tableView, NSInteger section){
            @strongify(self);
            return self.viewModel.feedData.count;
        }).configCellClassForRow(^Class(id cellData, NSIndexPath *indexPath) {
            return HTFindFeedCell.class;
        }).configDidSelectRowAtIndexPath(^(UITableView *tableView, NSIndexPath *indexPath) {
            @strongify(self);
            HTFindFeedModel *listItem = self.viewModel.feedData[indexPath.row];
            
        }).configEmtyView(^(UITableView *tableView, UIView *emtyContainerView) {
            @strongify(self);
            if (self.viewModel.emptyType == HTEmptyType_NoStatus) { return; }
            [HTHUD showEmptyViewToView:emtyContainerView
                             configure:^(HTHUDConfigure * _Nonnull configure) {
                @strongify(self);
                HTHUDConfigureItem *item = [HTHUDConfigureItem new];
                item.title = @"重新加载";
                item.btnBgImg = UIImageMake(@"EmptyButtonBg");
                item.confirmSignal = ^{
                    self.viewModel.requestCommand(@"list").execute(@(HTRefreshActionType_Refresh));
                };
                configure.emptyType(@(self.viewModel.emptyType)).title(@"暂无数据").imageJsonName(@"Travel_Nodata").oneItem(item);
            }];
            
        });
    };
}

- (HTFindVideoView *)bannerView {
    return HT_LAZY(_bannerView, ({
        [HTFindVideoView bindViewWithViewModel:self.viewModel];
    }));
}
- (NSMutableArray<RACDisposable *> *)disposees{
    return HT_LAZY(_disposees, @[].mutableCopy);
}
- (void)dealloc{
    [self.disposees makeObjectsPerformSelector:@selector(dispose)];
}
@end

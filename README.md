# 仿面包旅行(ReactiveCocoa+MVVM)
 此项目是将面包旅行跟面包猎人两个应用结合。用ReactiveCocoa+MVVM，最开始想用公司项目，但考虑到要脱敏，不方便。项目中的所有接口都是抓包，只是用来学习练手之用。
 
 **注意**：直接运行项目出现 xxx not found 的错误，请先cd到项目路径下执行：pod update 即可。
 
***

## ReactiveCocoa
[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)（简称为RAC）,是由Github开源的一个应用于iOS和OS开发的框架,RAC具有函数式编程和响应式编程的特性。由于项目是使用的OC,所以我使用的是ReactiveCocoa2.5。如果你的项目是纯OC，也可以使用[ReactiveObjC](https://github.com/ReactiveCocoa/ReactiveObjC)。


## MVVM
MVVM是一个UI设计模式。它是MV*模式集合中的一员。MV*模式还包含MVC(Model View Controller)、MVP(Model View Presenter)等。这些模式的目的在于将UI逻辑与业务逻辑分离，以让程序更容易开发和测试。其中 ViewModel 的主要职责是处理业务逻辑并提供 View 所需的数据，这样 VC 就不用关心业务，自然也就瘦了下来。ViewModel 只关心业务数据不关心 View，所以不会与 View 产生耦合，也就更方便进行单元测试。

![MVVM.png](/ReadmeImage/MVVM.png "MVVM.png")

MVVM模式依赖于数据绑定，由于iOS没有数据绑定框架。但幸运的是ReactiveCocoa可以很方便的实现这个，所以ReactiveCocoa是实现MVVM的最佳方式。不通过ReactiveCocoa也可以实现MVVM一样可以实现，感兴趣的可以看这篇[博客](http://limboy.me/tech/2015/09/27/ios-mvvm-without-reactivecocoa.html)。

## 更新

### 2021.6

* 完全重写了此项目
* 实现新的、更加完善、易用的路由系统
*  基于新的路由系统，重构了架构
*  将长时间积累的基础组件开源，包括网络请求、RAC等等组件
*  ……

## To-Do list
- [ ] 使用Texture重写页面
- [ ] 实现主题切换

## 运行效果

### 首页
```objc
@interface HTCityTravelNotesController ()
/// 列表
@property (strong, nonatomic) UITableView *listTableView;
/// banner
@property (strong, nonatomic) HTCityTravelBannerView *bannerView;
/// Disposable数组
@property (strong, nonatomic) NSMutableArray<RACDisposable *> *disposees;
@end

@implementation HTCityTravelNotesController

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
    [self.listTableView setTableHeaderView:self.viewModel.bannerData.count?self.bannerView:view];
}

#pragma mark - Getter
- (UITableView *)listTableView {
    return HT_LAZY(_listTableView, ({
        UITableView *tableView = [UITableView ht_tableViewWithFrame:CGRectMake(0, NavigationContentTopConstant, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationContentTopConstant-TabBarHeight)
                                                              style:UITableViewStyleGrouped
                                                      tableViewData:self.viewModel
                                                        cellClasses:@[HTCityTravelCell.class]
                                            headerFooterViewClasses:nil
                                                  delegateConfigure:[self tableViewConfigure]];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        tableView.backgroundColor = UIColorWhite;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.rowHeight = 200;
        tableView;
    }));
}
- (void (^)(HTTableViewDelegateConfigure *configure))tableViewConfigure{
    @weakify(self);
    return
    ^(HTTableViewDelegateConfigure *configure) {
        
        configure.configNumberOfRowsInSection(^NSInteger(UITableView *tableView, NSInteger section){
            @strongify(self);
            return self.viewModel.listData.count;
        }).configCellClassForRow(^Class(id cellData, NSIndexPath *indexPath) {
            return HTCityTravelCell.class;
        }).configDidSelectRowAtIndexPath(^(UITableView *tableView, NSIndexPath *indexPath) {
            @strongify(self);
            HTCityTravelItemModel *listItem = self.viewModel.listData[indexPath.row];
            if (!listItem) { return; }
            self.viewModel.requestCommand(@"push").execute(listItem);
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

- (HTCityTravelBannerView *)bannerView {
    return HT_LAZY(_bannerView, ({
        [HTCityTravelBannerView bindViewWithViewModel:self.viewModel];
    }));
}
- (NSMutableArray<RACDisposable *> *)disposees{
    return HT_LAZY(_disposees, @[].mutableCopy);
}
- (void)dealloc{
    [self.disposees makeObjectsPerformSelector:@selector(dispose)];
}
@end

```
![city.png](/ReadmeImage/city.png "city.png")

### 发现
```objc
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

```
![find.png](/ReadmeImage/find.png "find.png")
![finddetail.png](/ReadmeImage/finddetail.png "finddetail.png")
## 运行环境
- iOS 11+
- Xcode 12+

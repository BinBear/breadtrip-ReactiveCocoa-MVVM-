# 仿面包旅行(ReactiveCocoa+MVVM)
 此项目是将面包旅行跟面包猎人两个应用结合。用ReactiveCocoa+MVVM，最开始想用公司项目，但考虑到要脱敏，不方便。项目中的所有接口都是抓包，只是用来学习练手之用。
***

## ReactiveCocoa
[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)（简称为RAC）,是由Github开源的一个应用于iOS和OS开发的框架,RAC具有函数式编程和响应式编程的特性。现在ReactiveCocoa已经到RAC5，支持swift3，由于项目是使用的OC,所以我使用的是ReactiveCocoa2.5。如果你的项目是纯OC，也可以使用[ReactiveObjC](https://github.com/ReactiveCocoa/ReactiveObjC)。

ReactiveCocoa的函数式编程方式的学习成本比较大，想要学习ReactiveCocoa的可以看[这里](https://github.com/ReactiveCocoaChina/ReactiveCocoaChineseResources)。

## MVVM
MVVM是一个UI设计模式。它是MV*模式集合中的一员。MV*模式还包含MVC(Model View Controller)、MVP(Model View Presenter)等。这些模式的目的在于将UI逻辑与业务逻辑分离，以让程序更容易开发和测试。其中 ViewModel 的主要职责是处理业务逻辑并提供 View 所需的数据，这样 VC 就不用关心业务，自然也就瘦了下来。ViewModel 只关心业务数据不关心 View，所以不会与 View 产生耦合，也就更方便进行单元测试。

![MVVM.png](/ReadmeImage/MVVM.png "MVVM.png")

MVVM模式依赖于数据绑定，由于iOS没有数据绑定框架。但幸运的是ReactiveCocoa可以很方便的实现这个，所以ReactiveCocoa是实现MVVM的最佳方式。不通过ReactiveCocoa也可以实现MVVM一样可以实现，感兴趣的可以看这篇[博客](http://limboy.me/tech/2015/09/27/ios-mvvm-without-reactivecocoa.html)。

## 运行效果

### 首页
```objc
@implementation HTCityTravelNotesController

#pragma mark - Life Cycle

- (instancetype)initWithViewModel:(HTCityTravelViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SetColor(251, 247, 237);
    
    [self setNavigationBar];
    
    [self bindViewModel];

}
#pragma mark - bind
- (void)bindViewModel
{
    self.isSearch = NO;
    
    [self.viewModel.travelCommand execute:@1];
    
    self.bannerView.imageURLSignal = RACObserve(self.viewModel, bannerData);
    
    self.tripBindingHelper = [HTTableViewBindingHelper bindingHelperForTableView:self.tripTableView sourceSignal:RACObserve(self.viewModel, travelData) selectionCommand:nil templateCell:@"HTCityTravelCell"];
    
    
    @weakify(self);
    // 下拉刷新
    self.tripTableView.mj_header = [HTRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.travelCommand execute:@1];
    }];
    [[self.viewModel.travelCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.tripTableView.mj_header endRefreshing];
        }
    }];
    
    // 加载更多
    self.tripTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.travelMoreDataCommand execute:@1];
    }];
    [[self.viewModel.travelMoreDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.tripTableView.mj_footer endRefreshing];
        }
    }];
    
    // 搜索框
    [[self
      rac_signalForSelector:@selector(textFieldDidBeginEditing:)
      fromProtocol:@protocol(UITextFieldDelegate)]
    	subscribeNext:^(RACTuple *tuple) {
            @strongify(self)
            if (tuple.first == self.searchTextField){
                
                [self.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [self.rightButton setTitle:@"取消" forState:UIControlStateNormal];
                self.isSearch = YES;
            }
        }];
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple *tuple) {
        
        @strongify(self)
        if (tuple.first == self.searchTextField){
            
            self.isSearch = NO;
            [self.rightButton setImage:[UIImage imageNamed:@"tabbar_user_button_image_22x22_"] forState:UIControlStateNormal];
            [self.rightButton setTitle:@"" forState:UIControlStateNormal];
        }
    }];
    
    RAC(self.viewModel,isSearch) = RACObserve(self, isSearch);
    
    // 导航栏navigationItem
    self.rightButton.rac_command = self.viewModel.rightBarButtonItemCommand;
    
    [self.viewModel.rightBarButtonItemCommand.executionSignals.switchToLatest subscribeNext:^(NSNumber *isSearch) {
        
        @strongify(self)
        if ([isSearch boolValue]) {
            [self.searchTextField resignFirstResponder];
        }else{
            NSLog(@"进入个人中心");
        }
        
    }];
}

```
![city.png](/ReadmeImage/city.png "city.png")

### 发现
```objc
@implementation HTFindViewController

#pragma mark - Life Cycle
- (instancetype)initWithViewModel:(HTFindViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SetColor(250, 250, 250);
    self.navigationItem.title = @"发现";
    
    [self bindViewModel];
}

#pragma mark - bind
- (void)bindViewModel
{
    // findTableView
    self.findBindingHelper = [HTTableViewBindingHelper bindingHelperForTableView:self.findTableView sourceSignal:RACObserve(self.viewModel, feedData) selectionCommand:self.viewModel.feedDetailCommand templateCell:@"HTFindFeedCell"];
    
    // 刷新viedeoView
    self.videoView.modelSignal = RACObserve(self.viewModel, videoData);
    
    @weakify(self);
    // 下拉刷新
    self.findTableView.mj_header = [HTRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.feedDataCommand execute:@1];
    }];
    [[self.viewModel.feedDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.findTableView.mj_header endRefreshing];
        }
    }];
    
    // 加载更多
    self.findTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.feedMoreDataCommand execute:@1];
    }];
    [[self.viewModel.feedMoreDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.findTableView.mj_footer endRefreshing];
        }
    }];
    
    [self.viewModel.feedDataCommand execute:@1];
}

```
![find.png](/ReadmeImage/find.png "find.png")
![finddetail.png](/ReadmeImage/finddetail.png "finddetail.png")
## 运行环境
- iOS 8+
- Xcode 8+

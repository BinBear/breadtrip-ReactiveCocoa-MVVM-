//
//  HTCityTravelNotesController.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTCityTravelNotesController.h"
#import "HTInfiniteCarouselView.h"
#import "UIImageView+HTRoundImage.h"
#import "HTTableViewBindingHelper.h"
#import "HTTableView.h"
#import "HTBannerModel.h"
#import "HTCityTravelViewModel.h"
#import "HTCityTravelCell.h"
#import "HTTextField.h"

@interface HTCityTravelNotesController ()<UITableViewDelegate,UITextFieldDelegate>
/**
 *  Banner
 */
@property (strong, nonatomic) HTInfiniteCarouselView *bannerView;
/**
 *  轮播图
 */
@property (strong, nonatomic) UIView *headerView;
/**
 *  tableview
 */
@property (strong, nonatomic) HTTableView *tripTableView;
/**
 *  bind tableview
 */
@property (strong, nonatomic) HTTableViewBindingHelper *tripBindingHelper;
/**
 *  bind ViewModel
 */
@property (strong, nonatomic) HTCityTravelViewModel *viewModel;
/**
 *  banner图数据
 */
@property (strong, nonatomic) NSMutableArray *bannerData;
/**
 *  rightButton
 */
@property (strong, nonatomic) UIButton *rightButton;
/**
 *  leftButton
 */
@property (strong, nonatomic) UIButton *leftButton;
/**
 *  是否为搜索
 */
@property (assign , nonatomic) BOOL  isSearch;
/**
 *  搜索框
 */
@property (strong, nonatomic) HTTextField *searchTextField;

@end

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
- (void)setNavigationBar
{
    // 导航栏navigationItem

    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [searchView addSubview:self.searchTextField];
    self.navigationItem.titleView = searchView;
    
}

#pragma mark - getter
- (UIView *)headerView
{
    return HT_LAZY(_headerView, ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        [view addSubview:self.bannerView];
        view;
    }));
}
- (HTInfiniteCarouselView *)bannerView
{
    return HT_LAZY(_bannerView, ({
    
        HTInfiniteCarouselView *view = [[HTInfiniteCarouselView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 170)];
        view.cornerRadius = 5;
        view.autoScrollTimeInterval = 0.2;
        view.placeholder = @"tripdisplay_photocell_placeholder";
        view;
    }));
}
- (HTTableView *)tripTableView
{
    return HT_LAZY(_tripTableView, ({
    
        HTTableView *tableView = [[HTTableView alloc] initWithFrame:self.view.bounds];
        tableView.tableHeaderView = self.headerView;
        tableView.rowHeight = 180;
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (UIButton *)rightButton
{
    return HT_LAZY(_rightButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 20);
        [button setImage:[UIImage imageNamed:@"tabbar_user_button_image_22x22_"] forState:UIControlStateNormal];
        button.titleLabel.font = HTSetFont(@"DamascusLight", 14);
        button;
    }));
}
- (UIButton *)leftButton
{
    return HT_LAZY(_leftButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 40);
        [button setImage:[UIImage imageNamed:@"breadTrip_logo"] forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button;
    }));
}
- (HTTextField *)searchTextField
{
    return HT_LAZY(_searchTextField, ({
    
        HTTextField *view = [[HTTextField alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-140, 25)];
        view.delegate = self;
        view;
    }));
}
- (NSMutableArray *)bannerData
{
    return HT_LAZY(_bannerData, @[].mutableCopy);
}
@end

//
//  HTExploreMoreViewController.m
//  HeartTrip
//
//  Created by 熊彬 on 17/1/17.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTExploreMoreViewController.h"
#import "HTExploreMoreViewModel.h"
#import "HTTableViewBindingHelper.h"
#import "HTTableView.h"
#import "HTExploreMoreViewCell.h"

@interface HTExploreMoreViewController ()

/**
 *  bind tableview
 */
@property (strong, nonatomic) HTTableViewBindingHelper *exploreBindingHelper;
/**
 *  bind ViewModel
 */
@property (strong, nonatomic) HTExploreMoreViewModel *viewModel;
/**
 *  tableview
 */
@property (strong, nonatomic) HTTableView *exploreTableView;

@end

@implementation HTExploreMoreViewController

#pragma mark - Life Cycle
- (instancetype)initWithViewModel:(HTExploreMoreViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SetColor(250, 250, 250);
    self.navigationItem.title = @"热门活动现场";
    
    [self bindViewModel];
}

#pragma mark - bind
- (void)bindViewModel
{
    // findTableView
    self.exploreBindingHelper = [HTTableViewBindingHelper bindingHelperForTableView:self.exploreTableView sourceSignal:RACObserve(self.viewModel, videosData) selectionCommand:nil templateCell:@"HTExploreMoreViewCell" withViewModel:self.viewModel];
    
    @weakify(self);
    // 下拉刷新
    self.exploreTableView.mj_header = [HTRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.exploreDataCommand execute:@1];
    }];
    [[self.viewModel.exploreDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.exploreTableView.mj_header endRefreshing];
        }
    }];
    
    // 加载更多
    self.exploreTableView.mj_footer = [HTRefreshGifFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.exploreMoreDataCommand execute:@1];
    }];
    [[self.viewModel.exploreMoreDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
        @strongify(self);
        if (!executing.boolValue) {
            [self.exploreTableView.mj_footer endRefreshing];
        }
    }];
    
    [self.viewModel.exploreDataCommand execute:@1];
}

#pragma mark - getter
- (HTTableView *)exploreTableView
{
    return HT_LAZY(_exploreTableView, ({
    
        HTTableView *tableView = [[HTTableView alloc] initWithFrame:self.view.bounds];
        tableView.rowHeight = 270;
        [self.view addSubview:tableView];
        tableView;
    }));
}
@end

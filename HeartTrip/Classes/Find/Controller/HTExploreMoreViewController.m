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
#import "HTExplainAlertView.h"

@interface HTExploreMoreViewController ()

/**
 *  bind tableview
 */
@property (strong, nonatomic) HTTableViewBindingHelper *exploreBindingHelper;
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) HTExploreMoreViewModel *viewModel;
/**
 *  tableview
 */
@property (strong, nonatomic) HTTableView *exploreTableView;
/**
 *  rightButton
 */
@property (strong, nonatomic) UIButton *rightButton;

@end

@implementation HTExploreMoreViewController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SetColor(250, 250, 250);
    self.navigationItem.title = @"热门活动现场";
    
    [self bindViewModel];
}

#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    // findTableView
    self.exploreBindingHelper = [HTTableViewBindingHelper bindingHelperForTableView:self.exploreTableView sourceSignal:RACObserve(self.viewModel, videosData) selectionCommand:self.viewModel.videoPlayerCommand templateCell:@"HTExploreMoreViewCell" withViewModel:self.viewModel];
    
    @weakify(self);
    // 下拉刷新
    self.exploreTableView.mj_header = [HTRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.requestDataCommand execute:@1];
    }];
    [[self.viewModel.requestDataCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable executing) {
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
    
    [self.viewModel.requestDataCommand execute:@1];
    
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.rightButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [[HTExplainAlertView sharedAlertManager] showExplainAlertView];
    }];
    
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
- (UIButton *)rightButton
{
    return HT_LAZY(_rightButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [button setTitle:@"说明" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = HTSetFont(@"DamascusBold", 15);
        button;
    }));
}
@end

//
//  HTFindViewController.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTFindViewController.h"
#import "HTFindViewModel.h"
#import "HTFindVideoView.h"
#import "HTTableView.h"
#import "HTTableViewBindingHelper.h"

@interface HTFindViewController ()
/**
 *  bind tableview
 */
@property (strong, nonatomic) HTTableViewBindingHelper *findBindingHelper;
/**
 *  bind ViewModel
 */
@property (strong, nonatomic) HTFindViewModel *viewModel;
/**
 *  视频Banner
 */
@property (strong, nonatomic) HTFindVideoView *videoView;
/**
 *  tableview
 */
@property (strong, nonatomic) HTTableView *findTableView;
/**
 *  视频Banner
 */
@property (strong, nonatomic) UIView *headerView;
@end

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

#pragma mark - getter
- (HTFindVideoView *)videoView
{
    return HT_LAZY(_videoView, ({
    
        HTFindVideoView *view = [[HTFindVideoView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 200)];
        [self.view addSubview:view];
        view;
    }));
}
- (UIView *)headerView
{
    return HT_LAZY(_headerView, ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.videoView];
        view;
    }));
}
- (HTTableView *)findTableView
{
    return HT_LAZY(_findTableView, ({
        
        HTTableView *tableView = [[HTTableView alloc] initWithFrame:self.view.bounds];
        tableView.tableHeaderView = self.headerView;
        tableView.rowHeight = 410;
        [self.view addSubview:tableView];
        tableView;
    }));
}
@end

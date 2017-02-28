//
//  HTTableViewBindingHelper.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/16.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTTableViewBindingHelper.h"
#import "HTReactiveView.h"
#import "HTViewModel.h"
#import <UIScrollView+EmptyDataSet.h>


@interface HTTableViewBindingHelper ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**
 *  tableView
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 *  数据源
 */
@property (strong, nonatomic) NSArray *data;
/**
 *  selection
 */
@property (strong, nonatomic) RACCommand *didSelectionCommand;
/**
 *  cell重用标识
 */
@property (copy, nonatomic) NSString *cellIdentifier;
/**
 *  viewModel
 */
@property (strong, nonatomic) HTViewModel  *viewModel;
@end

@implementation HTTableViewBindingHelper
#pragma mark - init
- (instancetype)initWithTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand withCellType:(NSDictionary *)CellTypeDic withViewModel:(HTViewModel *)viewModel
{
    if (self = [super init]) {
        
        _tableView = tableView;
        _data = [NSArray array];
        _didSelectionCommand = didSelectionCommand;
        _viewModel = viewModel;
        
        @weakify(self);
        [source subscribeNext:^(id x) {
            @strongify(self);
            self.data = x;
            [self.tableView reloadData];
        }];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        
        NSString *cellType = CellTypeDic[@"cellType"];
        _cellIdentifier = CellTypeDic[@"cellName"];
        if ([cellType isEqualToString:@"codeType"]) {
            
            Class cell =  NSClassFromString(_cellIdentifier);
            [_tableView registerClass:cell forCellReuseIdentifier:_cellIdentifier];
            
        }else{
            
            UINib *templateCellNib = [UINib nibWithNibName:_cellIdentifier bundle:nil];
            [_tableView registerNib:templateCellNib forCellReuseIdentifier:_cellIdentifier];
        }
        
        [viewModel.requestDataCommand.executing subscribeNext:^(NSNumber *executing) {
            @strongify(self)
            UIView *emptyDataSetView = [self.tableView.subviews.rac_sequence objectPassingTest:^(UIView *view) {
                return [NSStringFromClass(view.class) isEqualToString:@"DZNEmptyDataSetView"];
            }];
            emptyDataSetView.alpha = 1.0 - executing.floatValue;
        }];
        
    }
    return self;
}
+ (instancetype)bindingHelperForTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand templateCell:(NSString *)templateCell  withViewModel:(HTViewModel *)viewModel
{
    NSDictionary *cellDic = @{@"cellType":@"codeType",@"cellName":templateCell};
    return [[HTTableViewBindingHelper alloc] initWithTableView:tableView
                                                  sourceSignal:source
                                              selectionCommand:didSelectionCommand
                                                  withCellType:cellDic
                                                 withViewModel:viewModel];
}
+ (instancetype)bindingHelperForTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand templateCellWithNib:(NSString *)templateCell withViewModel:(HTViewModel *)viewModel
{
    NSDictionary *cellDic = @{@"cellType":@"nibType",@"cellName":templateCell};
    return [[HTTableViewBindingHelper alloc] initWithTableView:tableView
                                                  sourceSignal:source
                                              selectionCommand:didSelectionCommand
                                                  withCellType:cellDic
                                                 withViewModel:viewModel];
}
- (void)dealloc
{
    self.delegate = nil;
}
#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = (self.data.count == 0) ? YES : NO;
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<HTReactiveView> cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];

    [cell bindViewModel:self.viewModel withParams:@{DataIndex:@(indexPath.row)}];
    return (UITableViewCell *)cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.didSelectionCommand execute:self.data[indexPath.row]];
    
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}
#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    NSString *text;
    if (self.viewModel.netWorkStatus == RealStatusNotReachable) {
        
        text = @"网络君失联了,请检查你的网络设置!";
    }else{
        text = @"此页面可能去火星旅游了!";
    }
    UIFont *font = HTSetFont(@"HelveticaNeue-Light", 17.0);
    UIColor *textColor = [UIColor grayColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    if (self.viewModel.netWorkStatus == RealStatusNotReachable) {
        return [UIImage imageNamed:@"NoNetwork"];
    }else{
        return [UIImage imageNamed:@"NoData"];
    }
    
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text;
    if (self.viewModel.netWorkStatus == RealStatusNotReachable) {
        
        text = @"检查网络设置";
    }else{
        text = @"重新加载";
    }
    UIFont *font = HTSetFont(@"HelveticaNeue-Light", 15.0);
    UIColor *textColor = [UIColor lightGrayColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName = @"";
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"button_background_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"button_background_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(-19.0, -61.0, -19.0, -61.0);

    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.data.count == 0) ? YES : NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return SetColor(251, 247, 237);
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
    if (self.viewModel.netWorkStatus == RealStatusNotReachable) {
        NSURL *url= [NSURL URLWithString:@"prefs:root=Network"];
        if( [[UIApplication sharedApplication] canOpenURL:url] ) {
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication] openURL:url options:@{}completionHandler:nil];
            }else{
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }else{
        [self.viewModel.requestDataCommand execute:@1];
    }
}

#pragma mark = UITableViewDelegate forwarding

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end

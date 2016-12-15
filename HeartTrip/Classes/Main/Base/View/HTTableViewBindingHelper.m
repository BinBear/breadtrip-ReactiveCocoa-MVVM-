//
//  HTTableViewBindingHelper.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/16.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTTableViewBindingHelper.h"
#import "HTReactiveView.h"


@interface HTTableViewBindingHelper ()<UITableViewDelegate,UITableViewDataSource>
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
@end

@implementation HTTableViewBindingHelper
#pragma mark - init
- (instancetype)initWithTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand templateCell:(NSString *)templateCell
{
    if (self = [super init]) {
        
        _tableView = tableView;
        _data = [NSArray array];
        _didSelectionCommand = didSelectionCommand;
        
        @weakify(self);
        [source subscribeNext:^(id x) {
            @strongify(self);
            self.data = x;
            [self.tableView reloadData];
        }];
        
        _cellIdentifier = templateCell;
        
        Class cell =  NSClassFromString(templateCell);
        
        [_tableView registerClass:cell forCellReuseIdentifier:templateCell];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;

    }
    return self;
}
+ (instancetype)bindingHelperForTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand templateCell:(NSString *)templateCell
{
    return [[HTTableViewBindingHelper alloc] initWithTableView:tableView
                                                  sourceSignal:source
                                              selectionCommand:didSelectionCommand
                                                  templateCell:templateCell];
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

    [cell bindViewModel:self.data[indexPath.row]];
    return (UITableViewCell *)cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self.didSelectionCommand execute:self.data[indexPath.row]];
    
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
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

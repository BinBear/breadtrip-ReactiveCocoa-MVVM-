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
/**
 *  viewModel
 */
@property (strong, nonatomic) id viewModel;
@end

@implementation HTTableViewBindingHelper
#pragma mark - init
- (instancetype)initWithTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand withCellType:(NSDictionary *)CellTypeDic withViewModel:(id)viewModel
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
        
        NSString *cellType = CellTypeDic[@"cellType"];
        _cellIdentifier = CellTypeDic[@"cellName"];
        if ([cellType isEqualToString:@"codeType"]) {
            
            Class cell =  NSClassFromString(_cellIdentifier);
            [_tableView registerClass:cell forCellReuseIdentifier:_cellIdentifier];
            
        }else{
            
            UINib *templateCellNib = [UINib nibWithNibName:_cellIdentifier bundle:nil];
            [_tableView registerNib:templateCellNib forCellReuseIdentifier:_cellIdentifier];
        }
        
    }
    return self;
}
+ (instancetype)bindingHelperForTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand templateCell:(NSString *)templateCell  withViewModel:(id)viewModel
{
    NSDictionary *cellDic = @{@"cellType":@"codeType",@"cellName":templateCell};
    return [[HTTableViewBindingHelper alloc] initWithTableView:tableView
                                                  sourceSignal:source
                                              selectionCommand:didSelectionCommand
                                                  withCellType:cellDic
                                                 withViewModel:viewModel];
}
+ (instancetype)bindingHelperForTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)didSelectionCommand templateCellWithNib:(NSString *)templateCell withViewModel:(id)viewModel
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

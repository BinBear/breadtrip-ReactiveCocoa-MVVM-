//
//  HTTableViewBindingHelper.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/16.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTViewModel;

@interface HTTableViewBindingHelper : NSObject

@property (weak, nonatomic) id<UITableViewDelegate> delegate;


/**
 代码创建cell时调用

 @param tableView tableview
 @param source 数据信号
 @param didSelectionCommand cell选中信号
 @param templateCell cell的类名
 @param viewModel viewModel
 @return 配置好的tableview
 */
+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)didSelectionCommand
                              templateCell:(NSString *)templateCell
                             withViewModel:(HTViewModel *)viewModel;
/**
 xib创建cell时调用
 
 @param tableView tableview
 @param source 数据信号
 @param didSelectionCommand cell选中信号
 @param templateCell Nib的类名
 @param viewModel viewModel
 @return 配置好的tableview
 */
+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)didSelectionCommand
                       templateCellWithNib:(NSString *)templateCell
                             withViewModel:(HTViewModel *)viewModel;

@end

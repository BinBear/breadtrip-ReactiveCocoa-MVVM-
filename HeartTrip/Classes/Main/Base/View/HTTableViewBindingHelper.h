//
//  HTTableViewBindingHelper.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/16.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTableViewBindingHelper : NSObject

@property (weak, nonatomic) id<UITableViewDelegate> delegate;

- (instancetype) initWithTableView:(UITableView *)tableView
                      sourceSignal:(RACSignal *)source
                  selectionCommand:(RACCommand *)didSelectionCommand
                      templateCell:(NSString *)templateCell;

+ (instancetype) bindingHelperForTableView:(UITableView *)tableView
                              sourceSignal:(RACSignal *)source
                          selectionCommand:(RACCommand *)didSelectionCommand
                              templateCell:(NSString *)templateCell;

@end

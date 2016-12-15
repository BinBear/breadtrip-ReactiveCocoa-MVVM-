//
//  HTReactiveView.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/16.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTReactiveView <NSObject>

/**
 绑定一个viewmodel给view

 @param viewModel Viewmodel
 */
- (void)bindViewModel:(id)viewModel;

@end

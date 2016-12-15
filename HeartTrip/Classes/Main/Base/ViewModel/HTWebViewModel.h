//
//  HTWebViewModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/12/13.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTViewModelService.h"

@interface HTWebViewModel : NSObject

/**
 *  请求地址
 */
@property (copy, nonatomic) NSString *requestURL;
/**
 *  标题
 */
@property (copy, nonatomic) NSString *title;

- (instancetype)initWithServices:(id<HTViewModelService>)services params:(NSDictionary *)params;

@end

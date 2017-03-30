//
//  HTWebViewModel.m
//  HeartTrip
//
//  Created by 熊彬 on 16/12/13.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTWebViewModel.h"

@interface HTWebViewModel ()

@end

@implementation HTWebViewModel

- (instancetype)initWithServices:(id<HTViewModelService>)services params:(NSDictionary *)params
{
    if (self = [super initWithServices:services params:params]) {
        
        _requestURL = params[RequestURLkey];
        _webType = [params[WebViewTypekey] unsignedIntegerValue];
    }
    return self;
}
@end

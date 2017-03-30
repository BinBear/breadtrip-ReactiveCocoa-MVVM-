//
//  HTWebViewModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/12/13.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTViewModel.h"

typedef NS_ENUM(NSUInteger, HTWebType) {
    
    kWebCityBannerDetailType   = 1, // 首页banner详情
    kWebFindDetailType         = 2, // 发现详情
    
};

@interface HTWebViewModel : HTViewModel

/**
 *  请求地址
 */
@property (copy, nonatomic) NSString *requestURL;
/**
 *  web页面类型
 */
@property (assign , nonatomic) HTWebType webType;

- (instancetype)initWithServices:(id<HTViewModelService>)services params:(NSDictionary *)params;

@end

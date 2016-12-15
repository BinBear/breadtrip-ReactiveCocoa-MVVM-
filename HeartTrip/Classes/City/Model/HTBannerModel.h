//
//  HTBannerModel.h
//  HeartTrip
//
//  Created by 熊彬 on 16/11/21.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTBannerModel : NSObject
/**
 *  banner跳转地址
 */
@property (copy, nonatomic) NSString *html_url;
/**
 *  banner图地址
 */
@property (copy, nonatomic) NSString *image_url;
@end

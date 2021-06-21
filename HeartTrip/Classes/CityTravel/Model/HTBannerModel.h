//
//  HTBannerModel.h
//  HeartTrip
//
//  Created by vin on 2021/5/20.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTBannerModel : HTBaseModel
/// banner跳转地址
@property (copy,  nonatomic) NSString *html_url;
/// banner图地址
@property (copy,  nonatomic) NSString *image_url;
@end

NS_ASSUME_NONNULL_END

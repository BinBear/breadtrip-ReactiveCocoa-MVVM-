//
//  UIImageView+HTRoundImage.m
//  HeartTrip
//
//  Created by 熊彬 on 16/10/9.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "UIImageView+HTRoundImage.h"



@implementation UIImageView (HTRoundImage)
- (void)HT_setImageWithCornerRadius:(CGFloat)radius imageURL:(NSURL *)imageURL placeholder:(NSString *)placeholder size:(CGSize)size
{
    [self HT_setImageWithHTRadius:HTRadiusMake(radius, radius, radius, radius) imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:UIViewContentModeScaleAspectFill size:size];
}
- (void)HT_setImageWithCornerRadius:(CGFloat)radius imageURL:(NSURL *)imageURL placeholder:(NSString *)placeholder contentMode:(UIViewContentMode)contentMode size:(CGSize)size
{
    [self HT_setImageWithHTRadius:HTRadiusMake(radius, radius, radius, radius) imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:contentMode size:size];
}
- (void)HT_setImageWithHTRadius:(HTRadius)radius imageURL:(NSURL *)imageURL placeholder:(NSString *)placeholder contentMode:(UIViewContentMode)contentMode size:(CGSize)size
{
     [self HT_setImageWithHTRadius:radius imageURL:imageURL placeholder:placeholder borderColor:nil borderWidth:0 backgroundColor:nil contentMode:contentMode size:size];
}
-(void)HT_setImageWithHTRadius:(HTRadius)radius imageURL:(NSURL *)imageURL placeholder:(NSString *)placeholder borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth backgroundColor:(UIColor *)backgroundColor contentMode:(UIViewContentMode)contentMode size:(CGSize)size
{
    NSString *cacheurlStr = [NSString stringWithFormat:@"%@%@",imageURL,@"radiusCache"];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cacheurlStr];
    
    if (cacheImage) {
        self.image =  [UIImage HT_setHTRadius:radius image:cacheImage size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
        return;

    }

    UIImage *placeholderImage;
    if (placeholder || borderWidth > 0 || backgroundColor) {
        NSString *placeholderKey = [NSString stringWithFormat:@"%@-%@", placeholder, placeholder];
        placeholderImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:placeholderKey];
        
        if (!placeholderImage) {
            placeholderImage = [UIImage HT_setHTRadius:radius image:[UIImage imageNamed:placeholder] size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
            [[SDImageCache sharedImageCache] storeImage:placeholderImage forKey:placeholderKey completion:nil];
            
        }else{
            
            placeholderImage = [UIImage HT_setHTRadius:radius image:placeholderImage size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
        }
        
    }
    self.image = placeholderImage;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
   
    [manager loadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        // 处理下载进度
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            UIImage *currentImage = [UIImage HT_setHTRadius:radius image:image size:size borderColor:borderColor borderWidth:borderWidth backgroundColor:backgroundColor withContentMode:contentMode];
            self.image = currentImage;
            [[SDImageCache sharedImageCache] storeImage:currentImage forKey:cacheurlStr toDisk:YES completion:nil];
            //清除原有非圆角图片缓存
            [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@",imageURL] withCompletion:nil];
        }
    }];

}
@end

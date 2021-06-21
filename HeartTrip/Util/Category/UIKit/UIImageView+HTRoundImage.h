//
//  UIImageView+HTRoundImage.h
//  HeartTrip
//
//  Created by 熊彬 on 16/10/9.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+HTRoundImage.h"

@interface UIImageView (HTRoundImage)

- (void)HT_setImageWithCornerRadius:(CGFloat)radius
                           imageURL:(NSURL *)imageURL
                        placeholder:(NSString *)placeholder
                               size:(CGSize)size;

- (void)HT_setImageWithCornerRadius:(CGFloat)radius
                           imageURL:(NSURL *)imageURL
                        placeholder:(NSString *)placeholder
                        contentMode:(UIViewContentMode)contentMode
                               size:(CGSize)size;

- (void)HT_setImageWithHTRadius:(HTRadius)radius
                       imageURL:(NSURL *)imageURL
                    placeholder:(NSString *)placeholder
                    contentMode:(UIViewContentMode)contentMode
                           size:(CGSize)size;

- (void)HT_setImageWithHTRadius:(HTRadius)radius
                       imageURL:(NSURL *)imageURL
                    placeholder:(NSString *)placeholder
                    borderColor:(UIColor *)borderColor
                    borderWidth:(CGFloat)borderWidth
                backgroundColor:(UIColor *)backgroundColor
                    contentMode:(UIViewContentMode)contentMode
                           size:(CGSize)size;
@end

//
//  UIBarButtonItem+HTBarButtonCustom.h
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HTBarButtonCustom)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image selectImage:(NSString *)selectImage;

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title;

@end

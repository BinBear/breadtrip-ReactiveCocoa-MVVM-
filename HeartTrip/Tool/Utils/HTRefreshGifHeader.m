//
//  HTRefreshGifHeader.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/24.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTRefreshGifHeader.h"

@implementation HTRefreshGifHeader

#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=12; i++) {
        NSString *imageName = [NSString stringWithFormat:@"refresh%ld.png", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [HTUtilsMethod imageByScalingToSize:CGSizeMake(40, 40) andSourceImage:image];
        [idleImages addObject:newImage];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=12; i++) {
        NSString *imageName = [NSString stringWithFormat:@"refresh%ld.png", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [HTUtilsMethod imageByScalingToSize:CGSizeMake(40, 40) andSourceImage:image];
        [refreshingImages addObject:newImage];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    NSMutableArray *startImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<= 12; i++) {
        NSString *imageName = [NSString stringWithFormat:@"refresh%ld.png", i];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *newImage = [HTUtilsMethod imageByScalingToSize:CGSizeMake(40, 40) andSourceImage:image];
        [startImages addObject:newImage];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:startImages forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    self.stateLabel.hidden = YES;
}

@end

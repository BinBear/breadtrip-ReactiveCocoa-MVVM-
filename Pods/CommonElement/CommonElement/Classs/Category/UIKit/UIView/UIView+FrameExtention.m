//
//  UIView+FrameExtention.m
//  futongdai
//
//  Created by 熊彬 on 16/4/8.
//  Copyright © 2016年 OFIM. All rights reserved.
//

#import "UIView+FrameExtention.h"

@implementation UIView (FrameExtention)
- (void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)midX{
    return CGRectGetMidX(self.frame);
}

- (CGFloat)midY{
    return CGRectGetMidY(self.frame);
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}


@end

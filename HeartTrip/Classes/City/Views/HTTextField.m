//
//  HTTextField.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/28.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTTextField.h"

@implementation HTTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.placeholder = @"搜索内容、地点、用户";
        [self setBackgroundColor:SetColor(65, 170, 184)];
        self.layer.cornerRadius = 14.0f;
        self.layer.borderColor = SetColor(65, 170, 184).CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.font = HTSetFont(@"DamascusLight", 13);
        self.textColor = [UIColor whiteColor];
        [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return self;
}
/**
 *  修改文本展示区域
 *
 */
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y+3, bounds.size.width-20, bounds.size.height);
    return inset;
}

/**
 *  重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
 *
 */
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y+3, bounds.size.width-20, bounds.size.height);
    return inset;
}
@end

//
//  HTSearchBar.m
//  HeartTrip
//
//  Created by 熊彬 on 16/11/28.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTSearchBar.h"

@implementation HTSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundImage = [[UIImage alloc] init];
        self.barTintColor = [UIColor whiteColor];
        UITextField *searchField = [self valueForKey:@"searchField"];
        if (searchField) {
            searchField.placeholder = @"搜索内容、地点、用户";
            [searchField setBackgroundColor:SetColor(65, 170, 184)];
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.borderColor = SetColor(65, 170, 184).CGColor;
            searchField.layer.borderWidth = 1;
            searchField.layer.masksToBounds = YES;
            [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
    }
    return self;
}

@end

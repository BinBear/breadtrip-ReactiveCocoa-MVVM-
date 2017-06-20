//
//  HTAlertShowView.m
//  HeartTrip
//
//  Created by 熊彬 on 2017/6/5.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTAlertShowView.h"

@interface HTAlertShowView ()<UIAlertViewDelegate>


@property (copy, nonatomic) void (^clickedBlock)(HTAlertShowView *, BOOL, NSInteger);

@end

@implementation HTAlertShowView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
       clickedBlock:(void (^)(HTAlertShowView *alertView, BOOL cancelled, NSInteger buttonIndex))clickedBlock
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    if (self) {
        _clickedBlock = clickedBlock;
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _clickedBlock(self, buttonIndex==self.cancelButtonIndex, buttonIndex);
}

@end

//
//  HTAlertShowView.h
//  HeartTrip
//
//  Created by 熊彬 on 2017/6/5.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTAlertShowView : UIAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
       clickedBlock:(void (^)(HTAlertShowView *alertView, BOOL cancelled, NSInteger buttonIndex))clickedBlock
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

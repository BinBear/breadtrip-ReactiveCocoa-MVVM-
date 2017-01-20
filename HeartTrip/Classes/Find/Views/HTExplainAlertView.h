//
//  HTExplainAlertView.h
//  HeartTrip
//
//  Created by 熊彬 on 17/1/19.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTExplainAlertView : UIView

+ (instancetype)sharedAlertManager;

- (void)showExplainAlertView;
- (void)dismissAlertView;

@end

//
//  HTAlertShowView.h
//  HeartTrip
//
//  Created by 熊彬 on 2017/6/5.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTAlertShowView : UIView
/**
 *  获得一个CheckManager对象
 */
+ (instancetype)sharedAlertManager;

/**
 *  显示提示View
 */
-(void)showHTAlertView;
/**
 *  隐藏提示View
 */
-(void)dismissAlertView;
@end

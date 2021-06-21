//
//  main.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/9.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([HTAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

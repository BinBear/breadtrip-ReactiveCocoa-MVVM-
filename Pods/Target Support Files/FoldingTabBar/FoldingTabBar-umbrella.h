#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "YALSpringAnimation.h"
#import "CAAnimation+YALTabBarViewAnimations.h"
#import "CATransaction+TransactionWithAnimationsAndCompletion.h"
#import "UIView+Insets.h"
#import "YALAnimatingTabBarConstants.h"
#import "YALFoldingTabBarController.h"
#import "YALTabBarItem.h"
#import "FoldingTabBar.h"
#import "YALCustomHeightTabBar.h"
#import "YALFoldingTabBar.h"

FOUNDATION_EXPORT double FoldingTabBarVersionNumber;
FOUNDATION_EXPORT const unsigned char FoldingTabBarVersionString[];


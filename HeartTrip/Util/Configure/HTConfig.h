//
//  HTConfig.h
//  HeartTrip
//
//  Created by 熊彬 on 16/9/13.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#ifndef HTConfig_h
#define HTConfig_h

// APPDelegate
#define HT_APPDelegate  ((HTAppDelegate*)[UIApplication sharedApplication].delegate)

// 懒加载
#define HT_LAZY(object, assignment) (object = object ?: assignment)

// Log相关
#ifndef __OPTIMIZE__
#define NSLog(...) {}
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
#define NSLog(...) {}
static const DDLogLevel ddLogLevel = DDLogLevelOff;
#endif

// 字体 Medium
#define textFontPingFangMediumFont(fontsize)  [UIFont fontWithName:@"PingFang-SC-Medium" size:(fontsize)]
// 字体 Regular
#define textFontPingFangRegularFont(fontsize)  [UIFont fontWithName:@"PingFang-SC-Regular" size:(fontsize)]
// 字体 Helvetica-Light
#define textFontHelveticaLightFont(fontsize)  [UIFont fontWithName:@"HelveticaNeue-Light" size:(fontsize)]
// 字体 Helvetica
#define textFontHelveticaMediumFont(fontsize)  [UIFont fontWithName:@"HelveticaNeue" size:(fontsize)]
// 设置字体
#define HTSetFont(fontName,font)    [UIFont fontWithName:(fontName) size:(font)]

#define adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)



// 全面屏的安全区域相关
#define kSafeAreaTop        kWindowSafeAreaInset.top
#define kSafeAreaBottom     kWindowSafeAreaInset.bottom

#define kIsFullScreen \
({BOOL isFullScreen = NO;\
if (@available(iOS 11.0, *)) {\
isFullScreen = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isFullScreen);})

#define kWindowSafeAreaInset \
({\
UIEdgeInsets returnInsets = UIEdgeInsetsMake(20, 0, 0, 0);\
UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;\
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")] && kIsFullScreen) {\
UIEdgeInsets inset = [[keyWindow valueForKeyPath:@"safeAreaInsets"] UIEdgeInsetsValue];\
returnInsets = inset;\
}\
_Pragma("clang diagnostic pop") \
(returnInsets);\
})\

// keyWindow
#define keywindow          [UIApplication sharedApplication].keyWindow

// TODO的宏,使用方法： @TODO("模块尚未完成")
#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" \
DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)
#define KEYWORDIFY try {} @catch (...) {}
#define TODO(MSG) KEYWORDIFY PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))


#endif /* HTConfig_h */

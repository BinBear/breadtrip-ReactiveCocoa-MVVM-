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

#import "MMBuffer.h"
#import "MMKV.h"
#import "MMKVLog.h"
#import "MMKVPredef.h"
#import "PBUtility.h"
#import "ScopedLock.hpp"
#import "ThreadLock.h"
#import "openssl_md5.h"
#import "openssl_opensslconf.h"

FOUNDATION_EXPORT double MMKVCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char MMKVCoreVersionString[];


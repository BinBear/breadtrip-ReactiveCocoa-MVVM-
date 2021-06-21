//
//  RACCommand+HTRoute.h
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "RACSignal+HTRoute.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACCommand (HTRoute)

@end

/// Push enabled Command
CG_INLINE RACCommand *
ht_pushEnabledCommand(RACSignal *_Nullable enabledSignal,
                      NSString *_Nullable controllerName,
                      NSString *_Nullable viewModelName,
                      id _Nullable params,
                      BOOL animated) {
    return ht_commandWithEnabledSignal(enabledSignal, ^RACSignal * _Nonnull(id  _Nonnull input) {
        return ht_pushSignal(controllerName, viewModelName, params, animated);
    });
}

/// Present enabled Command
CG_INLINE RACCommand *
ht_presentEnabledCommand(RACSignal *_Nullable enabledSignal,
                         NSString *_Nullable controllerName,
                         NSString *_Nullable viewModelName,
                         id _Nullable params,
                         Class _Nullable nav,
                         BOOL animated) {
    return ht_commandWithEnabledSignal(enabledSignal, ^RACSignal * _Nonnull(id  _Nonnull input) {
        return ht_presentSignal(controllerName, viewModelName, params, nav, animated);
    });
}

/// Pop enabled Command
CG_INLINE RACCommand *
ht_popEnabledCommand(RACSignal *_Nullable enabledSignal,
                     NSString *_Nullable controllerName,
                     id _Nullable params,
                     BOOL animated) {
    return ht_commandWithEnabledSignal(enabledSignal, ^RACSignal * _Nonnull(id  _Nonnull input) {
        return ht_popSignal(controllerName, params, animated);
    });
}

/// Dismiss enabled Command
CG_INLINE RACCommand *
ht_dismissEnabledCommand(RACSignal *_Nullable enabledSignal,
                         id _Nullable params,
                         BOOL animated) {
    return ht_commandWithEnabledSignal(enabledSignal, ^RACSignal * _Nonnull(id  _Nonnull input) {
        return ht_dismissSignal(params, animated);
    });
}

NS_ASSUME_NONNULL_END

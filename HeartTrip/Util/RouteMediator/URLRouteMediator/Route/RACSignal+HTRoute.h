//
//  RACSignal+HTRoute.h
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "NSObject+HTRouteProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (HTRoute)

@end

/// Push Signal
CG_INLINE RACSignal *
ht_pushSignal(NSString *_Nullable controllerName,
              NSString *_Nullable viewModelName,
              id _Nullable params,
              BOOL animated){
    return ht_signalWithAction(^{
        [RACSignal pushViewControllerWithName:controllerName
                                viewModelName:viewModelName
                                    parameter:params
                                     animated:animated];
    });
}

/// Present Signal
CG_INLINE RACSignal *
ht_presentSignal(NSString *_Nullable controllerName,
                 NSString *_Nullable viewModelName,
                 id _Nullable params,
                 Class _Nullable nav,
                 BOOL animated) {
    return ht_signalWithAction(^{
        [RACSignal presentViewControllerWithName:controllerName
                                   viewModelName:viewModelName
                                       parameter:params
                                   navController:nav
                                        animated:animated];
    });
}

/// Pop Signal
CG_INLINE RACSignal *
ht_popSignal(NSString *_Nullable controllerName,
             id _Nullable params,
             BOOL animated) {
    return ht_signalWithAction(^{
        [RACSignal popViewControllerWithName:controllerName
                                   parameter:params
                                    animated:animated];
    });
}

/// Dismiss Signal
CG_INLINE RACSignal *
ht_dismissSignal(id _Nullable params,
                 BOOL animated) {
    return ht_signalWithAction(^{
        [RACSignal dismissViewControllerWithParameter:params
                                             animated:animated
                                           completion:nil];
    });
}


NS_ASSUME_NONNULL_END

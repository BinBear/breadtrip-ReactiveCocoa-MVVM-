//
//  HTBaseViewController.h
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTBaseViewModel.h"
#import "HTViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTBaseViewController<__covariant viewModelType: HTBaseViewModel *> : UIViewController<HTViewControllerProtocol>

/// viewModel
@property (nonatomic,strong,readonly) viewModelType viewModel;

@end

NS_ASSUME_NONNULL_END

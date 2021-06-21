//
//  HTFindViewModel.h
//  HeartTrip
//
//  Created by vin on 2021/4/18.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import "HTBaseViewModel.h"
#import "HTFindFeedModel.h"
#import "HTFindVideosModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTFindViewModel : HTBaseViewModel

/// feed
@property (strong, nonatomic) NSMutableArray *feedData;
/// video
@property (strong, nonatomic) NSMutableArray *videoData;

/// 列表
@property (strong, nonatomic) RACCommand *listCommand;
@end

NS_ASSUME_NONNULL_END

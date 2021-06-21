//
//  HTActionTipsView.h
//  HeartTrip
//
//  Created by vin on 2021/2/22.
//  Copyright © 2021 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HTActionTipViewConfigure, HTActionTipViewBtnConfigure;

typedef void(^actionBtnAction)(void);
typedef void(^actionTapAction)(void);

typedef HTActionTipViewConfigure *(^actionConfigBlock)(id value);
typedef HTActionTipViewConfigure *(^configTapActionBlock)(actionTapAction action);

typedef HTActionTipViewBtnConfigure *(^actionBtnConfigBlock)(id value);
typedef HTActionTipViewBtnConfigure *(^actionBtnCallbackConfigBlock)(actionBtnAction action);
typedef void (^actionTipViewConfigBlock)(HTActionTipViewConfigure *configure);


@interface HTActionTipViewBtnConfigure: NSObject
- (id)getBtnTitle;
- (actionBtnAction)getBtnCallback;

- (actionBtnConfigBlock)btnTitle;
- (actionBtnCallbackConfigBlock)btnCallback;
+ (instancetype)btnConfigure;

@end


@interface HTActionTipViewConfigure : NSObject

- (id)getTitle;
- (id)getSubTitle;
- (configTapActionBlock)tapCallback;
- (NSMutableArray<HTActionTipViewBtnConfigure *> *)getBtnsConfig;

- (actionConfigBlock)title;         // 标题
- (actionConfigBlock)subTitle;     // 信息内容
- (actionConfigBlock)btnsConfig;

@end

@interface HTActionTipsView : NSObject

+ (void)showWithConfigure:(actionTipViewConfigBlock)configure;
+ (RACSignal *)signalWithConfigure:(actionTipViewConfigBlock)configure;
+ (RACCommand *)commandWithConfigure:(actionTipViewConfigBlock)configure;

@end



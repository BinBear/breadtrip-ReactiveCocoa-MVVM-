//
//  HTHUD+EmptyView.h
//  HotCoin
//
//  Created by vin on 2020/11/9.
//  Copyright © 2020 com.hotcoin.www. All rights reserved.
//

#import "HTHUD.h"

NS_ASSUME_NONNULL_BEGIN

@class HTHUDConfigure,HTHUDConfigureItem,HTHUD;

typedef NS_ENUM(NSUInteger, HTHUDPosition) {
    HTHUDPosition_Center = 0,        // 中间布局
    HTHUDPosition_Top,              // 顶部布局
};

/// 配置的Block
typedef HTHUDConfigure *_Nullable(^instancetypeBlock)(id value);
typedef HTHUDConfigure *_Nullable(^instancetypeContentBlock)(HTHUDConfigureItem *item);
typedef void(^configureItemBlock)(void);
/// 提供外部配置Block
typedef void(^configureBlock)(HTHUDConfigure *configure);

/*********  配置类  ***********/
@interface HTHUDConfigure : NSObject

/// 内容
- (instancetypeBlock)contentView;
/// 背景图片
- (instancetypeBlock)backgroundImage;
/// 占位图
- (instancetypeBlock)image;
/// 占位图
- (instancetypeBlock)imageJsonName;
/// 标题
- (instancetypeBlock)title;
/// 副标题
- (instancetypeBlock)subTitle;

/// 第一个item
- (instancetypeContentBlock)oneItem;
/// 第二个item
- (instancetypeContentBlock)twoItem;

/// 内容的frame
- (instancetypeBlock)contentFrame;
/// 占位类型
- (instancetypeBlock)emptyType;
/// 占位布局类型
- (instancetypeBlock)position;
/// 偏移量
- (instancetypeBlock)contentOffset;

@end

/*********  配置选项内容  ***********/
@interface HTHUDConfigureItem : NSObject

/// 标题
@property (copy,   nonatomic) NSString *title;
/// 图片
@property (strong, nonatomic) UIImage *btnImg;
/// 背景图片
@property (strong, nonatomic) UIImage *btnBgImg;
/// 确认信号
@property (copy,   nonatomic) configureItemBlock confirmSignal;


@end



@interface HTHUD (EmptyView)


/// 初始化缺省View
/// @param view 缺省view
/// @param configure 配置属性
+ (void)showEmptyViewToView:(UIView *)view
                  configure:(configureBlock)configure;


/// 移除缺省View
/// @param view 缺省View
+ (void)dismissEmptyViewForView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END

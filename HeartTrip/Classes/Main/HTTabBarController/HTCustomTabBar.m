//
//  HTCustomTabBar.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTCustomTabBar.h"
#import "HTCustomTabBarController.h"
#import "HTCustomTabBarButton.h"

static void *const HTCustomTabBarContext = (void*)&HTCustomTabBarContext;


@interface HTCustomTabBar ()
/**
 *  自定义按钮
 */
@property (nonatomic, strong) UIButton<HTCustomTabBarButtonDelegate> *customButton;
/**
 *  tabBarItem宽度
 */
@property (nonatomic, assign) CGFloat tabBarItemWidth;
/**
 *  tabBar上button的数目
 */
@property (nonatomic, copy) NSArray *tabBarButtonArray;
@end

@implementation HTCustomTabBar

#pragma mark -
#pragma mark - LifeCycle Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)sharedInit {
    if (HTExternCustomButton) {
        self.customButton = HTExternCustomButton;
        [self addSubview:(UIButton *)self.customButton];
    }
    // KVO注册监听
    _tabBarItemWidth = HTTabBarItemWidth;
    [self addObserver:self forKeyPath:@"tabBarItemWidth" options:NSKeyValueObservingOptionNew context:HTCustomTabBarContext];
    return self;
}

- (NSArray *)tabBarButtonArray {
    if (!_tabBarButtonArray) {
        NSArray *tabBarButtonArray = [[NSArray alloc] init];
        _tabBarButtonArray = tabBarButtonArray;
    }
    return _tabBarButtonArray;
}
- (void)dealloc {
    // 移除监听
    [self removeObserver:self forKeyPath:@"tabBarItemWidth"];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat barWidth = self.bounds.size.width;
    CGFloat barHeight = self.bounds.size.height;
    HTTabBarItemWidth = (barWidth - HTCustomButtonWidth) / HTTabbarItemsCount;
    self.tabBarItemWidth = HTTabBarItemWidth;
    if (!HTExternCustomButton) {
        return;
    }
    
    CGFloat multiplerInCenterY = [self multiplerInCenterY];
    self.customButton.center = CGPointMake(barWidth * 0.5, barHeight * multiplerInCenterY);
    NSUInteger customButtonIndex = [self customButtonIndex];
    NSArray *sortedSubviews = [self sortedSubviews];
    self.tabBarButtonArray = [self tabBarButtonFromTabBarSubviews:sortedSubviews];
    [self setupSwappableImageViewDefaultOffset:self.tabBarButtonArray[0]];
    [self.tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
        //调整UITabBarItem的位置
        CGFloat childViewX;
        if (buttonIndex >= customButtonIndex) {
            childViewX = buttonIndex * HTTabBarItemWidth + HTCustomButtonWidth;
        } else {
            childViewX = buttonIndex * HTTabBarItemWidth;
        }
        //仅修改childView的x和宽度,yh值不变
        childView.frame = CGRectMake(childViewX,
                                     CGRectGetMinY(childView.frame),
                                     HTTabBarItemWidth,
                                     CGRectGetHeight(childView.frame)
                                     );
    }];
    //让按钮移动到视图最顶端
    [self bringSubviewToFront:self.customButton];
}
- (void)setSwappableImageViewDefaultOffset:(CGFloat)swappableImageViewDefaultOffset {
    if (swappableImageViewDefaultOffset != 0.f) {
        [self willChangeValueForKey:@"swappableImageViewDefaultOffset"];
        _swappableImageViewDefaultOffset = swappableImageViewDefaultOffset;
        [self didChangeValueForKey:@"swappableImageViewDefaultOffset"];
    }
}
#pragma mark -
#pragma mark - KVO Method
// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != HTCustomTabBarContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == HTCustomTabBarContext) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HTTabBarItemWidthDidChangeNotification object:self];
    }
}
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return NO;
}
- (void)setTabBarItemWidth:(CGFloat )tabBarItemWidth {
    if (_tabBarItemWidth != tabBarItemWidth) {
        [self willChangeValueForKey:@"tabBarItemWidth"];
        _tabBarItemWidth = tabBarItemWidth;
        [self didChangeValueForKey:@"tabBarItemWidth"];
    }
}

#pragma mark -
#pragma mark - Private Methods
/**
 *  调整中间按钮位置
 *
 */
- (CGFloat)multiplerInCenterY
{
    CGFloat multiplerInCenterY;
    if ([[self.customButton class] respondsToSelector:@selector(multiplerInCenterY)]) {
        multiplerInCenterY = [[self.customButton class] multiplerInCenterY];
    } else {
        CGSize sizeOfPustomButton = self.customButton.frame.size;
        CGFloat heightDifference = sizeOfPustomButton.height - self.bounds.size.height;
        if (heightDifference < 0) {
            multiplerInCenterY = 0.5;
        } else {
            CGPoint center = CGPointMake(self.bounds.size.height * 0.5, self.bounds.size.height * 0.5);
            center.y = center.y - heightDifference * 0.5;
            multiplerInCenterY = center.y / self.bounds.size.height;
        }
    }
    return multiplerInCenterY;
}
/**
 *  获得自定义按钮的下标
 *
 *  @return
 */
- (NSUInteger)customButtonIndex
{
    NSUInteger customButtonIndex;
    if ([[self.customButton class] respondsToSelector:@selector(indexOfCustomButtonInTabBar)]) {
        customButtonIndex = [[self.customButton class] indexOfCustomButtonInTabBar];
        //仅修改self.customButton的x,ywh值不变
        self.customButton.frame = CGRectMake(customButtonIndex * HTTabBarItemWidth,
                                             CGRectGetMinY(self.customButton.frame),
                                             CGRectGetWidth(self.customButton.frame),
                                             CGRectGetHeight(self.customButton.frame)
                                             );
    } else {
        if (HTTabbarItemsCount % 2 != 0) {
            [NSException raise:@"HTCustomTabBarController" format:@"如果HTCustomTabBarController的个数奇数，必须在自定义的customButton中实现`+indexOfCustomButtonInTabBar`，来指定customButton的位置"];
        }
        customButtonIndex = HTTabbarItemsCount * 0.5;
    }
    HTCustomButtonIndex = customButtonIndex;
    return customButtonIndex;
}
/**
 *  调整子视图的位置
 *
 *  @return
 */
- (NSArray *)sortedSubviews {
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * view1, UIView * view2) {
        CGFloat view1_x = view1.frame.origin.x;
        CGFloat view2_x = view2.frame.origin.x;
        if (view1_x > view2_x) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    return sortedSubviews;
}
/**
 *  获得tabbar的子视图数组
 *
 */
- (NSArray *)tabBarButtonFromTabBarSubviews:(NSArray *)tabBarSubviews
{
    NSArray *tabBarButtonArray = [NSArray array];
    NSMutableArray *tabBarButtonMutableArray = [NSMutableArray arrayWithCapacity:tabBarSubviews.count - 1];
    [tabBarSubviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtonMutableArray addObject:obj];
        }
    }];
    if (HTCustomChildViewController) {
        [tabBarButtonMutableArray removeObjectAtIndex:HTCustomButtonIndex];
    }
    tabBarButtonArray = [tabBarButtonMutableArray copy];
    return tabBarButtonArray;
}
- (void)setupSwappableImageViewDefaultOffset:(UIView *)tabBarButton {
    __block BOOL shouldCustomizeImageView = YES;
    __block CGFloat swappableImageViewHeight = 0.f;
    __block CGFloat swappableImageViewDefaultOffset = 0.f;
    CGFloat tabBarHeight = self.frame.size.height;
    [tabBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) {
            shouldCustomizeImageView = NO;
        }
        swappableImageViewHeight = obj.frame.size.height;
        BOOL isSwappableImageView = [obj isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")];
        if (isSwappableImageView) {
            swappableImageViewDefaultOffset = (tabBarHeight - swappableImageViewHeight) * 0.5 * 0.5;
        }
        if (isSwappableImageView && swappableImageViewDefaultOffset == 0.f) {
            shouldCustomizeImageView = NO;
        }
        
    }];
    if (shouldCustomizeImageView) {
        self.swappableImageViewDefaultOffset = swappableImageViewDefaultOffset;
    }
}
/**
 *  该方法可以让按钮超出父视图的部分也可以点击
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    BOOL canNotResponseEvent = self.hidden || (self.alpha <= 0.01f) || (self.userInteractionEnabled == NO);
    if (canNotResponseEvent) {
        return nil;
    }
    if (!HTExternCustomButton && ![self pointInside:point withEvent:event]) {
        return nil;
    }
    if (HTExternCustomButton) {
        CGRect plusButtonFrame = self.customButton.frame;
        BOOL isInPlusButtonFrame = CGRectContainsPoint(plusButtonFrame, point);
        if (!isInPlusButtonFrame && (point.y < 0) ) {
            return nil;
        }
        if (isInPlusButtonFrame) {
            return HTExternCustomButton;
        }
    }
    NSArray *tabBarButtons = self.tabBarButtonArray;
    if (self.tabBarButtonArray.count == 0) {
        tabBarButtons = [self tabBarButtonFromTabBarSubviews:self.subviews];
    }
    for (NSUInteger index = 0; index < tabBarButtons.count; index++) {
        UIView *selectedTabBarButton = tabBarButtons[index];
        CGRect selectedTabBarButtonFrame = selectedTabBarButton.frame;
        if (CGRectContainsPoint(selectedTabBarButtonFrame, point)) {
            return selectedTabBarButton;
        }
    }
    return nil;
}

@end

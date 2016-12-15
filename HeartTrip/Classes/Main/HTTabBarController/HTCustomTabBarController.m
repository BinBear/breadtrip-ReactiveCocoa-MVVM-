//
//  HTCustomTabBarController.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/18.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTCustomTabBarController.h"
#import "HTCustomTabBar.h"
#import "HTCustomTabBarButton.h"
#import <objc/runtime.h>

NSString *const HTTabBarItemTitle = @"HTTabBarItemTitle";
NSString *const HTTabBarItemImage = @"HTTabBarItemImage";
NSString *const HTTabBarItemSelectedImage = @"HTTabBarItemSelectedImage";

NSUInteger HTTabbarItemsCount = 0;
NSUInteger HTCustomButtonIndex = 0;
CGFloat HTTabBarItemWidth = 0.0f;
NSString *const HTTabBarItemWidthDidChangeNotification = @"HTTabBarItemWidthDidChangeNotification";
static void * const HTSwappableImageViewDefaultOffsetContext = (void*)&HTSwappableImageViewDefaultOffsetContext;

#pragma mark - NSObject+HTTabBarControllerItem

@interface NSObject (HTTabBarControllerItemInternal)

- (void)HT_setTabBarController:(HTCustomTabBarController *)tabBarController;

@end
@implementation NSObject (HTTabBarControllerItemInternal)

- (void)HT_setTabBarController:(HTCustomTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(HT_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}
@end

@implementation NSObject (HTCustomTabBarController)

- (HTCustomTabBarController *)HT_tabBarController {
    HTCustomTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(HT_tabBarController));
    if (!tabBarController ) {
        if ([self isKindOfClass:[UIViewController class]] && [(UIViewController *)self parentViewController]) {
            tabBarController = [[(UIViewController *)self parentViewController] HT_tabBarController];
        } else {
            id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
            UIWindow *window = delegate.window;
            if ([window.rootViewController isKindOfClass:[HTCustomTabBarController class]]) {
                tabBarController = (HTCustomTabBarController *)window.rootViewController;
            }
        }
    }
    return tabBarController;
}

@end

#pragma mark - HTCustomTabBarController
@interface HTCustomTabBarController ()<UITabBarControllerDelegate>

@end

@implementation HTCustomTabBarController

@synthesize viewControllers = _viewControllers;

#pragma mark -
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 处理tabBar，使用自定义 tabBar 添加自定义按钮
    [self setUpTabBar];
    [self.tabBar addObserver:self forKeyPath:@"swappableImageViewDefaultOffset" options:NSKeyValueObservingOptionNew context:HTSwappableImageViewDefaultOffsetContext];
    self.delegate = self;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!self.tabBarHeight) {
        return;
    }
    self.tabBar.frame = ({
        CGRect frame = self.tabBar.frame;
        CGFloat tabBarHeight = self.tabBarHeight;
        frame.size.height = tabBarHeight;
        frame.origin.y = self.view.frame.size.height - tabBarHeight;
        frame;
    });
}

- (void)dealloc {
    // 移除KVO
    [self.tabBar removeObserver:self forKeyPath:@"swappableImageViewDefaultOffset"];
}
#pragma mark -
#pragma mark - Private Methods

/**
 *  利用 KVC 把系统的 tabBar 类型改为自定义类型。
 */
- (void)setUpTabBar {
    [self setValue:[[HTCustomTabBar alloc] init] forKey:@"tabBar"];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        if ((!_tabBarItemsAttributes) || (_tabBarItemsAttributes.count != viewControllers.count)) {
            [NSException raise:@"HTCustomTabBarController" format:@"设置_tabBarItemsAttributes属性时，确保元素个数与控制器的个数相同，并在方法`-setViewControllers:`之前设置"];
        }
        
        if (HTCustomChildViewController) {
            NSMutableArray *viewControllersWithPlusButton = [NSMutableArray arrayWithArray:viewControllers];
            [viewControllersWithPlusButton insertObject:HTCustomChildViewController atIndex:HTCustomButtonIndex];
            _viewControllers = [viewControllersWithPlusButton copy];
        } else {
            _viewControllers = [viewControllers copy];
        }
        HTTabbarItemsCount = [viewControllers count];
        HTTabBarItemWidth = ([UIScreen mainScreen].bounds.size.width - HTCustomButtonWidth) / (HTTabbarItemsCount);
        NSUInteger idx = 0;
        for (UIViewController *viewController in _viewControllers) {
            NSString *title = nil;
            NSString *normalImageName = nil;
            NSString *selectedImageName = nil;
            if (viewController != HTCustomChildViewController) {
                title = _tabBarItemsAttributes[idx][HTTabBarItemTitle];
                normalImageName = _tabBarItemsAttributes[idx][HTTabBarItemImage];
                selectedImageName = _tabBarItemsAttributes[idx][HTTabBarItemSelectedImage];
            } else {
                idx--;
            }
            
            [self addOneChildViewController:viewController
                                  WithTitle:title
                            normalImageName:normalImageName
                          selectedImageName:selectedImageName];
            [viewController HT_setTabBarController:self];
            idx++;
        }
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController HT_setTabBarController:nil];
        }
        _viewControllers = nil;
    }
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param normalImageName   图片
 *  @param selectedImageName 选中图片
 */
- (void)addOneChildViewController:(UIViewController *)viewController
                        WithTitle:(NSString *)title
                  normalImageName:(NSString *)normalImageName
                selectedImageName:(NSString *)selectedImageName {
    
    viewController.tabBarItem.title = title;
    if (normalImageName) {
        UIImage *normalImage = [UIImage imageNamed:normalImageName];
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.image = normalImage;
    }
    if (selectedImageName) {
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.selectedImage = selectedImage;
    }
    if (self.shouldCustomizeImageInsets) {
        viewController.tabBarItem.imageInsets = self.imageInsets;
    }
    if (self.shouldCustomizeTitlePositionAdjustment) {
        viewController.tabBarItem.titlePositionAdjustment = self.titlePositionAdjustment;
    }
    [self addChildViewController:viewController];
}
- (BOOL)shouldCustomizeImageInsets {
    BOOL shouldCustomizeImageInsets = self.imageInsets.top != 0.f || self.imageInsets.left != 0.f || self.imageInsets.bottom != 0.f || self.imageInsets.right != 0.f;
    return shouldCustomizeImageInsets;
}

- (BOOL)shouldCustomizeTitlePositionAdjustment {
    BOOL shouldCustomizeTitlePositionAdjustment = self.titlePositionAdjustment.horizontal != 0.f || self.titlePositionAdjustment.vertical != 0.f;
    return shouldCustomizeTitlePositionAdjustment;
}

#pragma mark -
#pragma mark - public Methods

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes {
    if (self = [super init]) {
        _tabBarItemsAttributes = tabBarItemsAttributes;
        self.viewControllers = viewControllers;
    }
    return self;
}

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes {
    HTCustomTabBarController *tabBarController = [[HTCustomTabBarController alloc] initWithViewControllers:viewControllers tabBarItemsAttributes:tabBarItemsAttributes];
    
    return tabBarController;
}

+ (BOOL)haveCustomButton {
    if (HTExternCustomButton) {
        return YES;
    }
    return NO;
}

+ (NSUInteger)allItemsInTabBarCount {
    NSUInteger allItemsInTabBar = HTTabbarItemsCount;
    if ([HTCustomTabBarController haveCustomButton]) {
        allItemsInTabBar += 1;
    }
    return allItemsInTabBar;
}

- (id<UIApplicationDelegate>)appDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (UIWindow *)rootWindow {
    UIWindow *result = nil;
    
    do {
        if ([self.appDelegate respondsToSelector:@selector(window)]) {
            result = [self.appDelegate window];
        }
        
        if (result) {
            break;
        }
    } while (NO);
    
    return result;
}
#pragma mark -
#pragma mark - KVO Method

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != HTSwappableImageViewDefaultOffsetContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == HTSwappableImageViewDefaultOffsetContext) {
        CGFloat swappableImageViewDefaultOffset = [change[NSKeyValueChangeNewKey] floatValue];
        [self offsetTabBarSwappableImageViewToFit:swappableImageViewDefaultOffset];
    }
}

- (void)offsetTabBarSwappableImageViewToFit:(CGFloat)swappableImageViewDefaultOffset {
    if (self.shouldCustomizeImageInsets) {
        return;
    }
    NSArray<UITabBarItem *> *tabBarItems = [self HT_tabBarController].tabBar.items;
    [tabBarItems enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIEdgeInsets imageInset = UIEdgeInsetsMake(swappableImageViewDefaultOffset, 0, -swappableImageViewDefaultOffset, 0);
        obj.imageInsets = imageInset;
        if (!self.shouldCustomizeTitlePositionAdjustment) {
            obj.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
        }
    }];
}

#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController*)viewController
{
    NSUInteger selectedIndex = tabBarController.selectedIndex;
    UIButton *plusButton = HTExternCustomButton;
    if (HTCustomChildViewController) {
        if ((selectedIndex == HTCustomButtonIndex) && (viewController != HTCustomChildViewController)) {
            plusButton.selected = NO;
        }
    }
    return YES;
}

- (void)setSelectedIndex:(NSUInteger)index
{
    [super setSelectedIndex:index];
    
    [self setNoHighlightTabBar];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    
    [self setNoHighlightTabBar];
}
- (void)setNoHighlightTabBar
{
    NSArray * tabBarSubviews = [self.tabBar subviews];
    for(UIView *sub in tabBarSubviews)
    {
        for(UIView * insub in [sub subviews])
        {
            if(insub && [NSStringFromClass([insub class]) isEqualToString:@"UITabBarSelectionIndicatorView"])//选中图片对于的view
            {
                [insub removeFromSuperview];
                break;
            }
        }
    }
}

@end

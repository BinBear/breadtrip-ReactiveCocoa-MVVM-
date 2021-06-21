//
//  HTBaseViewModel.m
//  HeartTrip
//
//  Created by vin on 2021/5/26.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTBaseViewModel.h"
#import "HTViewControllerProtocol.h"
#import "NSObject+HTModelParser.h"

@interface HTBaseViewModel ()
@property (nonatomic,strong) id parameter;
@property (nonatomic,weak) UIViewController<HTViewControllerProtocol> *viewModelController;
@property (nonatomic,strong) NSMutableDictionary<NSString *, RACCommand *> *commandDict;
@property (nonatomic,strong) NSMutableDictionary<NSString *, RACSubject *> *refreshViewSignalDict;
@end

@implementation HTBaseViewModel

#pragma mark - HTViewModelProtocol
+ (instancetype)viewModelWithParameter:(NSDictionary *)parameter {
    HTBaseViewModel *viewModel = [[self alloc] init];
    viewModel.parameter = parameter;
    [viewModel ht_modelSetWithJSON:parameter];
    return viewModel;
}

- (void)viewModelLoad {
    self.emptyType = HTEmptyType_NoStatus;
}

- (void)setViewModelController:(UIViewController<HTViewControllerProtocol> *)viewModelController {
    objc_setAssociatedObject(self,
                             @selector(viewModelController),
                             [NSValue valueWithNonretainedObject:viewModelController],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController<HTViewControllerProtocol> *)viewModelController {
    return ((NSValue *)(objc_getAssociatedObject(self, _cmd))).nonretainedObjectValue;
}

- (UINavigationController *)viewModelNavigationController {
    return self.viewModelController.navigationController;
}

- (RACCommand * _Nonnull (^)(NSString * _Nonnull))requestCommand {
    @weakify(self);
    return ^RACCommand *(NSString *key){
        @strongify(self);
        if (!key.length) {key = NSStringFromClass(self.class);}
        return self._objectForKey(self.commandDict, key, ^id{
            @strongify(self);
            return [self commandForKey:key];
        });
    };
}
- (RACSubject * _Nonnull (^)(NSString * _Nonnull))refreshSignal {
    @weakify(self);
    return ^RACSubject *(NSString *key){
        @strongify(self);
        if (!key.length) {key = NSStringFromClass(self.class);}
        return self._objectForKey(self.refreshViewSignalDict, key, ^{
            return [RACSubject subject];
        });
    };
}

#pragma mark - RAC
- (RACCommand *)commandForKey:(NSString *)key {
    return ht_command(self.commandEnabledSignal(key),
                      self.commandInputHandler(key),
                      self.commandSignal(key));
}


- (RACSignal<NSNumber *> * _Nonnull (^)(NSString * _Nonnull))commandEnabledSignal {
    @weakify(self);
    return ^RACSignal<NSNumber *> *(NSString *key){
        @strongify(self);
        return [self commandEnabledSignalForKey:key];
    };
}

- (typeof(void(^)(id _Nonnull)) (^)(NSString * _Nonnull))commandInputHandler {
    @weakify(self);
    return ^(NSString *key){
        return ^(id input) {
            @strongify(self);
            [self commandInputHandlerWithInput:input forkey:key];
        };
    };
}

- (typeof(RACSignal *(^)(id _Nonnull))  _Nonnull (^)(NSString * _Nonnull))commandSignal {
    @weakify(self);
    return ^(NSString *key) {
        return ^RACSignal *(id input){
            @strongify(self);
            return [self commandSignalWithInput:input forKey:key];
        };
    };
}

- (RACSignal *)commandEnabledSignalForKey:(NSString *)key {
    return ht_signalWithValue(@(true));
}

- (RACSignal *)commandSignalWithInput:(id)input forKey:(NSString *)key {
    return ht_signalWithValue(nil);
}

- (void)commandInputHandlerWithInput:(id)input forkey:(NSString *)key {}

- (NSMutableDictionary<NSString *,RACCommand *> *)commandDict {
    if (!_commandDict) {
        _commandDict = @{}.mutableCopy;
    }
    return _commandDict;
}

- (NSMutableDictionary<NSString *,RACSubject *> *)refreshViewSignalDict {
    if (!_refreshViewSignalDict) {
        _refreshViewSignalDict = @{}.mutableCopy;
    }
    return _refreshViewSignalDict;
}

- (id (^)(NSMutableDictionary *, NSString *, id(^)(void)))_objectForKey {
    return ^(NSMutableDictionary *dict, NSString *key, id(^block)(void)){
        return [dict objectForKey:key] ?: ({
            id object = !block ? nil : block();
            if (object) {
                [dict setObject:object forKey:key];
            }
            object;
        });
    };
}

- (void)dealloc {
    DDLogDebug(@"%@已销毁", NSStringFromClass([self class]));
}
@end

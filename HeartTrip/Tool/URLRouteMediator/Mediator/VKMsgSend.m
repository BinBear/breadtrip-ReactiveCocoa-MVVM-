//
//  NSObject+idSelectorCall.m
//  IdSelectorCall
//
//  Created by Awhisper on 15/12/25.
//  Copyright © 2015年 Awhisper. All rights reserved.
//

#import "VKMsgSend.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIApplication.h>
#endif


#pragma mark : vk_nilObject

@interface vk_pointer : NSObject

@property (nonatomic) void *pointer;

@end

@implementation vk_pointer

@end

@interface vk_nilObject : NSObject

@end

@implementation vk_nilObject

@end

#pragma mark : static

static NSLock *_vkMethodSignatureLock;
static NSMutableDictionary *_vkMethodSignatureCache;
static vk_nilObject *vknilPointer = nil;

static NSString *vk_extractStructName(NSString *typeEncodeString){
    
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    __block int firstVaildIndex = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        char c = [typeEncodeString characterAtIndex:idx];
        if (c=='{'||c=='_') {
            firstVaildIndex++;
        }else{
            *stop = YES;
        }
    }];
    return [typeString substringFromIndex:firstVaildIndex];
}

static NSString *vk_selectorName(SEL selector){
    const char *selNameCstr = sel_getName(selector);
    NSString *selName = [[NSString alloc]initWithUTF8String:selNameCstr];
    return selName;
}

static NSMethodSignature *vk_getMethodSignature(Class cls, SEL selector){
    
    [_vkMethodSignatureLock lock];
    
    if (!_vkMethodSignatureCache) {
        _vkMethodSignatureCache = [[NSMutableDictionary alloc]init];
    }
    if (!_vkMethodSignatureCache[cls]) {
        _vkMethodSignatureCache[(id<NSCopying>)cls] =[[NSMutableDictionary alloc]init];
    }
    NSString *selName = vk_selectorName(selector);
    NSMethodSignature *methodSignature = _vkMethodSignatureCache[cls][selName];
    if (!methodSignature) {
        methodSignature = [cls instanceMethodSignatureForSelector:selector];
        if (methodSignature) {
            _vkMethodSignatureCache[cls][selName] = methodSignature;
        }else
        {
            methodSignature = [cls methodSignatureForSelector:selector];
            if (methodSignature) {
                _vkMethodSignatureCache[cls][selName] = methodSignature;
            }
        }
    }
    [_vkMethodSignatureLock unlock];
    return methodSignature;
}

static void vk_generateError(NSString *errorInfo, NSError **error){
    if (error) {
        *error = [NSError errorWithDomain:errorInfo code:0 userInfo:nil];
    }
}

static id vk_targetCallSelectorWithArgumentError(id target, SEL selector, NSArray *argsArr, NSError *__autoreleasing *error){
    
    Class cls = [target class];
    NSMethodSignature *methodSignature = vk_getMethodSignature(cls, selector);
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    
    NSMutableArray* _markArray;
    
    for (int i = 2; i< [methodSignature numberOfArguments]; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        id valObj = argsArr[i-2];
        switch (argumentType[0]=='r'?argumentType[1]:argumentType[0]) {
            #define VK_CALL_ARG_CASE(_typeString, _type, _selector) \
            case _typeString: {                              \
            _type value = [valObj _selector];                     \
            [invocation setArgument:&value atIndex:i];\
            break; \
            }
                VK_CALL_ARG_CASE('c', char, charValue)
                VK_CALL_ARG_CASE('C', unsigned char, unsignedCharValue)
                VK_CALL_ARG_CASE('s', short, shortValue)
                VK_CALL_ARG_CASE('S', unsigned short, unsignedShortValue)
                VK_CALL_ARG_CASE('i', int, intValue)
                VK_CALL_ARG_CASE('I', unsigned int, unsignedIntValue)
                VK_CALL_ARG_CASE('l', long, longValue)
                VK_CALL_ARG_CASE('L', unsigned long, unsignedLongValue)
                VK_CALL_ARG_CASE('q', long long, longLongValue)
                VK_CALL_ARG_CASE('Q', unsigned long long, unsignedLongLongValue)
                VK_CALL_ARG_CASE('f', float, floatValue)
                VK_CALL_ARG_CASE('d', double, doubleValue)
                VK_CALL_ARG_CASE('B', BOOL, boolValue)

            case ':':{
                NSString *selName = valObj;
                SEL selValue = NSSelectorFromString(selName);
                [invocation setArgument:&selValue atIndex:i];
            }
                break;
            case '{':{
                NSString *typeString = vk_extractStructName([NSString stringWithUTF8String:argumentType]);
                NSValue *val = (NSValue *)valObj;
            #define vk_CALL_ARG_STRUCT(_type, _methodName) \
            if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
            _type value = [val _methodName];  \
            [invocation setArgument:&value atIndex:i];  \
            break; \
            }
                            vk_CALL_ARG_STRUCT(CGRect, CGRectValue)
                            vk_CALL_ARG_STRUCT(CGPoint, CGPointValue)
                            vk_CALL_ARG_STRUCT(CGSize, CGSizeValue)
                            vk_CALL_ARG_STRUCT(NSRange, rangeValue)
                            vk_CALL_ARG_STRUCT(CGAffineTransform, CGAffineTransformValue)
                            vk_CALL_ARG_STRUCT(UIEdgeInsets, UIEdgeInsetsValue)
                            vk_CALL_ARG_STRUCT(UIOffset, UIOffsetValue)
                            vk_CALL_ARG_STRUCT(CGVector, CGVectorValue)
            }
                break;
            case '*':{
                NSCAssert(NO, @"argument boxing wrong,char* is not supported");
            }
                break;
            case '^':{
                vk_pointer *value = valObj;
                void *pointer = value.pointer;
                id obj = *((__unsafe_unretained id *)pointer);
                if (!obj) {
                    if (argumentType[1] == '@') {
                        if (!_markArray) {
                            _markArray = [[NSMutableArray alloc] init];
                        }
                        [_markArray addObject:valObj];
                    }
                }
                [invocation setArgument:&pointer atIndex:i];
            }
                break;
            case '#':{
                [invocation setArgument:&valObj atIndex:i];
            }
                break;
            default:{
                if ([valObj isKindOfClass:[vk_nilObject class]]) {
                    [invocation setArgument:&vknilPointer atIndex:i];
                }else{
                    [invocation setArgument:&valObj atIndex:i];
                }
            }
        }
    }
    
    [invocation invoke];
    
    if ([_markArray count] > 0) {
        for (vk_pointer *pointerObj in _markArray) {
            void *pointer = pointerObj.pointer;
            id obj = *((__unsafe_unretained id *)pointer);
            if (obj) {
                CFRetain((__bridge CFTypeRef)(obj));
            }
        }
    }
    
    const char *returnType = [methodSignature methodReturnType];
    NSString *selName = vk_selectorName(selector);
    if (strncmp(returnType, "v", 1) != 0 ) {
        if (strncmp(returnType, "@", 1) == 0) {
            void *result;
            [invocation getReturnValue:&result];
            
            if (result == NULL) {
                return nil;
            }
            
            id returnValue;
            if ([selName isEqualToString:@"alloc"] || [selName isEqualToString:@"new"] || [selName isEqualToString:@"copy"] || [selName isEqualToString:@"mutableCopy"]) {
                returnValue = (__bridge_transfer id)result;
            }else{
                returnValue = (__bridge id)result;
            }
            return returnValue;
            
        } else {
            switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
                    
            #define vk_CALL_RET_CASE(_typeString, _type) \
            case _typeString: {                              \
            _type returnValue; \
            [invocation getReturnValue:&returnValue];\
            return @(returnValue); \
            break; \
            }
                                vk_CALL_RET_CASE('c', char)
                                vk_CALL_RET_CASE('C', unsigned char)
                                vk_CALL_RET_CASE('s', short)
                                vk_CALL_RET_CASE('S', unsigned short)
                                vk_CALL_RET_CASE('i', int)
                                vk_CALL_RET_CASE('I', unsigned int)
                                vk_CALL_RET_CASE('l', long)
                                vk_CALL_RET_CASE('L', unsigned long)
                                vk_CALL_RET_CASE('q', long long)
                                vk_CALL_RET_CASE('Q', unsigned long long)
                                vk_CALL_RET_CASE('f', float)
                                vk_CALL_RET_CASE('d', double)
                                vk_CALL_RET_CASE('B', BOOL)
                    
                case '{': {
                    NSString *typeString = vk_extractStructName([NSString stringWithUTF8String:returnType]);
                #define vk_CALL_RET_STRUCT(_type) \
                if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
                _type result;   \
                [invocation getReturnValue:&result];\
                NSValue * returnValue = [NSValue valueWithBytes:&(result) objCType:@encode(_type)];\
                return returnValue;\
                }
                                    vk_CALL_RET_STRUCT(CGRect)
                                    vk_CALL_RET_STRUCT(CGPoint)
                                    vk_CALL_RET_STRUCT(CGSize)
                                    vk_CALL_RET_STRUCT(NSRange)
                                    vk_CALL_RET_STRUCT(CGAffineTransform)
                                    vk_CALL_RET_STRUCT(UIEdgeInsets)
                                    vk_CALL_RET_STRUCT(UIOffset)
                                    vk_CALL_RET_STRUCT(CGVector)
                }
                    break;
                case '*':{
                    
                }
                    break;
                case '^': {
                    
                }
                    break;
                case '#': {
                    
                }
                    break;
            }
            return nil;
        }
    }
    return nil;
};

static NSArray *vk_targetBoxingArguments(va_list argList, Class cls, SEL selector, NSError *__autoreleasing *error){
    
    NSMethodSignature *methodSignature = vk_getMethodSignature(cls, selector);
    NSString *selName = vk_selectorName(selector);
    
    if (!methodSignature) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized selector (%@)", selName];
        vk_generateError(errorStr,error);
        return nil;
    }
    NSMutableArray *argumentsBoxingArray = [[NSMutableArray alloc]init];
    
    for (int i = 2; i < [methodSignature numberOfArguments]; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        switch (argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
                
        #define vk_BOXING_ARG_CASE(_typeString, _type)\
        case _typeString: {\
        _type value = va_arg(argList, _type);\
        [argumentsBoxingArray addObject:@(value)];\
        break; \
        }\

                        vk_BOXING_ARG_CASE('c', int)
                        vk_BOXING_ARG_CASE('C', int)
                        vk_BOXING_ARG_CASE('s', int)
                        vk_BOXING_ARG_CASE('S', int)
                        vk_BOXING_ARG_CASE('i', int)
                        vk_BOXING_ARG_CASE('I', unsigned int)
                        vk_BOXING_ARG_CASE('l', long)
                        vk_BOXING_ARG_CASE('L', unsigned long)
                        vk_BOXING_ARG_CASE('q', long long)
                        vk_BOXING_ARG_CASE('Q', unsigned long long)
                        vk_BOXING_ARG_CASE('f', double)
                        vk_BOXING_ARG_CASE('d', double)
                        vk_BOXING_ARG_CASE('B', int)
                
            case ':': {
                SEL value = va_arg(argList, SEL);
                NSString *selValueName = NSStringFromSelector(value);
                [argumentsBoxingArray addObject:selValueName];
            }
                break;
            case '{': {
                NSString *typeString = vk_extractStructName([NSString stringWithUTF8String:argumentType]);
                
            #define vk_FWD_ARG_STRUCT(_type, _methodName) \
            if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
            _type val = va_arg(argList, _type);\
            NSValue* value = [NSValue _methodName:val];\
            [argumentsBoxingArray addObject:value];  \
            break; \
            }
                            vk_FWD_ARG_STRUCT(CGRect, valueWithCGRect)
                            vk_FWD_ARG_STRUCT(CGPoint, valueWithCGPoint)
                            vk_FWD_ARG_STRUCT(CGSize, valueWithCGSize)
                            vk_FWD_ARG_STRUCT(NSRange, valueWithRange)
                            vk_FWD_ARG_STRUCT(CGAffineTransform, valueWithCGAffineTransform)
                            vk_FWD_ARG_STRUCT(UIEdgeInsets, valueWithUIEdgeInsets)
                            vk_FWD_ARG_STRUCT(UIOffset, valueWithUIOffset)
                            vk_FWD_ARG_STRUCT(CGVector, valueWithCGVector)
            }
                break;
            case '*':{
                vk_generateError(@"unsupported char* argumenst",error);
                return nil;
            }
                break;
            case '^': {
                void *value = va_arg(argList, void**);
                vk_pointer *pointerObj = [[vk_pointer alloc]init];
                pointerObj.pointer = value;
                [argumentsBoxingArray addObject:pointerObj];
            }
                break;
            case '#': {
                Class value = va_arg(argList, Class);
                [argumentsBoxingArray addObject:(id)value];
//                vk_generateError(@"unsupported class argumenst",error);
//                return nil;
            }
                break;
            case '@':{
                id value = va_arg(argList, id);
                if (value) {
                    [argumentsBoxingArray addObject:value];
                }else{
                    [argumentsBoxingArray addObject:[vk_nilObject new]];
                }
            }
                break;
            default: {
                vk_generateError(@"unsupported argumenst",error);
                return nil;
            }
        }
    }
    return [argumentsBoxingArray copy];
}

@implementation NSObject (VKMsgSend)

+ (id)VKCallSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error,...{
    
    va_list argList;
    va_start(argList, error);
    SEL selector = NSSelectorFromString(selName);
    NSArray *boxingAruments = vk_targetBoxingArguments(argList, [self class], selector, error);
    va_end(argList);
    
    if (!boxingAruments) {
        return nil;
    }
    return vk_targetCallSelectorWithArgumentError(self, selector, boxingAruments, error);
}

+ (id)VKCallSelector:(SEL)selector error:(NSError *__autoreleasing *)error,...{
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = vk_targetBoxingArguments(argList, [self class], selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    return vk_targetCallSelectorWithArgumentError(self, selector, boxingArguments, error);
}

- (id)VKCallSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error,...{
    
    va_list argList;
    va_start(argList, error);
    SEL selector = NSSelectorFromString(selName);
    NSArray* boxingArguments = vk_targetBoxingArguments(argList, [self class], selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    return vk_targetCallSelectorWithArgumentError(self, selector, boxingArguments, error);
}

- (id)VKCallSelector:(SEL)selector error:(NSError *__autoreleasing *)error,...{
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = vk_targetBoxingArguments(argList, [self class], selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    return vk_targetCallSelectorWithArgumentError(self, selector, boxingArguments, error);
}

@end

@implementation NSString (VKMsgSend)


-(id)VKCallClassSelector:(SEL)selector error:(NSError *__autoreleasing *)error, ...
{
    Class cls = NSClassFromString(self);
    if (!cls) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized className (%@)", self];
        vk_generateError(errorStr,error);
        return nil;
    }
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = vk_targetBoxingArguments(argList, cls, selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    return vk_targetCallSelectorWithArgumentError(cls, selector, boxingArguments, error);
}


-(id)VKCallClassSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error, ...
{
    Class cls = NSClassFromString(self);
    if (!cls) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized className (%@)", self];
        vk_generateError(errorStr,error);
        return nil;
    }
    
    SEL selector = NSSelectorFromString(selName);
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = vk_targetBoxingArguments(argList, cls, selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    return vk_targetCallSelectorWithArgumentError(cls, selector, boxingArguments, error);
}

-(id)VKCallClassAllocInitSelector:(SEL)selector error:(NSError *__autoreleasing *)error, ...
{
    Class cls = NSClassFromString(self);
    if (!cls) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized className (%@)", self];
        vk_generateError(errorStr,error);
        return nil;
    }
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = vk_targetBoxingArguments(argList, cls, selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    id allocObj = [cls alloc];
    return vk_targetCallSelectorWithArgumentError(allocObj, selector, boxingArguments, error);
}

-(id)VKCallClassAllocInitSelectorName:(NSString *)selName error:(NSError *__autoreleasing *)error, ...
{
    Class cls = NSClassFromString(self);
    if (!cls) {
        NSString* errorStr = [NSString stringWithFormat:@"unrecognized className (%@)", self];
        vk_generateError(errorStr,error);
        return nil;
    }
    
    SEL selector = NSSelectorFromString(selName);
    
    va_list argList;
    va_start(argList, error);
    NSArray* boxingArguments = vk_targetBoxingArguments(argList, cls, selector, error);
    va_end(argList);
    
    if (!boxingArguments) {
        return nil;
    }
    
    id allocObj = [cls alloc];
    return vk_targetCallSelectorWithArgumentError(allocObj, selector, boxingArguments, error);
}

@end


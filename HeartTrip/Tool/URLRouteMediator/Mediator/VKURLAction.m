//
//  VKURLAction.m
//  Yuedu
//
//  Created by Awhisper on 16/6/6.
//  Copyright © 2016年 baidu.com. All rights reserved.
//

#import "VKURLAction.h"
#import "VKURLParser.h"
#import "HTMediatorAction.h"
@interface VKURLAction ()


@end

@implementation VKURLAction


#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static VKURLAction *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[VKURLAction alloc] init];
    });
    return mediator;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.urlParser = [[VKURLParser alloc]init];
    }
    return self;
}

+(void)setupScheme:(NSString *)scheme andHost:(NSString *)host
{
    [[self sharedInstance]setupScheme:scheme andHost:host];
}


-(void)setupScheme:(NSString *)scheme andHost:(NSString *)host
{
    self.urlParser.scheme = scheme;
    self.urlParser.host = host;
}

+(void)enableSignCheck:(NSString *)signSalt
{
    [[self sharedInstance]enableSignCheck:signSalt];
}

-(void)enableSignCheck:(NSString *)signSalt
{
    self.urlParser.signSalt = signSalt;
}

+(void)mapKeyword:(NSString *)key toActionName:(NSString *)action
{
    [[self sharedInstance] mapKeyword:key toActionName:action];
}


-(void)mapKeyword:(NSString *)key toActionName:(NSString *)action
{
    [self.urlParser mapKeyword:key toActionName:action];
}

+(id)doActionWithUrl:(NSURL *)url
{
    return [[self sharedInstance] doActionWithUrl:url];
}

-(id)doActionWithUrl:(NSURL *)url{
    NSString *actionName;
    NSDictionary *paramsDic;
    BOOL canOpenUrl = [self.urlParser parseURL:url toAction:&actionName toParamDic:&paramsDic];
    
    if (canOpenUrl) {
        NSError *error;
        HTMediatorAction *mediator = [HTMediatorAction sharedInstance];
        NSString *actionNamePlus = [actionName stringByAppendingString:@":"];
        
        id result = nil;
        if ([mediator respondsToSelector:NSSelectorFromString(actionNamePlus)]) {
            result = [mediator VKCallSelectorName:actionNamePlus error:&error,paramsDic];
        }else if([mediator respondsToSelector:NSSelectorFromString(actionName)])
        {
            result = [mediator VKCallSelectorName:actionName error:&error];
        }
        
        return result;
        
    }
    
    return nil;
}

+(id)doActionWithUrlString:(NSString *)string
{
    return [[self sharedInstance] doActionWithUrlString:string];
}

-(id)doActionWithUrlString:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    return [self doActionWithUrl:url];
}

+(NSString *)creatNewNativeBaseUrl
{
    return [[self sharedInstance] creatNewNativeBaseUrl];
}

-(NSString *)creatNewNativeBaseUrl
{
    return [self.urlParser creatNewNativeBaseUrl];
}

+(NSString *)appendAction:(NSString *)action ToBaseUrl:(NSString *)url
{
    return [[self sharedInstance] appendAction:action ToBaseUrl:url];
}

-(NSString *)appendAction:(NSString *)action ToBaseUrl:(NSString *)url
{
    return [self.urlParser appendAction:action ToBaseUrl:url];
}

+(NSString *)appendArguementToHalfUrl:(NSString *)url WithKey:(NSString *)key andValue:(NSString *)value{
    return [[self sharedInstance] appendArguementToHalfUrl:url WithKey:key andValue:value];
}

-(NSString *)appendArguementToHalfUrl:(NSString *)url WithKey:(NSString *)key andValue:(NSString *)value
{
    return [self.urlParser appendArguementToHalfUrl:url WithKey:key andValue:value];
}

+(NSString *)appendSignCheckToUrl:(NSString *)url
{
    return [[self sharedInstance] appendSignCheckToUrl:url];
}

-(NSString *)appendSignCheckToUrl:(NSString *)url
{
    return [self.urlParser appendSignCheckToUrl:url];
}
@end

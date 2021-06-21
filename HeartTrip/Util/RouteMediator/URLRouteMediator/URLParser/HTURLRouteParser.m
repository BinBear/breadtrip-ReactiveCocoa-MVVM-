//
//  HTURLRouteParser.m
//  HeartTrip
//
//  Created by vin on 2021/6/19.
//  Copyright © 2021 Vin. All rights reserved.
//

#import "HTURLRouteParser.h"
#import "HTURLRouteAction.h"

/// 解析URL,将URL中的参数解析为字典
NSDictionary *params(NSURL *url) {
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    if (NSNotFound != [url.absoluteString rangeOfString:@"?"].location) {
        NSString *paramString = [url.absoluteString substringFromIndex:([url.absoluteString rangeOfString:@"?"].location + 1)];
        NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
        NSScanner *scanner = [[NSScanner alloc] initWithString:paramString];
        while (![scanner isAtEnd]) {
            NSString* pairString = nil;
            [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
            if (kvPair.count == 2) {
                NSString *key = [[kvPair objectAtIndex:0] stringByURLDecode];
                NSString *value = [[kvPair objectAtIndex:1] stringByURLDecode];
                [pairs setValue:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

@interface HTURLRouteParser ()
/// 路由URL
@property (copy,  nonatomic) NSString *routeURL;
/// 路由URL中控制器名称
@property (copy,  nonatomic) NSString *ctrName;
/// 路由URL中viewModel名称
@property (copy,  nonatomic) NSString *vmName;
/// 路由URL中参数
@property (strong,nonatomic) id parameter;
/// 路由URL中跳转类型
@property (assign,nonatomic) HCURLRouteActionType  actionType;
/// 是否标准的路由
@property (assign,nonatomic) BOOL  isRouteURL;
@end


@implementation HTURLRouteParser

+ (instancetype)urlRoutePaeserWithURL:(NSString *)url {
    HTURLRouteParser *urlRoutePaeser = [[self alloc] init];
    urlRoutePaeser.routeURL = url;
    [urlRoutePaeser parseURL];
    return urlRoutePaeser;
}

- (void)parseURL {
    
    NSURL *url = [NSURL URLWithString:self.routeURL];
    // 校验scheme
    if ([HTURLRouteAction.sharedInstance.scheme isNotBlank]) {
        self.isRouteURL = [url.scheme isEqualToString:HTURLRouteAction.sharedInstance.scheme];
    }else{
        self.isRouteURL = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"];
    }
    // 校验host
    if ([HTURLRouteAction.sharedInstance.host isNotBlank]) {
        self.isRouteURL = [url.host isEqualToString:HTURLRouteAction.sharedInstance.host];
    }
    // 解析URL
    NSDictionary *paramInfo = params(url);
    // 不是标准路由地址
    if (!self.isRouteURL || paramInfo.count <= 0) { return; }
    
    if ([HTURLRouteAction.sharedInstance.signSalt isNotBlank]) { // 开启签名校验
        // 生成的签名串
        NSString *signatureStr = [HTURLRouteAction mapSignCheck:paramInfo];
        // 将生成的签名串与路由中的签名串比对
        self.isRouteURL = [signatureStr isEqualToString:HTJSONMake(paramInfo)[HTURLRoute_SignName].string];
    }
    if (self.isRouteURL) {
        // 解析控制器名称
        self.ctrName = HTJSONMake(paramInfo)[HTURLRoute_CtrName].string?:nil;
        // 解析viewModel名称
        self.vmName = HTJSONMake(paramInfo)[HTURLRoute_VmName].string?:nil;
        // 解析跳转方式
        self.actionType = HTJSONMake(paramInfo)[HTURLRoute_Jump].integerValue;
    }
}
@end

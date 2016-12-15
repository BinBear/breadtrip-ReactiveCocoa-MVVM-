//
//  VKRoute.m
//  Yuedu
//
//  Created by Awhisper on 16/6/3.
//  Copyright © 2016年 baidu.com. All rights reserved.
//

#import "VKURLParser.h"
#import "HTMediatorAction.h"
#include <CommonCrypto/CommonCrypto.h>

static NSString *_vkInstanceMethodURL = @"instanceMethodURL";


@implementation NSURL (VKURL)

- (NSURL *)addParams:(NSDictionary *)params {
    NSMutableString *_add = nil;
    if (NSNotFound != [self.absoluteString rangeOfString:@"?"].location) {
        _add = [NSMutableString stringWithString:@"&"];
    }else {
        _add = [NSMutableString stringWithString:@"?"];
    }
    for (NSString* key in [params allKeys]) {
        if ([params objectForKey:key] && 0 < [[params objectForKey:key] length]) {
            [_add appendFormat:@"%@=%@&",key,[[params objectForKey:key] urlencode]];
        }
    }
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                 self.absoluteString,
                                 [_add substringToIndex:[_add length] - 1]]];
}

- (NSDictionary *)params {
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    if (NSNotFound != [self.absoluteString rangeOfString:@"?"].location) {
        NSString *paramString = [self.absoluteString substringFromIndex:
                                 ([self.absoluteString rangeOfString:@"?"].location + 1)];
        NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
        NSScanner* scanner = [[NSScanner alloc] initWithString:paramString];
        while (![scanner isAtEnd]) {
            NSString* pairString = nil;
            [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
            if (kvPair.count == 2) {
                NSString* key = [[kvPair objectAtIndex:0] urldecode];
                NSString* value = [[kvPair objectAtIndex:1] urldecode];
                [pairs setValue:value forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

@end



@implementation NSString (VKURLString)

#pragma mark MD5
-(NSString *)vkMD5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str),result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16 ; i ++ ) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return [hash lowercaseString];
}

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

- (NSString *)urldecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)urlencode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
       
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@";
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

@end



@interface VKURLParser ()

@property (nonatomic,strong) NSMutableDictionary *shortNameDic;
@end

@implementation VKURLParser

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.shortNameDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)mapKeyword:(NSString *)key toActionName:(NSString *)action
{
    if (key.length > 0 && action.length > 0) {
        [self.shortNameDic setObject:action forKey:key];
    }
}


-(BOOL)parseURL:(NSURL *)url toAction:(NSString *__autoreleasing*)action toParamDic:(NSDictionary *__autoreleasing*)params;
{
    if (![url.scheme isEqualToString:self.scheme]) {
        return NO;
    }
    
    if (![url.host isEqualToString:self.host]) {
        return NO;
    }
    
    
    NSString *relp = url.relativePath;
    NSArray *pathcomponent = [relp componentsSeparatedByString:@"/"];
    NSString *actionName = pathcomponent.lastObject;
    NSString *origActionName = nil;
    if ([self.shortNameDic objectForKey:actionName]) {
        origActionName = actionName;
        actionName = self.shortNameDic[actionName];
    }
    
    NSString *actionNamePlus = [actionName stringByAppendingString:@":"];
    
    
    if (actionName && actionName.length > 0 &&
        ([HTMediatorAction instancesRespondToSelector:NSSelectorFromString(actionName)] ||
         [HTMediatorAction instancesRespondToSelector:NSSelectorFromString(actionNamePlus)])) {
        //符合mediatorAction 可以响应的selector 才算action正确
        if (action) {
            *action = actionName;
        }
        
    }else{
        return NO;
    }
    
    NSDictionary *paramInfo = [url params];
    if (params) {
        *params = paramInfo;
    }
    
    
    if (self.signSalt && self.signSalt.length > 0) {
        NSMutableString *checkContent;
        if (origActionName.length > 0) {
            checkContent = [[NSMutableString alloc]initWithString:origActionName];
        }else{
            checkContent = [[NSMutableString alloc]initWithString:actionName];
        }
        
        
        [checkContent appendString:@"_"];
        NSString *md5Sign;
        for (NSString *key in paramInfo.allKeys) {
            if (![key containsString:@"sign"]) {
                [checkContent appendString:key];
                [checkContent appendString:@"_"];
                [checkContent appendString:paramInfo[key]];
                [checkContent appendString:@"_"];
            }else{
                md5Sign = paramInfo[key];
            }
        }
        [checkContent appendString:self.signSalt];
        NSString *content = [NSString stringWithString:checkContent];
        NSString *contentMd5 = [content vkMD5HexDigest];
        if ([contentMd5 isEqualToString:md5Sign]) {
            return YES;
        }else
        {
            return NO;
        }
        
    }else{
        //无签名校验的时候 默认通过check
        return YES;
    }
}





-(NSString *)creatNewNativeBaseUrl
{
    NSMutableString * urlstring = [NSMutableString stringWithString:self.scheme];
    [urlstring appendString:@"://"];
    [urlstring appendString:self.host];
    [urlstring appendString:@"/"];
    NSString * result = [NSString stringWithString:urlstring];
    return result;
}

-(NSString *)appendAction:(NSString *)action ToBaseUrl:(NSString *)url
{
    NSMutableString * urlstring = [NSMutableString stringWithString:url];
    [urlstring appendString:action];
    NSString * result = [NSString stringWithString:urlstring];
    return result;
}


-(NSString *)appendArguementToHalfUrl:(NSString *)url WithKey:(NSString *)key andValue:(NSString *)value
{
    value = [value urlencode];
    
    NSMutableString * urlstring = [NSMutableString stringWithString:url];
    if (![url containsString:@"?"]) {
        [urlstring appendString:@"?"];
    }else{
        [urlstring appendString:@"&"];
    }
    
    [urlstring appendString:key];
    
    [urlstring appendString:@"="];
    
    [urlstring appendString:value];
    
    NSString * result = [NSString stringWithString:urlstring];
    return result;
}


-(NSString *)appendSignCheckToUrl:(NSString *)urlstr
{
    NSMutableString * urlstring = [NSMutableString stringWithString:urlstr];
    
    NSURL * url = [NSURL URLWithString:urlstr];
    NSString *relp = url.relativePath;
    NSArray *pathcomponent = [relp componentsSeparatedByString:@"/"];
    NSString *actionName = pathcomponent.lastObject;
    
    NSDictionary *paramInfo = [url params];
    
    if (self.signSalt.length > 0) {
        
        NSMutableString *checkContent = [[NSMutableString alloc]initWithString:actionName];
        [checkContent appendString:@"_"];
        NSString *md5Sign;
        for (NSString *key in paramInfo.allKeys) {
            if (![key containsString:@"sign"]) {
                [checkContent appendString:key];
                [checkContent appendString:@"_"];
                [checkContent appendString:paramInfo[key]];
                [checkContent appendString:@"_"];
            }else{
                md5Sign = paramInfo[key];
            }
        }
        [checkContent appendString:self.signSalt];
        NSString *content = [NSString stringWithString:checkContent];
        NSString *contentMd5 = [content vkMD5HexDigest];
        
        if (![urlstring containsString:@"?"]) {
            [urlstring appendString:@"?"];
        }else{
            [urlstring appendString:@"&"];
        }
        
        [urlstring appendString:@"sign"];
        
        [urlstring appendString:@"="];
        
        [urlstring appendString:contentMd5];

        NSString * result = [NSString stringWithString:urlstring];
        return result;
    }else
    {
        return urlstr;
    }
}

@end

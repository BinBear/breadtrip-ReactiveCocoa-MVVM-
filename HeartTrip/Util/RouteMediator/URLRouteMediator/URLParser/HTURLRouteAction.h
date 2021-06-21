//
//  HTURLRouteAction.h
//  HeartTrip
//
//  Created by vin on 2021/6/19.
//  Copyright © 2021 Vin. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


/*  路由URL参数中固定的四个参数名  */
// 路由中控制器名称的key
FOUNDATION_EXTERN NSString * const HTURLRoute_CtrName;
// 路由中viewModel的key
FOUNDATION_EXTERN NSString * const HTURLRoute_VmName;
// 路由中签名串的key
FOUNDATION_EXTERN NSString * const HTURLRoute_SignName;
// 路由中跳转方式的key
FOUNDATION_EXTERN NSString * const HTURLRoute_Jump;


@interface HTURLRouteAction : NSObject

/// 自定义scheme
@property (copy,  nonatomic) NSString *scheme;
/// 自定义host
@property (copy,  nonatomic) NSString *host;
/// 生成签名串的salt
@property (copy,  nonatomic) NSString *signSalt;

/// 初始化URLRoute实例
+ (instancetype)sharedInstance;

/// 自定义路由scheme、host、签名串
/// @param scheme 自定义scheme
/// @param host 自定义host
/// @param signSalt 签名串的salt，如果设置则表示开启签名校验 
+ (void)customScheme:(NSString * _Nullable)scheme
             andHost:(NSString * _Nullable)host
           signCheck:(NSString * _Nullable)signSalt;



/// 快速生成一个路由BaseUrl
+ (NSString *)mapNativeRouteBaseUrl;
/// 根据参数快速生成一个路由URL，可用于服务端配置远程路由，或服务端实现
/// @param value 参数
+ (NSString *)mapNativeRouteUrl:(id _Nullable)value;
/// 生成签名串 规则：
/// 1：将参数的key按字母进行排序
/// 2：将除签名串外的参数的key与值拼接成字符串
/// 3：最后拼接一个固定的 salt=signSalt
/// 4：将拼接好的字符串进行一次MD5的哈希
/// @param params 参与签名的参数
+ (NSString *)mapSignCheck:(id)params;
@end

NS_ASSUME_NONNULL_END

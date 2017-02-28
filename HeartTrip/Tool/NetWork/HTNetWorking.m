//
//  HTNetWorking.m
//  HeartTrip
//
//  Created by 熊彬 on 16/9/13.
//  Copyright © 2016年 BinBear. All rights reserved.
//

#import "HTNetWorking.h"
#import <AFNetworking.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPSessionManager.h"
#import "HTAppDotNetAPIClient.h"

#import "HTServerConfig.h"
#import "HTShowMessageView.h"


/**
 *  基础URL
 */
static NSString *HT_privateNetworkBaseUrl = nil;
/**
 *  是否开启接口打印信息
 */
static BOOL HT_isEnableInterfaceDebug = NO;
/**
 *  是否开启自动转换URL里的中文
 */
static BOOL HT_shouldAutoEncode = NO;
/**
 *  设置请求头，默认为空
 */
static NSDictionary *HT_httpHeaders = nil;
/**
 *  设置的返回数据类型
 */
static HTResponseType HT_responseType = kHTResponseTypeData;
/**
 *  设置的请求数据类型
 */
static HTRequestType  HT_requestType  = kHTRequestTypePlainText;
/**
 *  监测网络状态
 */
static HTNetworkStatus HT_networkStatus = kHTNetworkStatusUnknown;
/**
 *  保存所有网络请求的task
 */
static NSMutableArray *HT_requestTasks;
/**
 *  GET请求设置不缓存，Post请求不缓存
 */
static BOOL HT_cacheGet  = NO;
static BOOL HT_cachePost = NO;
/**
 *  是否开启取消请求
 */
static BOOL HT_shouldCallbackOnCancelRequest = YES;
/**
 *  请求的超时时间
 */
static NSTimeInterval HT_timeout = 25.0f;
/**
 *  是否从从本地提取数据
 */
static BOOL HT_shoulObtainLocalWhenUnconnected = NO;
/**
 *  基础url是否更改，默认为yes
 */
static BOOL HT_isBaseURLChanged = YES;
/**
 *  请求管理者
 */
static HTAppDotNetAPIClient *HT_sharedManager = nil;

@implementation HTNetWorking
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost {
    HT_cacheGet = isCacheGet;
    HT_cachePost = shouldCachePost;
}

+ (void)updateBaseUrl:(NSString *)baseUrl {
    if ([baseUrl isEqualToString:HT_privateNetworkBaseUrl] && baseUrl && baseUrl.length) {
        HT_isBaseURLChanged = YES;
    } else {
        HT_isBaseURLChanged = NO;
    }
    HT_privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
    return HT_privateNetworkBaseUrl;
}

+ (void)setTimeout:(NSTimeInterval)timeout {
    HT_timeout = timeout;
}

+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain {
    HT_shoulObtainLocalWhenUnconnected = shouldObtain;
}

+ (void)enableInterfaceDebug:(BOOL)isDebug {
    HT_isEnableInterfaceDebug = isDebug;
}

+ (BOOL)isDebug {
    return HT_isEnableInterfaceDebug;
}

static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HTNetworkingCaches"];
}

+ (void)clearCaches {
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
            NSLog(@"HTNetworking clear caches error: %@", error);
        } else {
            NSLog(@"HTNetworking clear caches ok");
        }
    }
}

+ (unsigned long long)totalCacheSize {
    NSString *directoryPath = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (HT_requestTasks == nil) {
            HT_requestTasks = @[].mutableCopy;
        }
    });
    
    return HT_requestTasks;
}

+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(HTURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[HTURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(HTURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[HTURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

+ (void)configRequestType:(HTRequestType)requestType
             responseType:(HTResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest {
    HT_requestType = requestType;
    HT_responseType = responseType;
    HT_shouldAutoEncode = shouldAutoEncode;
    HT_shouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

+ (BOOL)shouldEncode {
    return HT_shouldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
    HT_httpHeaders = httpHeaders;
}

// 无进度回调 无提示框
+ (HTURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          success:(HTResponseSuccess)success
                             fail:(HTResponseFail)fail{
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:1
                             params:nil
                           progress:nil
                            success:success
                               fail:fail];
}
// 无进度回调 有提示框
+ (HTURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          showHUD:(NSString *)statusText
                          success:(HTResponseSuccess)success
                             fail:(HTResponseFail)fail{
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:1
                             params:nil
                           progress:nil
                            success:success
                               fail:fail];
}
// 无进度回调 无提示框
+ (HTURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(HTResponseSuccess)success
                             fail:(HTResponseFail)fail{
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:1
                             params:params
                           progress:nil
                            success:success
                               fail:fail];
}
// 无进度回调 有提示框
+ (HTURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          showHUD:(NSString *)statusText
                           params:(NSDictionary *)params
                          success:(HTResponseSuccess)success
                             fail:(HTResponseFail)fail{
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:1
                             params:params
                           progress:nil
                            success:success
                               fail:fail];
}
// 有进度回调 无提示框
+ (HTURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(HTGetProgress)progress
                          success:(HTResponseSuccess)success
                             fail:(HTResponseFail)fail {
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:1
                             params:params
                           progress:progress
                            success:success
                               fail:fail];
}
// 有进度回调 有提示框
+ (HTURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          showHUD:(NSString *)statusText
                           params:(NSDictionary *)params
                         progress:(HTGetProgress)progress
                          success:(HTResponseSuccess)success
                             fail:(HTResponseFail)fail{
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:1
                             params:params
                           progress:progress
                            success:success
                               fail:fail];
}
/**
 *  无进度回调 无提示框
 */

+ (HTURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                           success:(HTResponseSuccess)success
                              fail:(HTResponseFail)fail{
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:2
                             params:params
                           progress:nil
                            success:success
                               fail:fail];
}

/**
 *  无进度回调 有提示框
 *
 */
+ (HTURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                           showHUD:(NSString *)statusText
                            params:(NSDictionary *)params
                           success:(HTResponseSuccess)success
                              fail:(HTResponseFail)fail{
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:2
                             params:params
                           progress:nil
                            success:success
                               fail:fail];
}
// 有进度回调 无提示框
+ (HTURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                          progress:(HTPostProgress)progress
                           success:(HTResponseSuccess)success
                              fail:(HTResponseFail)fail {
    
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:NO
                            showHUD:nil
                          httpMedth:2
                             params:params
                           progress:progress
                            success:success
                               fail:fail];
}
// 有进度回调 有提示框
+ (HTURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                           showHUD:(NSString *)statusText
                            params:(NSDictionary *)params
                          progress:(HTPostProgress)progress
                           success:(HTResponseSuccess)success
                              fail:(HTResponseFail)fail{
    
    return [self HT_requestWithUrl:url
                       refreshCache:refreshCache
                          isShowHUD:YES
                            showHUD:statusText
                          httpMedth:2
                             params:params
                           progress:progress
                            success:success
                               fail:fail];
}

+ (HTURLSessionTask *)HT_requestWithUrl:(NSString *)url
                             refreshCache:(BOOL)refreshCache
                                isShowHUD:(BOOL)isShowHUD
                                  showHUD:(NSString *)statusText
                                httpMedth:(NSUInteger)httpMethod
                                   params:(NSDictionary *)params
                                 progress:(HTDownloadProgress)progress
                                  success:(HTResponseSuccess)success
                                     fail:(HTResponseFail)fail {
    
    
    if (url) {
        
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            
        }else{
            
            NSString *serverAddress = [HTServerConfig getHTServerAddr];
            url = [serverAddress stringByAppendingString:url];
        }
        
    }else{
        return nil;
    }
    
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    HTAppDotNetAPIClient *manager = [self manager];
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    HTURLSessionTask *session = nil;
    // 显示提示框
    if (isShowHUD) {
        [HTNetWorking showHUD:statusText];
    }
    if (httpMethod == 1) {
        if (HT_cacheGet) {
            if (HT_shoulObtainLocalWhenUnconnected) {
                if (HT_networkStatus == kHTNetworkStatusNotReachable ||  HT_networkStatus == kHTNetworkStatusUnknown ) {
                    id response = [HTNetWorking cahceResponseWithURL:absolute
                                                           parameters:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                            
                            if ([self isDebug]) {
                                [self logWithSuccessResponse:response
                                                         url:absolute
                                                      params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            if (!refreshCache) {
                id response = [HTNetWorking cahceResponseWithURL:absolute
                                                       parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                    return nil;
                }
            }
        }
        
        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 移除提示框
            if (isShowHUD) {
                [HTNetWorking dismissSuccessHUD];
            }
            
            [[self allTasks] removeObject:task];
            
            [self successResponse:responseObject callback:success];
            
            if (HT_cacheGet) {
                [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];
            }
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 移除提示框
            if (isShowHUD) {
                [HTNetWorking dismissErrorHUD];
            }
            [[self allTasks] removeObject:task];
            
            if ([error code] < 0 && HT_cacheGet) {// 获取缓存
                id response = [HTNetWorking cahceResponseWithURL:absolute
                                                       parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                } else {
                    [self handleCallbackWithError:error fail:fail];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            } else {
                [self handleCallbackWithError:error fail:fail];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
        }];
    }
    else if (httpMethod == 2) {
        if (HT_cachePost ) {// 获取缓存
            if (HT_shoulObtainLocalWhenUnconnected) {
                if (HT_networkStatus == kHTNetworkStatusNotReachable ||  HT_networkStatus == kHTNetworkStatusUnknown ) {
                    id response = [HTNetWorking cahceResponseWithURL:absolute
                                                           parameters:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                            
                            if ([self isDebug]) {
                                [self logWithSuccessResponse:response
                                                         url:absolute
                                                      params:params];
                            }
                        }
                        return nil;
                    }
                }
            }
            if (!refreshCache) {
                id response = [HTNetWorking cahceResponseWithURL:absolute
                                                       parameters:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                    return nil;
                }
            }
        }
        
        
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 移除提示框
            if (isShowHUD) {
                [HTNetWorking dismissSuccessHUD];
            }
            
            [[self allTasks] removeObject:task];
            
            [self successResponse:responseObject callback:success];
            
            if (HT_cachePost) {
                [self cacheResponseObject:responseObject request:task.currentRequest  parameters:params];
            }
            
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:absolute
                                      params:params];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 移除提示框
            if (isShowHUD) {
                [HTNetWorking dismissErrorHUD];
            }
            [[self allTasks] removeObject:task];
            if ([error code] < 0 && HT_cachePost) {// 获取缓存
                id response = [HTNetWorking cahceResponseWithURL:absolute
                                                       parameters:params];
                
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        
                        if ([self isDebug]) {
                            [self logWithSuccessResponse:response
                                                     url:absolute
                                                  params:params];
                        }
                    }
                } else {
                    [self handleCallbackWithError:error fail:fail];
                    
                    if ([self isDebug]) {
                        [self logWithFailError:error url:absolute params:params];
                    }
                }
            } else {
                [self handleCallbackWithError:error fail:fail];
                
                if ([self isDebug]) {
                    [self logWithFailError:error url:absolute params:params];
                }
            }
        }];
    }
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (HTURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(HTUploadProgress)progress
                                 success:(HTResponseSuccess)success
                                    fail:(HTResponseFail)fail {
    if ([NSURL URLWithString:uploadingFile] == nil) {
        
        return nil;
    }
    
    NSURL *uploadURL = nil;
    if ([self baseUrl] == nil) {
        uploadURL = [NSURL URLWithString:url];
    } else {
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }
    
    if (uploadURL == nil) {
        
        return nil;
    }
    
    HTAppDotNetAPIClient *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    HTURLSessionTask *session = nil;
    
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        [self successResponse:responseObject callback:success];
        
        if (error) {
            [self handleCallbackWithError:error fail:fail];
            
            if ([self isDebug]) {
                [self logWithFailError:error url:response.URL.absoluteString params:nil];
            }
        } else {
            if ([self isDebug]) {
                [self logWithSuccessResponse:responseObject
                                         url:response.URL.absoluteString
                                      params:nil];
            }
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (HTURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              progress:(HTUploadProgress)progress
                               success:(HTResponseSuccess)success
                                  fail:(HTResponseFail)fail {
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absolute = [self absoluteUrlWithPath:url];
    
    HTAppDotNetAPIClient *manager = [self manager];
    HTURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        
        NSString *imageFileName = filename;
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success];
        
        if ([self isDebug]) {
            [self logWithSuccessResponse:responseObject
                                     url:absolute
                                  params:parameters];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        
        [self handleCallbackWithError:error fail:fail];
        
        if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:nil];
        }
    }];
    

    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (HTURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(HTDownloadProgress)progressBlock
                               success:(HTResponseSuccess)success
                               failure:(HTResponseFail)failure {
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            
            return nil;
        }
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    HTAppDotNetAPIClient *manager = [self manager];
    
    HTURLSessionTask *session = nil;
    
    session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:session];
        
        if (error == nil) {
            if (success) {
                success(filePath.absoluteString);
            }
            
            if ([self isDebug]) {
                NSLog(@"Download success for url %@",
                      [self absoluteUrlWithPath:url]);
            }
        } else {
            [self handleCallbackWithError:error fail:failure];
            
            if ([self isDebug]) {
                NSLog(@"Download fail for url %@, reason : %@",
                      [self absoluteUrlWithPath:url],
                      [error description]);
            }
        }
    }];
    
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

#pragma mark - Private
+ (HTAppDotNetAPIClient *)manager {
    
    @synchronized (self) {
        
        if (HT_sharedManager == nil || HT_isBaseURLChanged) {
            // 开启转圈圈
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            HTAppDotNetAPIClient *manager = nil;;
            if ([self baseUrl] != nil) {
                manager = [[HTAppDotNetAPIClient sharedClient] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
            } else {
                manager = [HTAppDotNetAPIClient sharedClient];
            }
            
            switch (HT_requestType) {
                case kHTRequestTypeJSON: {
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                }
                case kHTRequestTypePlainText: {
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            switch (HT_responseType) {
                case kHTResponseTypeJSON: {
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                }
                case kHTResponseTypeXML: {
                    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                }
                case kHTResponseTypeData: {
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            
            
            for (NSString *key in HT_httpHeaders.allKeys) {
                if (HT_httpHeaders[key] != nil) {
                    [manager.requestSerializer setValue:HT_httpHeaders[key] forHTTPHeaderField:key];
                }
            }
            
            // 设置cookie
//            [self setUpCoookie];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
            
            manager.requestSerializer.timeoutInterval = HT_timeout;
            
            manager.operationQueue.maxConcurrentOperationCount = 3;
            HT_sharedManager = manager;
        }
    }

    return HT_sharedManager;
}


+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    NSLog(@"\n");
    NSLog(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
          [self generateGETAbsoluteURL:url params:params],
          params,
          [self tryToParseData:response]);
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    NSString *format = @" params: ";
    if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    NSLog(@"\n");
    if ([error code] == NSURLErrorCancelled) {
        NSLog(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params);
    } else {
        NSLog(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params,
              [error localizedDescription]);
    }
}

+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(NSDictionary *)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}


+ (NSString *)encodeUrl:(NSString *)url {
    return [self HT_URLEncode:url];
}
// 解析json数据
+ (id)tryToParseData:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

+ (void)successResponse:(id)responseData callback:(HTResponseSuccess)success {
    if (success) {
        success([self tryToParseData:responseData]);
    }
}

+ (NSString *)HT_URLEncode:(NSString *)url {
    if ([url respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        
        static NSString * const kAFCharacterHTeneralDelimitersToEncode = @":#[]@";
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharacterHTeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < url.length) {
            NSUInteger length = MIN(url.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            range = [url rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [url substringWithRange:range];
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
                                                (__bridge CFStringRef)url,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    
    if (url) {
        
        NSString *directoryPath = cachePath();
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [absoluteURL md5String];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            NSLog(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return cacheData;
}

+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                NSLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [absoluteURL md5String];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                NSLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                NSLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}

+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",
                               [self baseUrl], mutablePath];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }
        }else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                               [self baseUrl], path];
            }
        }
    }
    
    
    return absoluteUrl;
}

+ (void)handleCallbackWithError:(NSError *)error fail:(HTResponseFail)fail {
    if ([error code] == NSURLErrorCancelled) {
        if (HT_shouldCallbackOnCancelRequest) {
            if (fail) {
                fail(error);
            }
        }
    } else {
        if (fail) {
            fail(error);
        }
    }
}
#pragma mark - HUD

+ (void)showHUD:(NSString *)showMessge
{
    
  
    dispatch_main_async_safe(^{
        [HTShowMessageView showStatusWithMessage:showMessge];
    });
}

+ (void)dismissSuccessHUD
{
    dispatch_main_async_safe(^{
        [HTShowMessageView dismissSuccessView:@"Success"];
    });
    
}
+ (void)dismissErrorHUD
{
    dispatch_main_async_safe(^{
        [HTShowMessageView dismissErrorView:@"Error"];
    });
    
}
#pragma mark  - Cookie
// 获取并保存cookie
+ (void)getAndSaveCookie:(NSURLSessionDataTask *)task andUrl:(NSString *)url
{
    //获取cookie
    NSDictionary *headers = [(NSHTTPURLResponse *)task.response allHeaderFields];

    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:[NSURL URLWithString:url]];
    
    if (cookies && cookies.count != 0) {
        
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
        //存储归档后的cookie
        [CommonUtils saveValueInUD:cookiesData forKey:@"UserCookie"];
        
    }
    
    
}
// 删除cookie
+ (void)deleteCookieWithLoginOut
{
    NSData *cookiesData = [NSData data];
    [CommonUtils saveValueInUD:cookiesData forKey:@"UserCookie"];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    //删除cookie
    for (NSHTTPCookie *tempCookie in cookies) {
        [cookieStorage deleteCookie:tempCookie];
    }
   
}
// 重新设置cookie
+ (void)setUpCoookie
{

    //取出保存的cookie
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //对取出的cookie进行反归档处理
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:@"UserCookie"]];
    
    if (cookies && cookies.count != 0) {
     
        //设置cookie
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (id cookie in cookies) {
            [cookieStorage setCookie:(NSHTTPCookie *)cookie];
        }
    }else{
    
    }
 
}
@end

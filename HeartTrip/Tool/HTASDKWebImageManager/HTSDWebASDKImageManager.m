//
//  HTSDWebASDKImageManager.m
//  HeartTrip
//
//  Created by 熊彬 on 2017/9/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "HTSDWebASDKImageManager.h"

#import "HTSDWebASDKImageContainer.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>

@implementation HTSDWebASDKImageManager

+ (instancetype)sharedManager
{
    static HTSDWebASDKImageManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SDWebImageManager *webImageManager = [SDWebImageManager sharedManager];
        instance = [[self alloc] initWithWebImageManager:webImageManager];
        instance.webImageOptions = SDWebImageRetryFailed | SDWebImageContinueInBackground;
    });
    return instance;
}

- (instancetype)init
{
    return [self initWithWebImageManager:[SDWebImageManager sharedManager]];
}

- (instancetype)initWithWebImageManager:(SDWebImageManager *)manager
{
    if (self = [super init]) {
        _webImageManager = manager;
    }
    return self;
}

#pragma mark - ASImageCacheProtocol

- (void)cachedImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue completion:(ASImageCacherCompletion)completion
{
    if (!URL) {
        completion(nil);
        return;
    }
    
    NSString *cacheKey = [self.webImageManager cacheKeyForURL:URL];
    [self.webImageManager.imageCache queryCacheOperationForKey:cacheKey done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
        dispatch_async(callbackQueue ?: dispatch_get_main_queue(), ^{
            completion([HTSDWebASDKImageContainer containerForImage:image]);
        });
    }];
}

- (id<ASImageContainerProtocol>)synchronouslyFetchedCachedImageWithURL:(NSURL *)URL
{
    if (!URL) {
        return nil;
    }
    NSString* cacheKey = [self.webImageManager cacheKeyForURL:URL];
    return [HTSDWebASDKImageContainer containerForImage:[self.webImageManager.imageCache imageFromMemoryCacheForKey:cacheKey]];
}

- (void)clearFetchedImageFromCacheWithURL:(NSURL *)URL
{
    if (!URL) {
        return;
    }
    NSString* cacheKey = [self.webImageManager cacheKeyForURL:URL];
    [self.webImageManager.imageCache removeImageForKey:cacheKey fromDisk:NO withCompletion:nil];
}

#pragma mark - ASImageDownloaderProtocol

- (nullable id)downloadImageWithURL:(NSURL *)URL
                      callbackQueue:(dispatch_queue_t)callbackQueue
                   downloadProgress:(nullable ASImageDownloaderProgress)downloadProgressBlock
                         completion:(ASImageDownloaderCompletion)completion
{
    if (!URL) {
        NSString *domain = [NSBundle bundleForClass:[self class]].bundleIdentifier;
        NSString *description = @"图片下载地址错误";
        completion(nil, [NSError errorWithDomain:domain code:0 userInfo:@{NSLocalizedDescriptionKey: description}], nil);
        return nil;
    }
    
    __weak id<SDWebImageOperation> weakOperation = nil;
    id<SDWebImageOperation> operation = [self.webImageManager loadImageWithURL:URL options:self.webImageOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (downloadProgressBlock) {
            dispatch_async(callbackQueue ?: dispatch_get_main_queue(), ^{
                downloadProgressBlock((CGFloat)receivedSize / expectedSize);
            });
        }
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (!finished) {
            return;
        }
        
        dispatch_async(callbackQueue ?: dispatch_get_main_queue(), ^{
            completion([HTSDWebASDKImageContainer containerForImage:image], error, weakOperation);
        });
    }];
    weakOperation = operation;
    return operation;
}

- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier
{
    if (!downloadIdentifier) {
        return;
    }
    
    NSAssert([[downloadIdentifier class] conformsToProtocol:@protocol(SDWebImageOperation)], @"不可识别的下载标识");
    id<SDWebImageOperation> downloadOperation = downloadIdentifier;
    [downloadOperation cancel];
}

@end

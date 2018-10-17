//
//  HEResourceManagerProtocol.h
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  资源管理

#ifndef HEResourceManagerProtocol_h
#define HEResourceManagerProtocol_h

@class HEResourceQueryOption;
@class HECacheQueryResult;

/**
 *  缓存搜索 block
 *
 *  @param error   错误,如果成功则 error 为 nil
 *  @param results 成功时的结果列表,内部为 HECacheQueryResult
 */
typedef void(^HEResourceSearchHandler)(NSError * __nullable error, NSArray<HECacheQueryResult *> * __nullable results);

/**
 *  缓存删除 block
 *
 *  @param error         错误,如果成功则 error 为 nil
 *  @param freeBytes     释放的磁盘空间大小
 */
typedef void(^HEResourceDeleteHandler)(NSError * __nullable error, long long freeBytes);


/**
 *  上传Block
 *
 *  @param urlString 上传后得到的URL,失败时为nil
 *  @param error     错误信息,成功时为nil
 */
typedef void(^HEUploadCompleteBlock)(NSString * __nullable urlString,NSError * __nullable error);


/**
 *  上传/下载进度Block
 *
 *  @param progress 进度 0%-100%
 *  @discussion 如果下载的文件是以 Tranfer-Encoding 为 chunked 的形式传输，那么 progress 为已下载文件大小的负数
 */
typedef void(^HEHttpProgressBlock)(float progress);


/**
 *  下载Block
 *
 *  @param error 错误信息,成功时为nil
 */
typedef void(^HEDownloadCompleteBlock)(NSError * __nullable error);


/**
 *  资源管理
 */
@protocol HEResourceManager <NSObject>

/**
 *  上传文件
 *
 *  @param filepath   上传文件路径
 *  @param progress   进度Block
 *  @param completion 上传Block
 */
- (void)upload:(NSString *)filepath
      progress:(nullable HEHttpProgressBlock)progress
    completion:(nullable HEUploadCompleteBlock)completion;

/**
 *  上传文件
 *
 *  @param filepath   上传文件路径
 *  @param scene      场景类别
 *  @param progress   进度Block
 *  @param completion 上传Block
 */
- (void)upload:(NSString *)filepath
         scene:(nonnull NSString *)scene
      progress:(nullable HEHttpProgressBlock)progress
    completion:(nullable HEUploadCompleteBlock)completion;

/**
 *  下载文件
 *
 *  @param urlString  下载的RL
 *  @param filepath   下载路径
 *  @param progress   进度Block
 *  @param completion 完成Block
 */
- (void)download:(NSString *)urlString
        filepath:(NSString *)filepath
        progress:(nullable HEHttpProgressBlock)progress
      completion:(nullable HEDownloadCompleteBlock)completion;

/**
 *  取消上传/下载任务
 *
 *  @param filepath 上传/下载任务对应的文件路径
 *  @discussion 如果同一个文件同时上传或者下载(理论上不应该出现这种情况),ResourceManager会进行任务合并,基于这个原则cancel的操作对象是某个文件对应的所有的上传/下载任务
 */
- (void)cancelTask:(NSString *)filepath;


/**
 *  规范化 URL 地址
 *
 *  @param urlString url 地址
 *  @discussion 按照 HESDK 的要求对 url 进行规范化处理，调用该接口等同于同时调用 convertHttpToHttps: 和 convertURLToAcceleratedURL:
 */
- (NSString *)normalizeURLString:(NSString *)urlString;

/**
 *  将 http url 转换为 https url
 *
 *  @param urlString http url 地址
 *  @discussion SDK 会自动处理除自定义消息外所有消息内的 http url 以保证符合苹果的审核请求，但是自定义消息中的 http 地址 SDK 并不知道具体属性在哪，所以在做这些文件下载时，需要上层自己处理
 *              如果传入的 url 是 https 地址，直接返回字符串本身。如果传入的 url 是云信无法识别 host 的 http 地址，直接返回添加了 https 的地址
 */
- (NSString *)convertHttpToHttps:(NSString *)urlString;

/**
 *  将 url 转换为加速后的 CDN url 地址
 *
 *  @param urlString 未加速 url 地址
 *  @discussion SDK 会自动处理除自定义消息外所有消息内的 url 进行 CDN 加速，但是自定义消息中的 url 地址 SDK 并不知道具体属性在哪，所以在做这些文件下载时，需要上层传入对应的 URL 替换为走 CDN 格式的地址，以获得 CDN 加速的效果
 */
- (NSString *)convertURLToAcceleratedURL:(NSString *)urlString;


/**
 *  将传入的 nos 图片 url 调整为缩略图形式 url
 *
 *  @param urlString 图片url
 *
 */
- (NSString *)imageThumbnailURL:(NSString *)urlString;

/**
 *  将传入的 nos 视频 url 调整为缩略图形式 url
 *
 *  @param urlString 视频url
 *
 */
- (NSString *)videoThumbnailURL:(NSString *)urlString;


/**
 *  搜索缓存的资源文件
 *
 *  @param option       搜索选项
 *  @param completion   完成回调
 */
- (void)searchResourceFiles:(HEResourceQueryOption *)option
                 completion:(HEResourceSearchHandler)completion;

/**
 *  删除缓存的资源文件
 *
 *  @param option       搜索选项
 *  @param completion   完成回调
 */
- (void)removeResourceFiles:(HEResourceQueryOption *)option
                 completion:(HEResourceDeleteHandler)completion;


#endif /* HEResourceManagerProtocol_h */

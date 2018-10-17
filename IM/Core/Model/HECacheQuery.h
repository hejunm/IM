//
//  HECacheQuery.h
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  SDK 缓存查询选项
 */
@interface HEResourceQueryOption : NSObject

/**
 *  查询的缓存文件类型，类型为文件后缀的集合。
 *  默认为 nil ，不分类型查询所有文件缓存。
 */
@property (nonatomic, copy, nullable) NSArray<NSString *> *extensions;

/**
 *  当前时间往前多少时间之前所有的消息,默认为 7 天之前。
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;


@end


/**
 *  SDK 缓存查询结果
 */
@interface HECacheQueryResult : NSObject

/**
 *  文件路径
 */
@property (nonatomic, copy, readonly) NSString *path;

/**
 *  文件的创建日期
 */
@property (nonatomic, strong, readonly) NSDate *creationDate;

/**
 *  文件的大小，单位为 bytes
 */
@property (nonatomic, assign, readonly) long long fileLength;


@end

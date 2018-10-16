//
//  MD5Tool.h
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MD5Tool : NSObject


/**
 生成data的md5值

 @param data “”
 @return 返回data的MD5哈希值，长度32，大写
 */
+ (NSString *)md5OfData:(NSData *)data;

/**
 生成字符串的md5值

 @param string 字符串
 @return 返回字符串的md5
 */
+ (NSString *)md5OfStr:(NSString *)string;

/**
 生成指定file的md5

 @param filePath 文件路径
 @return MD5哈希值，长度32，大写
 */
+ (NSString *)md5OfFile:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END

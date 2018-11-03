//
//  HEBaseEncoder.h
//  IM
//
//  Created by jmhe on 2018/11/2.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  编码器基类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HEBaseEncoder : NSObject

/**
 下个个编码器
 */
@property(nonatomic,strong)HEBaseEncoder *next;

/**
 编码

 @param packet  待编码数据
 @param error   编码过程报错
 @return        编码后数据
 */
- (id)encode:(id)packet error:(NSError *__autoreleasing *)error;


/**
 创建编码错误

 @param msg 出错原因
 @return error object
 */
- (NSError *)createEncodeErrorWithMessage:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END

//
//  HEBaseDecoder.h
//  IM
//
//  Created by jmhe on 2018/11/2.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  解码器基类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HEBaseDecoder : NSObject

/**下一个解码器*/
@property(nonatomic,strong)HEBaseDecoder *next;

/**
 解码

 @param packet  待解码数据
 @param decodeLength    以解码的数据长度
 @param error   解码过程出错
 @return        解码后数据
 */
- (id)decodePacket:(id)packet decodeLength:(int *)decodeLength error:(NSError*__autoreleasing *)error;

/**
 创建编码错误
 
 @param msg 出错原因
 @return error object
 */
- (NSError *)createDecodeErrorWithMessage:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END

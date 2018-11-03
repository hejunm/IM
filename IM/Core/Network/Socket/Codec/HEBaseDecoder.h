//
//  HEBaseDecoder.h
//  IM
//
//  Created by jmhe on 2018/11/2.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  解码器基类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HEDecoderOutputProtocol <NSObject>
- (void)didDecode:(id)decodedPacket;
@end

@interface HEBaseDecoder : NSObject

/**下一个解码器*/
@property(nonatomic,strong)HEBaseDecoder *next;

/**
 解码

 @param packet  
 @param decodeLength    以解码的数据长度
 @param error   解码过程出错
 @return        解码后数据（如果沾包，可能会拆出多个包（在NSArray））
 */

/**
 解码
 TODO:出错后应该怎么处理？ 
 @param packet 待解码数据
 @param output 解码完成后分发的对象
 @param error 解码异常
 @return 解码长度  0数据不完整 等待数据包,或解析出错; >0解码正常，为已解码数据长度
 解码链中第一个decoder完成拆包操作，并且需要返回解码长度。
 之后的decoder收到的是一个单独的包，不需要返回解码长度。
 */
- (NSInteger)decodePacket:(id)packet output:(id<HEDecoderOutputProtocol>)output error:(NSError*__autoreleasing *)error;

/**
 创建编码错误
 @param code 错误码
 @param msg 出错原因
 @return error object
 */
- (NSError *)createDecodeErrorWithCode:(NSInteger)code message:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END

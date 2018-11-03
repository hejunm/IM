//
//  HEProtobufVarint32LengthEncoder.h
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//
/**
 *  protobuf编码器
 *  头部为［1～5］个字节的长度字段，后面紧跟protobuf的压缩数据
 *
 *  对应netty的pipeline.addLast("frameEncoder", new ProtobufVarint32LengthFieldPrepender());编码器
 */

#import "HEBaseEncoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface HEProtobufVarint32LengthEncoder : HEBaseEncoder
/**
 *  应用协议中允许发送的最大数据块大小，默认为INT32_MAX
 */
@property (nonatomic, assign) NSUInteger maxFrameSize;

@end

NS_ASSUME_NONNULL_END

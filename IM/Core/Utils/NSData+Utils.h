//
//  NSData+Utils.h
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Utils)

/**
 *  反转字节序列
 *
 *  @param srcData 原始字节NSData
 *
 *  @return 反转序列后字节NSData
 */
+ (NSData *)dataWithReverse:(NSData *)srcData;

/** 将数值转成字节。编码方式：低位在前，高位在后 */
+ (NSData *)byteFromInt8:(int8_t)val;
+ (NSData *)bytesFromInt16:(int16_t)val;
+ (NSData *)bytesFromInt32:(int32_t)val;
+ (NSData *)bytesFromInt64:(int64_t)val;
+ (NSData *)bytesFromValue:(int64_t)value byteCount:(int)byteCount;
+ (NSData *)bytesFromValue:(int64_t)value byteCount:(int)byteCount reverse:(BOOL)reverse;

/** 将字节转成数值。解码方式：前序字节为低位，后续字节为高位 */
+ (int8_t)int8FromBytes:(NSData *)data;
+ (int16_t)int16FromBytes:(NSData *)data;
+ (int32_t)int32FromBytes:(NSData *)data;
+ (int64_t)int64FromBytes:(NSData *)data;
+ (int64_t)valueFromBytes:(NSData *)data;
+ (int64_t)valueFromBytes:(NSData *)data reverse:(BOOL)reverse;


/** 数据长度编码成可变长度data*/
+ (NSData *)dataWithRawVarint32:(int64_t)value;
+ (int64_t)valueWithVarint32Data:(NSData *)data;
/**
 *  计算出一帧数据的长度字节个数 （Varint32格式的长度） (1～5)
 *  @param frameData 待解码字节
 *  @return 返回一帧数据的长度 字节个数, varint32, 返回值为1～5有效，－1为计算失败
 */
+ (NSInteger)computeCountOfLengthByte:(NSData *)frameData;

// Return line separators.
+ (NSData *)CRLFData;
+ (NSData *)CRData;
+ (NSData *)LFData;
+ (NSData *)ZeroData;


@end

NS_ASSUME_NONNULL_END

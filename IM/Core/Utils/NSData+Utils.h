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
#pragma mark - 定长
+ (NSData *)dataFromInteger4:(uint32_t)integer;
+ (uint32_t)integer4FromData:(NSData *)data;

#pragma mark - 变长 Varint32
/** 数据长度编码成可变长度data*/
+ (NSData *)dataWithRawVarint32:(int64_t)value;
+ (int64_t)valueWithVarint32Data:(NSData *)data;
/**
 *  计算出一帧数据的长度字节个数 （Varint32格式的长度） (1～5)
 *  @param frameData 待解码字节
 *  @return 返回一帧数据的长度 字节个数, varint32, 返回值为1～5有效，－1为计算失败
 */
+ (NSInteger)computeCountOfLengthByte:(NSData *)frameData;

#pragma mark - 

@end

NS_ASSUME_NONNULL_END

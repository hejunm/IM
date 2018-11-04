//
//  NSData+Utils.m
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "NSData+Utils.h"

@implementation NSData (Utils)


/**
 *  反转字节序列
 *
 *  @param srcData 原始字节NSData
 *
 *  @return 反转序列后字节NSData
 */
+ (NSData *)dataWithReverse:(NSData *)srcData
{
    //    NSMutableData *dstData = [[NSMutableData alloc] init];
    //    for (NSUInteger i=0; i<srcData.length; i++) {
    //        [dstData appendData:[srcData subdataWithRange:NSMakeRange(srcData.length-1-i, 1)]];
    //    }//for
    
    NSUInteger byteCount = srcData.length;
    NSMutableData *dstData = [[NSMutableData alloc] initWithData:srcData];
    NSUInteger halfLength = byteCount / 2;
    for (NSUInteger i=0; i<halfLength; i++) {
        NSRange begin = NSMakeRange(i, 1);
        NSRange end = NSMakeRange(byteCount - i - 1, 1);
        NSData *beginData = [srcData subdataWithRange:begin];
        NSData *endData = [srcData subdataWithRange:end];
        [dstData replaceBytesInRange:begin withBytes:endData.bytes];
        [dstData replaceBytesInRange:end withBytes:beginData.bytes];
    }//for
    
    return dstData;
}

+ (NSData *)byteFromUInt8:(uint8_t)val
{
    NSMutableData *valData = [[NSMutableData alloc] init];
    [valData appendBytes:&val length:1];
    return valData;
}

+ (NSData *)bytesFromUInt16:(uint16_t)val
{
    NSMutableData *valData = [[NSMutableData alloc] init];
    [valData appendBytes:&val length:2];
    return valData;
}

+ (NSData *)bytesFromUInt32:(uint32_t)val
{
    NSMutableData *valData = [[NSMutableData alloc] init];
    [valData appendBytes:&val length:4];
    return valData;
}

+ (NSData *)bytesFromUInt64:(uint64_t)val
{
    NSMutableData *tempData = [[NSMutableData alloc] init];
    [tempData appendBytes:&val length:8];
    return tempData;
}

+ (NSData *)bytesFromValue:(uint64_t)value byteCount:(int)byteCount
{
    NSMutableData *valData = [[NSMutableData alloc] init];
    int64_t tempVal = value;
    int offset = 0;
    
    while (offset < byteCount) {
        unsigned char valChar = 0xff & tempVal;
        [valData appendBytes:&valChar length:1];
        tempVal = tempVal >> 8;
        offset++;
    }//while
    
    return valData;
}

+ (NSData *)bytesFromValue:(uint64_t)value byteCount:(int)byteCount reverse:(BOOL)reverse
{
    NSData *tempData = [self bytesFromValue:value byteCount:byteCount];
    if (reverse) {
        return tempData;
    }
    
    return [self dataWithReverse:tempData];
}

+ (uint8_t)uint8FromBytes:(NSData *)data
{
    NSAssert(data.length >= 1, @"uint8FromBytes: (data length < 1)");
    
    int8_t val = 0;
    [data getBytes:&val length:1];
    return val;
}

+ (uint16_t)uint16FromBytes:(NSData *)data
{
    NSAssert(data.length >= 2, @"uint16FromBytes: (data length < 2)");
    
    int16_t val = 0;
    [data getBytes:&val length:2];
    return val;
}

+ (uint32_t)uint32FromBytes:(NSData *)data
{
    NSAssert(data.length >= 4, @"uint16FromBytes: (data length < 4)");
    
    int32_t val = 0;
    [data getBytes:&val length:4];
    return val;
}

+ (uint64_t)uint64FromBytes:(NSData *)data
{
    NSAssert(data.length >= 8, @"uint16FromBytes: (data length < 8)");
    
    int64_t val = 0;
    [data getBytes:&val length:8];
    return val;
}

+ (uint64_t)valueFromBytes:(NSData *)data
{
    NSUInteger dataLen = data.length;
    int64_t value = 0;
    int offset = 0;
    
    while (offset < dataLen) {
        int32_t tempVal = 0;
        [data getBytes:&tempVal range:NSMakeRange(offset, 1)];
        value += (tempVal << (8 * offset));
        offset++;
    }//while
    
    return value;
}

+ (uint64_t)valueFromBytes:(NSData *)data reverse:(BOOL)reverse
{
    NSData *tempData = data;
    if (reverse) {
        tempData = [self dataWithReverse:tempData];
    }
    return [self valueFromBytes:tempData];
}

#pragma mark - 变长 Varint32
+ (NSData *)dataWithRawVarint32:(uint64_t)value{
    NSMutableData *valData = [[NSMutableData alloc] init];
    while (true) {
        if ((value & ~0x7F) == 0) {//如果最高位是0，只要一个字节表示
            [valData appendBytes:&value length:1];
            break;
        } else {
            int valChar = (value & 0x7F) | 0x80;//先写入低7位，最高位置1
            [valData appendBytes:&valChar length:1];
            value = value >> 7;//再写高7位
        }
    }
    return valData;
}

+ (uint64_t)valueWithVarint32Data:(NSData *)data{
    NSUInteger dataLen = data.length;
    int64_t value = 0;
    int offset = 0;
    
    while (offset < dataLen) {
        int32_t tempVal = 0;
        [data getBytes:&tempVal range:NSMakeRange(offset, 1)];
        tempVal = (tempVal & 0x7F);
        value += (tempVal << (7 * offset));
        offset++;
    }//while
    
    return value;
}

+ (NSInteger)computeCountOfLengthByte:(NSData *)frameData{
    //默认长度字节个数为－1
    NSInteger countOfLengthByte = -1;
    //最大尝试读区个数为4个字节，超过则认为是大数据5个字节
    NSInteger maxCountOfLengthByte = MIN(frameData.length, 4);
    //从第1个字节开始尝试读取计算
    NSInteger testIndex = 0;
    
    while (testIndex < maxCountOfLengthByte) {
        NSRange lengthRange = NSMakeRange(testIndex, 1);
        NSData *oneByte = [frameData subdataWithRange:lengthRange];
        int8_t oneValue = [self uint8FromBytes:oneByte];
        
        if ((oneValue & 0x80) == 0) {
            countOfLengthByte = testIndex + 1;
            break;
        }
        testIndex++;//增加长度字节个数
    }//while
    
    //超过4个字节，则认为是大数据5个字节
    if (testIndex >= 4) {
        countOfLengthByte = 5;
    }
    return countOfLengthByte;
}

#pragma mark - 分割符
+ (NSData *)CRLFData{
    return [NSData dataWithBytes:"\x0D\x0A" length:2];
}

+ (NSData *)CRData{
    return [NSData dataWithBytes:"\x0D" length:1];
}

+ (NSData *)LFData{
    return [NSData dataWithBytes:"\x0A" length:1];
}

+ (NSData *)ZeroData{
    return [NSData dataWithBytes:"" length:1];
}
@end

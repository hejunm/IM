//
//  NSData+Utils.m
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "NSData+Utils.h"

@implementation NSData (Utils)

+ (uint32_t)integer4FromData:(NSData *)data {
    char *dataChar = (char *)data.bytes;
    char *index = (char *)&dataChar;
    char typeChar[4] = {0};
    for (int i = 0 ; i < data.length; i++) {
        typeChar[4 - 1 - i] = dataChar[i];
        index ++;
    }
    uint32_t integer;
    NSData *typeData = [NSData dataWithBytes:typeChar length:4];
    [typeData getBytes:&integer length:4];
    return integer;
}

+ (NSData *)dataFromInteger4:(uint32_t)integer {
    
    uint32_t time = integer;
    char *p_time = (char *)&time;
    static char str_time[4] = {0};
    for(int i = 4 - 1; i >= 0; i--) {
        str_time[i] = *p_time;
        p_time ++;
    }
    return [NSData dataWithBytes:&str_time length:4];
}

+ (NSData *)dataWithRawVarint32:(int64_t)value{
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

+ (int64_t)valueWithVarint32Data:(NSData *)data{
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
        int8_t oneValue = [self int8FromBytes:oneByte];
        
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

+ (int8_t)int8FromBytes:(NSData *)data{
    NSAssert(data.length >= 1, @"uint8FromBytes: (data length < 1)");
    
    int8_t val = 0;
    [data getBytes:&val length:1];
    return val;
}
@end

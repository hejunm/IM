//
//  HEProtobufVarint32LengthDecoder.m
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEProtobufVarint32LengthDecoder.h"
#import "NSData+Utils.h"

@implementation HEProtobufVarint32LengthDecoder

- (instancetype)init{
    if (self = [super init]) {
        _maxFrameSize = INT32_MAX;
    }
    return self;
}
- (NSUInteger)decodePacket:(id)packet output:(id<HEDecoderOutputProtocol>)output error:(NSError*__autoreleasing *)error{
    if (![packet isKindOfClass:[NSData class]]) {
        NSAssert(NO, @"HEProtobufVarint32LengthDecoder packet must be a NSData object");
        if (error != NULL ){
            *error = [self createDecodeErrorWithCode:1 message:@"HEProtobufVarint32LengthDecoder packet must be a NSData object!"];
        }
        return 0;
    }
    
    NSData *downstreamData = (NSData *)packet;
    NSUInteger headIndex = 0;
    
    while (downstreamData && downstreamData.length - headIndex > 1) {
        NSRange remainRange = NSMakeRange(headIndex, downstreamData.length - headIndex);
        NSData *remainData = [downstreamData subdataWithRange:remainRange];
        
        NSInteger countOfLengthByte = [NSData computeCountOfLengthByte:remainData];
        if (countOfLengthByte <= 0) { //获取不到长度信息
            break;
        }
        
        //长度字节数据，存在高低位互换，通过数值转换工具处理
        NSData *lenData = [downstreamData subdataWithRange:NSMakeRange(headIndex, countOfLengthByte)];
        NSUInteger frameLen = (NSUInteger)[NSData valueWithVarint32Data:lenData];
        if (frameLen >= _maxFrameSize - countOfLengthByte) {
            *error = [self createDecodeErrorWithCode:1 message:@"[Decode] Too Long Frame ..."];
            return 0;
        }
        
        //剩余数据，不是完整的数据包，则break继续读取等待
        if (downstreamData.length - headIndex < countOfLengthByte + frameLen) {
            break;
        }
        //数据包(长度＋内容)
        NSData *frameData = [downstreamData subdataWithRange:NSMakeRange(headIndex, countOfLengthByte + frameLen)];
        //去除数据长度后的数据内容
        NSData *contentData = [frameData subdataWithRange:NSMakeRange(countOfLengthByte, frameLen)];
        
        //解码链，交给下一步处理
        if (self.next) {
            [self.next decodePacket:contentData output:output error:error];
        }else{
            [output didDecode:contentData];
        }
        
        //调整已经解码数据
        headIndex += frameData.length;
    }//while
    
    return headIndex;
}
@end

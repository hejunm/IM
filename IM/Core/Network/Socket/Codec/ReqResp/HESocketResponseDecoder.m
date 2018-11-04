//
//  HESocketResponseDecoder.m
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketResponseDecoder.h"
#import "NSData+Utils.h"
#import "HESocketResponse.h"

@implementation HESocketResponseDecoder

- (NSUInteger)decodePacket:(id)packet output:(id<HEDecoderOutputProtocol>)output error:(NSError * _Nullable __autoreleasing *)error{
    if (![packet isKindOfClass:[NSData class]]) {
        NSAssert(NO, @"HESocketResponseDecoder packet must be a NSData object");
        return 0;
    }
    NSData *downstreamData = packet;
    NSUInteger headIndex = 0;
    //apiCode,4字节
    //taskId,4字节
    //有效载荷长度,4字节
    //有效载荷
    NSInteger headerLength = 12;
    while (downstreamData && downstreamData.length - headIndex >= headerLength) {
        
        NSData *headData = [downstreamData subdataWithRange:NSMakeRange(headIndex, headerLength)];
        NSData *contentLengthData = [headData subdataWithRange:NSMakeRange(8, 4)];
        NSUInteger contentLength = [NSData uint32FromBytes:contentLengthData];
        
        //剩余数据，不是完整的数据包，则break继续读取等待
        if (downstreamData.length - headIndex < headerLength + contentLength) {
            break;
        }
        
        //内容
        NSData *contentData = [downstreamData subdataWithRange:NSMakeRange(headIndex + headerLength,contentLength)];
        
        //去除数据长度后的数据内容
        HESocketResponse *resp = [[HESocketResponse alloc] init];
        resp.apiCode = [NSData uint32FromBytes:[headData subdataWithRange:NSMakeRange(0, 4)]];
        resp.taskId = [NSData uint32FromBytes:[headData subdataWithRange:NSMakeRange(4, 4)]];
        resp.content = contentData;
        if (self.next) {
            [self.next decodePacket:resp output:output error:error];
        }else{
            [output didDecode:resp];
        }
        //调整已经解码数据
        headIndex += (headerLength + contentLength);
    }//while
    return headIndex;
}
@end

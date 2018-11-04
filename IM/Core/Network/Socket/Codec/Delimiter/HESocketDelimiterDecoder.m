//
//  HESocketDelimiterDecoder.m
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketDelimiterDecoder.h"
#import "NSData+Utils.h"

@implementation HESocketDelimiterDecoder

- (instancetype)init{
    if (self = [super init]) {
        _delimiterData = [NSData CRLFData];
        _maxFrameSize = 8192;
    }
    return self;
}

- (instancetype)initWithDelimiterData:(NSData *)delimiterData maxFrameSize:(NSUInteger)maxFrameSize{
    if (self = [super init]) {
        _delimiterData = delimiterData;
        _maxFrameSize = maxFrameSize;
    }
    return self;
}

-(NSUInteger)decodePacket:(id)packet output:(id<HEDecoderOutputProtocol>)output error:(NSError * _Nullable __autoreleasing *)error{
    if (![packet isKindOfClass:[NSData class]]) {
        NSAssert(NO, @"HESocketDelimiterDecoder packet must be a NSData object");
//        if ( error != NULL ){
//            *error = [self createDecodeErrorWithCode:1 message:@"HESocketDelimiterEncoder packet must be a NSData object!"];
//        }
        return 0;
    }
    
    NSData *downstreamData = packet;
    NSUInteger dataLen = downstreamData.length;
    NSUInteger headIndex = 0;
    while (YES) {
        //根据分隔符，获取一块数据包，类似得到一句完整的句子。然后output，触发上层逻辑
        NSRange range = NSMakeRange(headIndex, dataLen - headIndex);
        NSRange resultRange = [downstreamData rangeOfData:_delimiterData options:0 range:range];
        if (resultRange.length == 0) {
            break;
        }
        //去除分隔符后的数据包
        NSInteger frameLen = resultRange.location - headIndex;
        NSData *frameData = [downstreamData subdataWithRange:NSMakeRange(headIndex, frameLen)];
        if (frameLen > _maxFrameSize) {
            /**
             接受到的数据超过规定大小，埋点上传。
             发送数据大小可以在发送端限制，如果接受到的数据超过规定大小，不算错误，正常处理。
             */
            DebugLog(@"HESocketDelimiterDecoder 单个数据包偏大");
        }
        if (self.next) {
            [self.next decodePacket:frameData output:output error:error];
        }else{
            [output didDecode:frameData];
        }
        headIndex = resultRange.location + resultRange.length;
    }
    return headIndex;
}
@end

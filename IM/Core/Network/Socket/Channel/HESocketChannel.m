//
//  HESocketChannel.m
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketChannel.h"
#import "HESocketDelimiterDecoder.h"
#import "HESocketResponseDecoder.h"

@interface HESocketChannel()<HEDecoderOutputProtocol>
@property(nonatomic,strong)NSMutableData *receiveDataBuffer;
@end

@implementation HESocketChannel
@dynamic delegate;


- (instancetype)initWithConnectParam:(HESocketConnectParam *)connectParam{
    if ([super initWithConnectParam:connectParam]) {
        HESocketResponseDecoder *responseDecoder = [[HESocketResponseDecoder alloc]init];
        HESocketDelimiterDecoder *delimiterDecoder = [[HESocketDelimiterDecoder alloc]init];
        delimiterDecoder.next = responseDecoder;
        self.decoder = delimiterDecoder;
        self.receiveDataBuffer = [[NSMutableData alloc]init];
    }
    return self;
}

- (void)didReadWithData:(NSData *)data tag:(long)tag{
    [super didReadWithData:data tag:tag];
    if (data.length == 0) {
        return;
    }
    if (self.decoder == nil) {
        NSAssert(NO, @"必须指定解码器");
        return;
    }
    @synchronized(self) {
        [self.receiveDataBuffer appendData:data];
        NSError *error;
        NSInteger decodedLength = [self.decoder decodePacket:self.receiveDataBuffer output:self error:&error];
        if (decodedLength == 0) {
            if (error) {
                NSAssert(NO, @"解码出错 %@",error);
                
                //其他错误处理
            }
            return;
        }
        
        NSUInteger remainLength = self.receiveDataBuffer.length - decodedLength;
        NSData *remainData = [self.receiveDataBuffer subdataWithRange:NSMakeRange(decodedLength, remainLength)];
        [self.receiveDataBuffer setData:remainData];
    }
}

#pragma mark - HEDecoderOutputProtocol
- (void)didDecode:(id)decodedPacket{
    //通过HESocketDelimiterDecoder，HESocketResponseDecoder 解析出的HESocketResponse。
    if ([decodedPacket isKindOfClass:[HESocketResponse class]]) {
        [self.delegate channel:self receivedPacket:decodedPacket];
    }else{
        //解析出的其他类型。目前只有上面一种。
    }
}
@end

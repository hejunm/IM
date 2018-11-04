//
//  HEBaseDecoder.m
//  IM
//
//  Created by jmhe on 2018/11/2.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEBaseDecoder.h"

@implementation HEBaseDecoder

- (NSInteger)decodePacket:(id)packet output:(id<HEDecoderOutputProtocol>)output error:(NSError*__autoreleasing *)error{
    return 0;
}


- (NSError *)createDecodeErrorWithCode:(NSInteger)code message:(NSString *)msg{
    NSDictionary *userInfo = @{@"msg":msg?:@""};
    return  [NSError errorWithDomain:@"DecodeErrorDomain" code:code userInfo:userInfo];
}
@end

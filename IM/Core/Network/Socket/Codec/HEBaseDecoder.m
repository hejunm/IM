//
//  HEBaseDecoder.m
//  IM
//
//  Created by jmhe on 2018/11/2.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HEBaseDecoder.h"

@implementation HEBaseDecoder
- (id)decodePacket:(id)packet decodeLength:(int *)decodeLength error:(NSError*__autoreleasing *)error{
    return nil;
}

- (NSError *)createDecodeErrorWithMessage:(NSString *)msg{
    NSDictionary *userInfo = @{@"msg":msg?:@""};
    return  [NSError errorWithDomain:@"DecodeErrorDomain" code:1 userInfo:userInfo];
 
}
@end

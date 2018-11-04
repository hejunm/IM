//
//  HESocketRequestEncoder.m
//  IM
//
//  Created by wulixiwa on 2018/11/3.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketRequestEncoder.h"
#import "HEReqBase.h"
#import "NSData+Utils.h"

@implementation HESocketRequestEncoder

- (id)encode:(id)packet error:(NSError * _Nullable __autoreleasing *)error{
    if (![packet conformsToProtocol:@protocol(HESocketReqProtocol)]) {
        NSAssert(NO, @"HESocketRequestEncoder packet must conformsToProtocol HESocketReqProtocol!");
        if ( error != NULL ){
            *error = [self createEncodeErrorWithCode:1 message:@"HESocketRequestEncoder packet must conformsToProtocol HESocketReqProtocol!"];
        }
        return nil;
    }
 
    id<HESocketReqProtocol>request = packet;
    NSData *content = [request serializeToData];
    NSMutableData *sendData = [[NSMutableData alloc]init];
    
    //apiCode,4字节
    uint32_t apiCode = [request apiCode];
    [sendData appendData:[NSData bytesFromUInt32:apiCode]];
    
    //taskId,4字节
     uint32_t taskId = [request taskId];
    [sendData appendData:[NSData bytesFromUInt32:taskId]];
    
    //有效载荷长度,4字节
    uint32_t contentLength = (uint32_t)content.length;
    [sendData appendData:[NSData bytesFromUInt32:contentLength]];
    
    //有效载荷
    [sendData appendData:content];
    if (self.next) {
        return [self.next encode:sendData error:error];
    }else{
        return sendData;
    }
}
@end

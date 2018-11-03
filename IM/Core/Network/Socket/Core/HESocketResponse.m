//
//  HESocketResponse.m
//  IM
//
//  Created by jmhe on 2018/10/18.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketResponse.h"
#import "NSData+Utils.h"

@implementation HESocketResponse

@end


#define HESocketResponseApiCodeLength (4)  /** 接口code长度 */
#define HESocketResponseReqIdLength (4)    /** 主动发起 请求id长度 */
#define HESocketResponseAckIdLength (4)    /** 响应id的长度 */
#define HESocketResponseContentLength (4)  /** 消息有效载荷的长度 */
#define HESocketResponseHeaderLength (HESocketResponseApiCodeLength + HESocketResponseReqIdLength + HESocketResponseAckIdLength + HESocketResponseContentLength)/** 消息响应的头部长度 */

@implementation HESocketResponseParser
+ (uint32_t)responseHeaderLength{
    return HESocketResponseHeaderLength;
}

+ (uint32_t)apiCodeFromData:(NSData *)data{
    return [NSData integer4FromData:[data subdataWithRange:NSMakeRange(0, HESocketResponseApiCodeLength)]];
}

+ (uint32_t)reqIdFromData:(NSData *)data{
    return [NSData integer4FromData:[data subdataWithRange:NSMakeRange(HESocketResponseApiCodeLength, HESocketResponseReqIdLength)]];
}

+ (uint32_t)ackIdFromData:(NSData *)data{
    return [NSData integer4FromData:[data subdataWithRange:NSMakeRange(HESocketResponseApiCodeLength + HESocketResponseReqIdLength, HESocketResponseAckIdLength)]];
}

+ (uint32_t)contentLengthFromData:(NSData *)data{
    return [NSData integer4FromData:[data subdataWithRange:NSMakeRange(HESocketResponseApiCodeLength + HESocketResponseReqIdLength + HESocketResponseAckIdLength, HESocketResponseContentLength)]];
}

+ (NSData *)responseContentFromData:(NSData *)data{
    return [data subdataWithRange:NSMakeRange(HESocketResponseHeaderLength, data.length-HESocketResponseHeaderLength)];
}
@end

//
//  HETCPResponseEntity.m
//  IM
//
//  Created by jmhe on 2018/10/18.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HETCPResponseEntity.h"
#import "HEDataFormatter.h"

@implementation HETCPResponseEntity

@end


#define HETCPResponseApiCodeLength (4)  /** 接口code长度 */
#define HETCPResponseReqIdLength (4)    /** 主动发起 请求id长度 */
#define HETCPResponseAckIdLength (4)    /** 响应id的长度 */
#define HETCPResponseContentLength (4)  /** 消息有效载荷的长度 */
#define HETCPResponseHeaderLength (HETCPResponseApiCodeLength + HETCPResponseReqIdLength + HETCPResponseAckIdLength + HETCPResponseContentLength)/** 消息响应的头部长度 */

@implementation HETCPResponseParser
+ (uint32_t)responseHeaderLength{
    return HETCPResponseHeaderLength;
}

+ (uint32_t)apiCodeFromData:(NSData *)data{
    return [HEDataFormatter integer4FromData:[data subdataWithRange:NSMakeRange(0, HETCPResponseApiCodeLength)]];
}

+ (uint32_t)reqIdFromData:(NSData *)data{
    return [HEDataFormatter integer4FromData:[data subdataWithRange:NSMakeRange(HETCPResponseApiCodeLength, HETCPResponseReqIdLength)]];
}

+ (uint32_t)ackIdFromData:(NSData *)data{
    return [HEDataFormatter integer4FromData:[data subdataWithRange:NSMakeRange(HETCPResponseApiCodeLength + HETCPResponseReqIdLength, HETCPResponseAckIdLength)]];
}

+ (uint32_t)contentLengthFromData:(NSData *)data{
    return [HEDataFormatter integer4FromData:[data subdataWithRange:NSMakeRange(HETCPResponseApiCodeLength + HETCPResponseReqIdLength + HETCPResponseAckIdLength, HETCPResponseContentLength)]];
}

+ (NSData *)responseContentFromData:(NSData *)data{
    return [data subdataWithRange:NSMakeRange(HETCPResponseHeaderLength, data.length-HETCPResponseHeaderLength)];
}
@end

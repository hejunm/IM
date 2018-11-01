//
//  HESocketResponse.h
//  IM
//
//  Created by jmhe on 2018/10/18.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HESocketResponse : NSObject

/**
 类似http中的url，标示某个接口
 */
@property(nonatomic,assign)NSUInteger apiCode;

/**标记某个请求 服务器主动发起请求时*/
@property(nonatomic,assign)uint32_t reqId;

/**
 标记某个请求对应的响应 与request的reqId一致
 如果是服务器主动发的请求，则为0
 */
@property(nonatomic,assign)NSUInteger ackId;

/**
 消息长度
 */
@property(nonatomic,assign)NSUInteger contentLength;

/**
 响应消息内容
 */
@property(nonatomic,strong)NSData *content;

@end

@interface HESocketResponseParser : NSObject
+ (uint32_t)responseHeaderLength;
+ (uint32_t)apiCodeFromData:(NSData *)data;
+ (uint32_t)reqIdFromData:(NSData *)data;
+ (uint32_t)ackIdFromData:(NSData *)data;
+ (uint32_t)contentLengthFromData:(NSData *)data;
+ (NSData *)responseContentFromData:(NSData *)data;
@end


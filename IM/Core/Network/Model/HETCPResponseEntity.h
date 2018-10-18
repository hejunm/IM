//
//  HETCPResponseEntity.h
//  IM
//
//  Created by jmhe on 2018/10/18.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HETCPRespContentProtocol <NSObject>
@end

@interface HETCPResponseEntity : NSObject

/**
 类似http中的url，标示某个接口
 */
@property(nonatomic,assign,readonly)NSUInteger apiCode;

/**
 标记某个请求
 如果是服务器主动发的请求，则为0
 */
@property(nonatomic,assign,readonly)NSUInteger reqId;

/**
 消息长度
 */
@property(nonatomic,assign,readonly)NSUInteger contentLength;

/**
 响应消息内容
 */
@property(nonatomic,strong)id<HETCPRespContentProtocol> reqContent;

@end

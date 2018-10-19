//
//  HETCPRequestEntity.h
//  IM
//
//  Created by jmhe on 2018/10/18.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HETCPReqContentProtocol <NSObject>
- (NSUInteger)apiCode;
- (NSData *)serializeToData;
- (NSString *)responseClassName;
@end

@interface HETCPRequestEntity : NSObject

/**
 类似http中的url，标示某个接口
 */
@property(nonatomic,assign,readonly)NSUInteger apiCode;

/**
 标记某个请求
 TCP响应回传该字段，用于将请求和响应map
 */
@property(nonatomic,assign,readonly)NSUInteger reqId;

/**
 消息长度
 */
@property(nonatomic,assign,readonly)NSUInteger contentLength;

/**
 发送消息内容
 */
@property(nonatomic,strong)id<HETCPReqContentProtocol> content;
@end

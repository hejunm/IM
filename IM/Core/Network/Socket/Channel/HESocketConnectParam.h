//
//  HESocketConnectParam.h
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HESocketConnectPolicy;
@class HESocketHeartbeatPolicy;

@interface HESocketConnectParam : NSObject

/**
 *  连接服务器的domain或ip
 */
@property (nonatomic, copy) NSString *host;

/**
 *  连接服务器的端口
 */
@property (nonatomic, assign) int port;

/**
 链接策略(包括重连)
 */
@property(nonatomic,strong)HESocketConnectPolicy *connectPolicy;

/**
 *  心跳策略
 */
@property(nonatomic,strong)HESocketHeartbeatPolicy *heartbeatPolicy;

/**
 *  是否使用安全连接，默认为NO
 */
@property (nonatomic, assign) BOOL useSecureConnection;

/**
 *  安全连接的tls配置参数
 */
@property (nonatomic, strong) NSDictionary *tlsSettings;

@end

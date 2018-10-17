//
//  HELoginClient.h
//  IM
//
//  Created by jmhe on 2018/10/16.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  客户端类型
 */
typedef NS_ENUM(NSInteger, HELoginClientType) {
    
    /**
     *  未知类型
     */
    HELoginClientTypeUnknown    = 0,
    /**
     *  Android
     */
    HELoginClientTypeAOS         = 1,
    /**
     *  iOS
     */
    HELoginClientTypeiOS         = 2,
    /**
     *  PC
     */
    HELoginClientTypePC          = 4,
    /**
     *  WP
     */
    HELoginClientTypeWP          = 8,
    /**
     *  WEB
     */
    HELoginClientTypeWeb         = 16,
    /**
     *  REST API
     */
    HELoginClientTypeRestful     = 32,
    /**
     *  macOS
     */
    HELoginClientTypemacOS       = 64,
};


/**
 *  登录客户端描述
 */
@interface HELoginClient : NSObject

/**
 *  类型
 */
@property (nonatomic,assign)HELoginClientType  type;

/**
 *  操作系统
 */
@property (nullable,nonatomic,copy)NSString *os;

/**
 *  登录时间
 */
@property (nonatomic,assign)NSTimeInterval timestamp;
@end

NS_ASSUME_NONNULL_END

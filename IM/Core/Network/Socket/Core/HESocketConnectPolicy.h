//
//  HESocketConnectPolicy.h
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HESocketConnectPolicy : NSObject

/**连接服务器的超时时间（单位秒s），默认为15秒*/
@property (nonatomic, assign) NSTimeInterval timeout;

/**是否重连*/
@property (nonatomic, assign) BOOL canReconnect;

/**每次重试的递增时间*/
@property (nonatomic, assign) NSUInteger connectDelay;

/**最大重试次数*/
@property (nonatomic, assign) NSUInteger maxRetryCount;

/**当前重试次数*/
@property (nonatomic, assign) NSUInteger currentRetryCount;
@end

NS_ASSUME_NONNULL_END

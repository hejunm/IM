//
//  HESocketReconnect.h
//  IM
//
//  Created by jmhe on 2018/10/22.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketModule.h"

@interface HESocketReconnect : HESocketModule
@property (nonatomic, assign) BOOL autoReconnect;
@property (nonatomic, assign) NSUInteger reconnectDelay;    //每次重试的递增时间
@property (nonatomic, assign) NSUInteger maxRetryCount;     //最大重试次数
@property (nonatomic, assign) NSUInteger retryCount         //当前重试次数
@end

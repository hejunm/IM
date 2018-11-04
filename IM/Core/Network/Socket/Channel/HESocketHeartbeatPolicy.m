//
//  HESocketHeartbeatPolicy.m
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//  心跳策略

#import "HESocketHeartbeatPolicy.h"

@implementation HESocketHeartbeatPolicy
- (instancetype)init{
    if (self = [super init]) {
        _enabled = YES;
        _interval = 120;
        _maxRetryCount = 5;
        _currentRetryCount = 0;
        _retryDelay = 10;
    }
    return self;
}
@end

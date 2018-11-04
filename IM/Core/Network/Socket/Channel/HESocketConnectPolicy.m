//
//  HESocketConnectPolicy.m
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketConnectPolicy.h"

@implementation HESocketConnectPolicy
- (instancetype)init{
    if (self = [super init]) {
        _timeout = 15;
        _canReconnect = YES;
        _connectDelay = 2;
        _maxRetryCount = 5;
        _currentRetryCount = 0;
    }
    return self;
}
@end

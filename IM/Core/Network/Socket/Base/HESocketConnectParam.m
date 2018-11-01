//
//  HESocketConnectParam.m
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketConnectParam.h"
#import "HESocketConnectPolicy.h"
#import "HESocketHeartbeatPolicy.h"

@implementation HESocketConnectParam
- (instancetype)init{
    if(self = [super init]){
        _connectPolicy = [[HESocketConnectPolicy alloc]init];
        _heartbeatPolicy = [[HESocketHeartbeatPolicy alloc]init];
        _useSecureConnection = NO;
    }
    return self;
}
@end

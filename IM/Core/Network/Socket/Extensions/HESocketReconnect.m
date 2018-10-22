//
//  HESocketReconnect.m
//  IM
//
//  Created by jmhe on 2018/10/22.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketReconnect.h"
#import "InternetReachabilityTool.h"
#import "HESocketHandler.h"

#define DEFAULT_HE_RECONNECT_DELAY 2.0


@interface HESocketReconnect()
@property(nonatomic,strong) dispatch_source_t reconnectTimer;
@end

@implementation HESocketReconnect

- (instancetype)init{
    if (self = [super init]) {
        self.reconnectDelay = DEFAULT_HE_RECONNECT_DELAY;
        self.maxRetryCount = 5;
        self.retryCount = 0;
        self.autoReconnect = YES;
    }
    return self;
}

- (BOOL)shouldRetry{
    return  self.autoReconnect
            && self.maxRetryCount > 0
            && self.retryCount < self.maxRetryCount
            && [[InternetReachabilityTool shareInstance] isReachable];
}

#pragma mark - HESocketHandlerDelegate
- (void)socketDidDisconnectWithError:(NSError *)error{
    if(![self shouldRetry]){
        return;
    }
    self.retryCount++;
    [self setupReconnectTimer];
}

- (void)socketDidConnectToHost:(NSString *)host port:(uint16_t)port{
    [self reset];
}

#pragma mark - private method
- (void)setupReconnectTimer{
    if (self.reconnectTimer == NULL) {
        self.reconnectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.modultQueue);
    }
    dispatch_source_set_event_handler(self.reconnectTimer, ^{ @autoreleasepool {
        [self maybeAttemptReconnect];
    }});
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, (self.reconnectDelay * NSEC_PER_SEC * self.retryCount));
    //设置给timer
    dispatch_source_set_timer(self.reconnectTimer, startTime, DISPATCH_TIME_FOREVER, 0.25);
    //开启定时器
    dispatch_resume(self.reconnectTimer);
}

- (void)teardownReconnectTimer{
    NSAssert(dispatch_get_specific(moduleQueueTag) , @"Invoked on incorrect queue");
    if (self.reconnectTimer){
        dispatch_source_cancel(self.reconnectTimer);
        self.reconnectTimer = NULL;
    }
}

- (void)reset{
    
    
    self.retryCount = 0;
    [self teardownReconnectTimer];
}

- (void)maybeAttemptReconnect{
    if (self.socketHandler.isConnected) {
        return;
    }
    [self.socketHandler tryToReconnect];
}

@end

//
//  HESocketConnection.m
//  IM
//
//  Created by jmhe on 2018/11/1.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketConnection.h"
#import "HESocketConnectParam.h"
#import "GCDAsyncSocket.h"
#import "HESocketConnectPolicy.h"
#import "HESocketHeartbeatPolicy.h"
#import "NSTimer+BlockSupport.h"

@interface HESocketConnection()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) HESocketConnectParam *connectParam;

@property (nonatomic, strong)   dispatch_queue_t socketQueue;
@property (nonatomic, assign)   void *IsOnSocketQueueOrTargetQueueKey;
@property (nonatomic, strong)   GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong)   NSTimer *reconnectTimer;   //重连计时器
@property (nonatomic, strong)   NSTimer *heartbeatTimer;   //心跳计时器
@end

@implementation HESocketConnection

- (instancetype)initWithConnectParam:(HESocketConnectParam *)connectParam{
    if (self = [super init]) {
        
        const char *socketQueueLabel = [[NSString stringWithFormat:@"%p_socketQueue", self] cStringUsingEncoding:NSUTF8StringEncoding];
        _socketQueue = dispatch_queue_create(socketQueueLabel, DISPATCH_QUEUE_SERIAL);
        _IsOnSocketQueueOrTargetQueueKey = &_IsOnSocketQueueOrTargetQueueKey;
        void *nonNullUnusedPointer = (__bridge void *)self;
        dispatch_queue_set_specific(_socketQueue, _IsOnSocketQueueOrTargetQueueKey, nonNullUnusedPointer, NULL);
        
        _connectParam = connectParam;
    }
    return self;
}

- (void)openConnection{
    NSAssert(self.connectParam.host.length > 0, @"host is nil");
    NSAssert(self.connectParam.port > 0, @"port is 0");
    
    __weak typeof(self) weakSelf = self;
    [self dispatchOnSocketQueue:^{
        [weakSelf disconnect];
        
        weakSelf.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:weakSelf delegateQueue:weakSelf.socketQueue];
        [weakSelf.asyncSocket setIPv4PreferredOverIPv6:NO];
        
        /**
         todo:
         可以配置多个ip， 根据权重排序，然后遍历链接。直到不返回error
         */
        NSError *error = nil;
        [weakSelf.asyncSocket connectToHost:self.connectParam.host onPort:self.connectParam.port withTimeout:self.connectParam.connectPolicy.timeout error:&error];
        if (error) {
            [self didDisconnectWithError:error];
            //上传error信息
        }
    } async:YES];
}

- (void)disconnect{
    __weak typeof(self) weakSelf = self;
    [self dispatchOnSocketQueue:^{
        if (nil == weakSelf.asyncSocket) {
            return;
        }
        weakSelf.asyncSocket.delegate = nil;
        [weakSelf.asyncSocket disconnect];
        weakSelf.asyncSocket = nil;
    } async:YES];
}

- (BOOL)isConnected{
    __block BOOL result = NO;
    __weak typeof(self) weakSelf = self;
    [self dispatchOnSocketQueue:^{
        result = [weakSelf.asyncSocket isConnected];
    } async:NO];
    return result;
}

- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag{
    __weak typeof(self) weakSelf = self;
    [self dispatchOnSocketQueue:^{
        [weakSelf.asyncSocket readDataWithTimeout:timeout tag:tag];
    } async:YES];
}

- (void)writeData:(NSData *)data timeout:(NSTimeInterval)timeout tag:(long)tag{
    __weak typeof(self) weakSelf = self;
    [self dispatchOnSocketQueue:^{
        [weakSelf.asyncSocket writeData:data withTimeout:timeout tag:tag];
    } async:YES];
}


#pragma mark - 回调
- (void)didDisconnectWithError:(NSError *)err{
    [self tryToReconnect];
}

- (void)didConnectToHost:(NSString *)host port:(uint16_t)port{
    //override
}

- (void)didReadWithData:(NSData *)data tag:(long)tag{
    //override
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    [self didDisconnectWithError:err];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    if (self.connectParam.useSecureConnection) {
        [sock startTLS:self.connectParam.tlsSettings];
        return;
    }
    [self didConnectToHost:host port:port];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock{
    [self didConnectToHost:sock.connectedHost port:sock.connectedPort];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [self didReadWithData:data tag:tag];
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:tag];
}

#pragma mark - 重连
- (void)tryToReconnect{
    HESocketConnectPolicy *connectPolicy = self.connectParam.connectPolicy;
    [self stopConnectTimer];
     __weak typeof(self) weakSelf = self;
    if(connectPolicy.canReconnect){
        connectPolicy.currentRetryCount++;
        if (connectPolicy.maxRetryCount > connectPolicy.currentRetryCount) {
            DebugLog(@"达到最大重连次数，重连失败。通知上层");
        }else{
            NSTimeInterval interval = connectPolicy.currentRetryCount * connectPolicy.connectDelay;
            weakSelf.reconnectTimer = [NSTimer heScheduledTimerWithTimeInterval:interval repeats:NO handlerBlock:^{
                [weakSelf openConnection];
            }];
            
            DebugLog(@"开启重连定时器，重连次数:%lu of %lu, 延时:%f",(unsigned long)connectPolicy.currentRetryCount,connectPolicy.maxRetryCount,interval);
        }
    }
}

- (void)stopConnectTimer{
    if (self.reconnectTimer) {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
    }
}

#pragma mark - 心跳


#pragma mark - private method
- (BOOL)isOnSocketQueue{
    return dispatch_get_specific(_IsOnSocketQueueOrTargetQueueKey) != NULL;
}

- (void)dispatchOnSocketQueue:(dispatch_block_t)block async:(BOOL)async{
    if ([self isOnSocketQueue]) {
        @autoreleasepool {
            block();
        }
        return;
    }
    
    if (async) {
        dispatch_async([self socketQueue], ^{
            @autoreleasepool {
                block();
            }
        });
        return;
    }
    
    dispatch_sync([self socketQueue], ^{
        @autoreleasepool {
            block();
        }
    });
}


@end

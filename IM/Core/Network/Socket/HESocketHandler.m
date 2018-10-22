//
//  HESocketHandler.m
//  IM
//
//  Created by jmhe on 2018/10/17.
//  Copyright © 2018 贺俊孟. All rights reserved.
//

#import "HESocketHandler.h"
#import "GCDAsyncSocket.h"
#import "HETCPSocketService.h"
#import "HEMulticastDelegate.h"

@interface HESocketHandler()<GCDAsyncSocketDelegate>
{
    void *socketQueueTag;
}

@property (nonatomic, strong) dispatch_queue_t socketQueue;

//初始化聊天
@property (strong , nonatomic)GCDAsyncSocket *socket;
//TCP地址
@property (nonatomic,copy)NSString *host;
//TCP端口后
@property (nonatomic,assign)uint16_t port;
//心跳定时器
@property (nonatomic, strong) dispatch_source_t beatTimer;
//发送心跳次数
@property (nonatomic, assign) NSInteger sentBeatCount;
//服务器列表
@property (nonatomic,strong)NSArray<HETCPSocketService *> *serviceArray;

@property (nonatomic,strong)NSMutableArray *registeredModules;

/**多播代理*/
@property (nonatomic,strong)HEMulticastDelegate *multicastDelegate;
@end

@implementation HESocketHandler

+(instancetype) shareInstance{
    static HESocketHandler *Handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Handler = [[HESocketHandler alloc]init];
    });
    return Handler;
}

- (instancetype)init{
    if (self = [super init]) {
        const char *socketQueueLabel = [[NSString stringWithFormat:@"%p_socketDelegateQueue", self] cStringUsingEncoding:NSUTF8StringEncoding];
        _socketQueue = dispatch_queue_create(socketQueueLabel, DISPATCH_QUEUE_SERIAL);
        socketQueueTag = &socketQueueTag;
        dispatch_queue_set_specific(_socketQueue, socketQueueTag, socketQueueTag, NULL);
        _socket = [self newSocket];
        _state = HESocketHandlerState_UnConnected;      //默认状态未连接
    }
    return self;
}

- (GCDAsyncSocket *)newSocket{
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
    [socket setAutoDisconnectOnClosedReadStream:NO];    //设置默认关闭读取
    return socket;
}

#pragma mark - 连接
- (BOOL)connectWithTimeout:(NSTimeInterval)timeout error:(NSError **)errPtr{
    __block BOOL result = NO;
    __block NSError *err = nil;
    dispatch_block_t block = ^{ @autoreleasepool {
        if (self.state != HESocketHandlerState_UnConnected) {
            NSString *errMsg = @"Attempting to connect while already connected or connecting.";
            NSDictionary *info = @{NSLocalizedDescriptionKey : errMsg};
            err = [NSError errorWithDomain:HESocketHandlerErrorDomain code:HESocketHandlerInvalidState userInfo:info];
            result = NO;
            return;
        }
        
        // Open TCP connection to the configured hostName.
        self.state = HESocketHandlerState_Connecting;
        NSError *connectErr = nil;
         [self.socket setDelegate:self delegateQueue:self.socketQueue];
        result = [self.socket connectToHost:self.host onPort:self.port withTimeout:timeout error:&connectErr];
        if (!result){
            err = connectErr;
            self.state = HESocketHandlerState_UnConnected;
        }
    }};
    
    if (dispatch_get_specific(socketQueueTag)){
        block();
    }else{
        dispatch_sync(self.socketQueue, block);
    }
    if (errPtr) {
        *errPtr = err;
    }
    return result;
}

- (void)setHost:(NSString *)host port:(uint16_t)port{
    dispatch_block_t block = ^{ @autoreleasepool {
        self.host = host;
        self.port = port;
    }};
    if (dispatch_get_specific(socketQueueTag)){
        block();
    }else{
        dispatch_sync(self.socketQueue, block);
    }
}


- (BOOL)isConnected{
    return self.socket.isConnected;
}

- (void)disconnect{
    if (!self.socket.isConnected) {
        return;
    }
    [self.socket setDelegate:nil delegateQueue:nil];
    [self.socket disconnect];
    self.state = HESocketHandlerState_UnConnected;
}

- (void)tryToReconnect{
    
}

#pragma mark - Module  拓展HESocketHandler功能
- (void)registerModule:(HESocketModule *)module{
    dispatch_block_t block = ^{ @autoreleasepool {
        [self.registeredModules addObject:module];
        module.socketHandler = self;
        [self.multicastDelegate addDelegate:module delegateQueue:module.modultQueue];
    }};
    if (dispatch_get_specific(socketQueueTag)){
        block();
    }else{
        dispatch_sync(self.socketQueue, block);
    }
}

- (void)unregisterModule:(HESocketModule *)module{
    dispatch_block_t block = ^{ @autoreleasepool {
        module.socketHandler = nil;
        [self.registeredModules removeObject:module];
        [self.multicastDelegate removeDelegate:module];
    }};
    if (dispatch_get_specific(socketQueueTag)){
        block();
    }else{
        dispatch_sync(self.socketQueue, block);
    }
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue toModulesOfClass:(Class)aClass{
    dispatch_block_t block = ^{ @autoreleasepool {
        for (HESocketModule *module in self.registeredModules) {
            if ([module isKindOfClass:aClass]){
                [module.multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
            }
        }
    }};
    if (dispatch_get_specific(socketQueueTag)){
        block();
    }else{
        dispatch_sync(self.socketQueue, block);
    }
}

- (void)removeDelegate:(id)delegate fromModulesOfClass:(Class)aClass{
    dispatch_block_t block = ^{ @autoreleasepool {
        for (HESocketModule *module in self.registeredModules) {
            if (aClass == NULL || [module isKindOfClass:aClass]) {
                [module.multicastDelegate removeDelegate:delegate];
            }
        }
    }};
    if (dispatch_get_specific(socketQueueTag)){
        block();
    }else{
        dispatch_sync(self.socketQueue, block);
    }
}


#pragma mark - 心跳


#pragma mark - 发送数据
- (void)writeData:(NSData *)data{
    [self writeData:data withTimeout:-1];
}

- (void)writeData:(NSData *)data withTimeout:(NSTimeInterval)timeout{
    [self.socket writeData:data withTimeout:timeout tag:110];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    self.state = HESocketHandlerState_Connected;
    NSLog(@"连接成功,host:%@,port:%d",host,port);
}



- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error {
    DebugLog(@"TCPSocket连接已断开...%@", error);
    NSLog(@"断开连接,host:%@,port:%d",sock.localHost,sock.localPort);
//    [self tryToReconnect];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"didWriteDataWithTag  tag:%ld",tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReadData： %@",msg);
}

#pragma mark - 接受数据

#pragma mark - getter
- (NSMutableArray *)registeredModules{
    if (_registeredModules) {
        return _registeredModules;
    }
    _registeredModules = [[NSMutableArray alloc]init];
    return _registeredModules;
}
@end
